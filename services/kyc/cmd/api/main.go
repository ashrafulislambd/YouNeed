package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"kyc/internal/config"
	"kyc/internal/handlers"
	"kyc/internal/middleware"
	"kyc/internal/repository"
	"kyc/internal/services"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	// Create uploads directory
	if err := os.MkdirAll("uploads", 0755); err != nil {
		log.Fatal("Failed to create uploads directory")
	}

	cfg := config.LoadConfig()

	// Connect to MongoDB
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(cfg.MongoURI))
	if err != nil {
		log.Fatalf("Failed to connect to MongoDB: %v", err)
	}
	defer func() {
		if err = client.Disconnect(ctx); err != nil {
			log.Printf("Failed to disconnect from MongoDB: %v", err)
		}
	}()

	db := client.Database(cfg.DBName)
	kycRepo := repository.NewKYCRepository(db)

	if err := kycRepo.EnsureIndices(ctx); err != nil {
		log.Printf("Warning: Failed to ensure indices: %v", err)
	}

	authMiddleware := middleware.NewAuthMiddleware(cfg.AuthServiceURL)
	// Verify Service
	verifyService := services.NewVerificationService(cfg.HuggingFaceAPIKey, cfg.HuggingFaceModelURL, cfg.HuggingFaceModelID)

	kycHandler := handlers.NewKYCHandler(kycRepo, verifyService)

	r := gin.Default()

	// Enable CORS
	r.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
	}))

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	// Public routes (none for now)

	// Protected routes
	api := r.Group("/kyc")
	api.Use(authMiddleware.RequireAuth())
	{
		api.POST("/submit", kycHandler.SubmitKYC)
		api.GET("/status", kycHandler.GetStatus)

		// Admin routes (Protected by same auth for now, should have role check ideally)
		admin := api.Group("/admin")
		{
			admin.GET("/pending", kycHandler.AdminGetPending)
			admin.PUT("/verify/:id", kycHandler.AdminVerify)
		}
	}

	// Graceful Shutdown
	srv := &http.Server{
		Addr:    ":" + cfg.Port,
		Handler: r,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("listen: %s\n", err)
		}
	}()

	// Wait for interrupt signal to gracefully shutdown the server with
	// a timeout of 5 seconds.
	quit := make(chan os.Signal, 1)
	// kill (no param) default send syscall.SIGTERM
	// kill -2 is syscall.SIGINT
	// kill -9 is syscall.SIGKILL but can't be catch, so don't need add it
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	log.Println("Shutting down server...")

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer shutdownCancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		log.Fatal("Server forced to shutdown: ", err)
	}

	log.Println("Server exiting")
}

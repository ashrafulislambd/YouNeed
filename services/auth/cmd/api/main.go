package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"auth/internal/auth"
	"auth/internal/config"
	"auth/internal/handlers"
	"auth/internal/middleware"
	"auth/internal/repository"

	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load config: %v", err)
	}

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
	userRepo := repository.NewUserRepository(db)
	
	// Ensure indices
	if err := userRepo.EnsureIndices(ctx); err != nil {
		log.Printf("Warning: Failed to ensure indices: %v", err)
	}

	jwtService := auth.NewJWTService(cfg.JWTSecret)
	authHandler := handlers.NewAuthHandler(userRepo, jwtService)
	profileHandler := handlers.NewProfileHandler(userRepo)

	// Setup Router
	r := gin.Default()
	
	// Enable CORS
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:*", "http://127.0.0.1:*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))
	
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	authRoutes := r.Group("/auth")
	{
		authRoutes.POST("/register", authHandler.Register)
		authRoutes.POST("/login", authHandler.Login)
	}

	profileRoutes := r.Group("/profile")
	profileRoutes.Use(middleware.AuthMiddleware(jwtService))
	{
		profileRoutes.GET("", profileHandler.GetProfile)
		profileRoutes.PUT("", profileHandler.UpdateProfile)
	}

	log.Printf("Server starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"credit/internal/config"
	"credit/internal/handlers"
	"credit/internal/repository"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
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
	creditRepo := repository.NewCreditRepository(db)
	creditHandler := handlers.NewCreditHandler(creditRepo)

	r := gin.Default()
	r.Use(cors.Default()) // Enable CORS

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	creditRoutes := r.Group("/credit")
	{
		creditRoutes.GET("/balance/:userId", creditHandler.GetBalance)
		creditRoutes.POST("/add", creditHandler.AddCredit)
		creditRoutes.POST("/deduct", creditHandler.DeductCredit)
	}

	log.Printf("Credit Service starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

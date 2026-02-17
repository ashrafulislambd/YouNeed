package main

import (
	"context"
	"log"
	"net/http"
	"time"

	"otp/internal/config"
	"otp/internal/domain"
	"otp/internal/handlers"
	"otp/internal/providers"
	"otp/internal/repository"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
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
	otpRepo := repository.NewOTPRepository(db)

	// --- Dependency Injection: select OTP provider based on config ---
	var sender domain.OTPSender
	switch cfg.OTPProvider {
	case "whatsapp":
		log.Println("OTP Provider: WhatsApp Cloud API (PAID)")
		sender = providers.NewWhatsAppSender(
			cfg.WhatsAppToken,
			cfg.WhatsAppPhoneNumberID,
			cfg.WhatsAppTemplateName,
		)
	default:
		log.Println("OTP Provider: Console Logger (FREE)")
		sender = providers.NewConsoleSender()
	}

	otpHandler := handlers.NewOTPHandler(otpRepo, sender, cfg.OTPExpiryMinutes)

	// Setup Router
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
		c.JSON(http.StatusOK, gin.H{"status": "ok", "provider": cfg.OTPProvider})
	})

	otpRoutes := r.Group("/otp")
	{
		otpRoutes.POST("/send", otpHandler.SendOTP)
		otpRoutes.POST("/verify", otpHandler.VerifyOTP)
	}

	log.Printf("OTP Service starting on port %s", cfg.Port)
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

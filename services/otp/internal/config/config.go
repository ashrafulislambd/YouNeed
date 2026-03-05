package config

import (
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

// Config holds all service configuration loaded from environment variables.
type Config struct {
	Port     string
	MongoURI string
	DBName   string

	// OTP settings
	OTPProvider      string // "console" (default) or "whatsapp"
	OTPExpiryMinutes int

	// WhatsApp settings (only needed if OTPProvider == "whatsapp")
	WhatsAppToken         string
	WhatsAppPhoneNumberID string
	WhatsAppTemplateName  string
}

// LoadConfig reads configuration from environment variables.
func LoadConfig() (*Config, error) {
	_ = godotenv.Load()

	expiryMinutes, _ := strconv.Atoi(getEnv("OTP_EXPIRY_MINUTES", "5"))

	return &Config{
		Port:                  getEnv("PORT", "8084"),
		MongoURI:              getEnv("MONGO_URI", "mongodb://localhost:27017"),
		DBName:                getEnv("DB_NAME", "youneed_otp"),
		OTPProvider:           getEnv("OTP_PROVIDER", "console"),
		OTPExpiryMinutes:      expiryMinutes,
		WhatsAppToken:         getEnv("WHATSAPP_TOKEN", ""),
		WhatsAppPhoneNumberID: getEnv("WHATSAPP_PHONE_NUMBER_ID", ""),
		WhatsAppTemplateName:  getEnv("WHATSAPP_TEMPLATE_NAME", "otp_verification"),
	}, nil
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

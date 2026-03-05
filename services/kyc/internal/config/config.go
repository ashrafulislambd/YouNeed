package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Port                string
	MongoURI            string
	DBName              string
	AuthServiceURL      string
	HuggingFaceAPIKey   string
	HuggingFaceModelURL string
	HuggingFaceModelID  string
}

func LoadConfig() *Config {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using defaults")
	}

	return &Config{
		Port:                getEnv("PORT", "8081"),
		MongoURI:            getEnv("MONGO_URI", "mongodb://localhost:27017"),
		DBName:              getEnv("DB_NAME", "kyc_db"),
		AuthServiceURL:      getEnv("AUTH_SERVICE_URL", "http://localhost:8080"),
		HuggingFaceAPIKey:   getEnv("HUGGINGFACE_API_KEY", ""),
		HuggingFaceModelURL: getEnv("HUGGINGFACE_ROUTER_URL", "https://router.huggingface.co/v1/chat/completions"),
		HuggingFaceModelID:  getEnv("HUGGINGFACE_MODEL_ID", "google/gemma-3-27b-it:nebius"),
	}
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

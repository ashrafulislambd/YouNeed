package config

import (
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Port     string
	MongoURI string
	DBName   string
}

func LoadConfig() (*Config, error) {
	_ = godotenv.Load() // Ignore error if .env file not valid, rely on env vars

	return &Config{
		Port:     getEnv("PORT", "8081"),
		MongoURI: getEnv("MONGO_URI", "mongodb://localhost:27017"),
		DBName:   getEnv("DB_NAME", "youneed_credit"),
	}, nil
}

func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

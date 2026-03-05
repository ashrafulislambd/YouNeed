package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

// Config holds the application configuration.
type Config struct {
	Port      string
	MongoURI  string
	DBName    string
	JWTSecret string
}

// LoadConfig loads configuration from environment variables.
// It also attempts to load from a .env file if present.
func LoadConfig() (*Config, error) {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	config := &Config{
		Port:      getEnv("PORT", "8080"),
		MongoURI:  getEnv("MONGO_URI", "mongodb://localhost:27017"),
		DBName:    getEnv("DB_NAME", "auth_db"),
		JWTSecret: getEnv("JWT_SECRET", "super-secret-key"),
	}

	return config, nil
}

// getEnv retrieves the value of the environment variable named by the key.
// It returns the value, which will be the default value if the variable is not present.
func getEnv(key, fallback string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return fallback
}

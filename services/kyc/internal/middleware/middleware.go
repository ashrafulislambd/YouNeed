package middleware

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

type AuthMiddleware struct {
	authServiceURL string
}

func NewAuthMiddleware(authServiceURL string) *AuthMiddleware {
	return &AuthMiddleware{
		authServiceURL: authServiceURL,
	}
}

func (m *AuthMiddleware) RequireAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
			return
		}

		if !strings.HasPrefix(authHeader, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid authorization header format"})
			return
		}

		// Call Auth Service to validate token
		// Ensure clean URL construction
		baseURL := strings.TrimSuffix(m.authServiceURL, "/")
		// If the user included /profile or /auth in the env, this logic needs to be smart.
		// Detailed debugging:
		authURL := fmt.Sprintf("%s/profile", baseURL)

		req, err := http.NewRequest("GET", authURL, nil)
		if err != nil {
			log.Printf("Error creating request to auth service: %v", err)
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to create auth request"})
			return
		}

		req.Header.Set("Authorization", authHeader)
		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			log.Printf("Error calling auth service (%s): %v", authURL, err)
			c.AbortWithStatusJSON(http.StatusServiceUnavailable, gin.H{"error": "Auth service unavailable"})
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			log.Printf("Auth service (%s) returned status: %d", authURL, resp.StatusCode)
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token", "details": fmt.Sprintf("Auth service returned %d", resp.StatusCode)})
			return
		}

		// Parse user ID from response
		var userResp struct {
			ID    string `json:"id"`
			Email string `json:"email"`
		}
		if err := json.NewDecoder(resp.Body).Decode(&userResp); err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "Failed to parse auth response"})
			return
		}

		c.Set("userID", userResp.ID)
		c.Next()
	}
}

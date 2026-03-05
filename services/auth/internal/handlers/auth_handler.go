package handlers

import (
	"net/http"

	"auth/internal/auth"
	"auth/internal/models"
	"auth/internal/repository"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// AuthHandler handles authentication requests.
type AuthHandler struct {
	repo       *repository.UserRepository
	jwtService *auth.JWTService
}

// NewAuthHandler creates a new AuthHandler.
func NewAuthHandler(repo *repository.UserRepository, jwtService *auth.JWTService) *AuthHandler {
	return &AuthHandler{
		repo:       repo,
		jwtService: jwtService,
	}
}

// RegisterRequest represents the registration payload.
type RegisterRequest struct {
	Name     string `json:"name" binding:"required"`
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

// LoginRequest represents the login payload.
type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// Register handles user registration.
// @Summary Register a new user
// @Description Creates a new user account
// @Tags auth
// @Accept json
// @Produce json
// @Param request body RegisterRequest true "Registration Request"
// @Success 201 {object} models.User
// @Failure 400 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Check if user already exists
	if _, err := h.repo.GetUserByEmail(c.Request.Context(), req.Email); err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "User with this email already exists"})
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	user := &models.User{
		Name:         req.Name,
		Email:        req.Email,
		PasswordHash: string(hashedPassword),
	}

	if err := h.repo.CreateUser(c.Request.Context(), user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	c.JSON(http.StatusCreated, user)
}

// Login handles user login.
// @Summary Login
// @Description Authenticates a user and returns a JWT
// @Tags auth
// @Accept json
// @Produce json
// @Param request body LoginRequest true "Login Request"
// @Success 200 {object} map[string]string
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Router /auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.repo.GetUserByEmail(c.Request.Context(), req.Email)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	token, err := h.jwtService.GenerateToken(user.ID.Hex())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token})
}

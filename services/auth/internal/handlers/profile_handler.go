package handlers

import (
	"net/http"

	"auth/internal/repository"

	"github.com/gin-gonic/gin"
)

// ProfileHandler handles user profile requests.
type ProfileHandler struct {
	repo *repository.UserRepository
}

// NewProfileHandler creates a new ProfileHandler.
func NewProfileHandler(repo *repository.UserRepository) *ProfileHandler {
	return &ProfileHandler{
		repo: repo,
	}
}

// UpdateProfileRequest represents the profile update payload.
type UpdateProfileRequest struct {
	Name string `json:"name" binding:"required"`
}

// GetProfile returns the authenticated user's profile.
// @Summary Get Profile
// @Description Retrieves the profile of the current user
// @Tags profile
// @Accept json
// @Produce json
// @Success 200 {object} models.User
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Router /profile [get]
func (h *ProfileHandler) GetProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	user, err := h.repo.GetUserByID(c.Request.Context(), userID.(string))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// UpdateProfile updates the authenticated user's profile.
// @Summary Update Profile
// @Description Updates the profile of the current user
// @Tags profile
// @Accept json
// @Produce json
// @Param request body UpdateProfileRequest true "Update Profile Request"
// @Success 200 {object} models.User
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /profile [put]
func (h *ProfileHandler) UpdateProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var req UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.repo.GetUserByID(c.Request.Context(), userID.(string))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	user.Name = req.Name
	if err := h.repo.UpdateUser(c.Request.Context(), user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update profile"})
		return
	}

	c.JSON(http.StatusOK, user)
}

package handlers

import (
	"fmt"
	"net/http"
	"path/filepath"
	"time"

	"kyc/internal/models"
	"kyc/internal/repository"
	"kyc/internal/services"

	"github.com/gin-gonic/gin"
)

type KYCHandler struct {
	repo          *repository.KYCRepository
	verifyService *services.VerificationService
}

func NewKYCHandler(repo *repository.KYCRepository, verifyService *services.VerificationService) *KYCHandler {
	return &KYCHandler{
		repo:          repo,
		verifyService: verifyService,
	}
}

type SubmitKYCRequest struct {
	Type           string `form:"type" binding:"required"`
	DocumentNumber string `form:"document_number" binding:"required"`
}

func (h *KYCHandler) SubmitKYC(c *gin.Context) {
	userID := c.GetString("userID")

	// Check if already exists
	existing, err := h.repo.GetByUserID(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}
	if existing != nil {
		c.JSON(http.StatusConflict, gin.H{"error": "KYC request already exists for this user"})
		return
	}

	var req SubmitKYCRequest
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Handle File Upload
	form, _ := c.MultipartForm()
	files := form.File["images"]
	if len(files) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No images provided. Please upload a document image."})
		return
	}
	var imagePaths []string

	for _, file := range files {
		// Save file locally for now (simulate S3)
		filename := fmt.Sprintf("%s_%d_%s", userID, time.Now().Unix(), filepath.Base(file.Filename))
		path := filepath.Join("uploads", filename)
		if err := c.SaveUploadedFile(file, path); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save file"})
			return
		}
		imagePaths = append(imagePaths, path)

		// Verify Image using AI
		isValid, err := h.verifyService.VerifyImage(path)
		if err != nil {
			fmt.Printf("AI Verification Error: %v\n", err)
			c.JSON(http.StatusServiceUnavailable, gin.H{"error": "AI Verification service unavailable", "details": err.Error()})
			return
		}

		if !isValid {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Image rejected: Document irrelevant or not recognized as ID/Passport"})
			return
		}
	}

	kyc := &models.KYCRequest{
		UserID:         userID,
		Type:           req.Type,
		DocumentNumber: req.DocumentNumber,
		Images:         imagePaths,
	}

	if err := h.repo.Create(c.Request.Context(), kyc); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create KYC request"})
		return
	}

	c.JSON(http.StatusCreated, kyc)
}

func (h *KYCHandler) GetStatus(c *gin.Context) {
	userID := c.GetString("userID")
	kyc, err := h.repo.GetByUserID(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}
	if kyc == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "KYC record not found"})
		return
	}

	c.JSON(http.StatusOK, kyc)
}

// Admin Handlers

func (h *KYCHandler) AdminGetPending(c *gin.Context) {
	requests, err := h.repo.GetPending(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}
	c.JSON(http.StatusOK, requests)
}

type VerificationRequest struct {
	Status        string `json:"status" binding:"required,oneof=APPROVED REJECTED"`
	Clarification string `json:"clarification"`
}

func (h *KYCHandler) AdminVerify(c *gin.Context) {
	id := c.Param("id")
	var req VerificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.repo.UpdateStatus(c.Request.Context(), id, models.KYCStatus(req.Status), req.Clarification); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update status"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "KYC status updated"})
}

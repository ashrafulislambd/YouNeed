package handlers

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"net/http"
	"time"

	"otp/internal/domain"
	"otp/internal/models"
	"otp/internal/repository"

	"github.com/gin-gonic/gin"
)

// OTPHandler handles OTP send/verify requests.
// It depends on the domain.OTPSender interface, NOT on any concrete provider.
type OTPHandler struct {
	repo          *repository.OTPRepository
	sender        domain.OTPSender
	expiryMinutes int
}

// NewOTPHandler creates a new handler with the given repository and sender.
// The sender is injected — it can be ConsoleSender, WhatsAppSender, or any future provider.
func NewOTPHandler(repo *repository.OTPRepository, sender domain.OTPSender, expiryMinutes int) *OTPHandler {
	return &OTPHandler{
		repo:          repo,
		sender:        sender,
		expiryMinutes: expiryMinutes,
	}
}

// SendOTPRequest is the request body for sending OTP.
type SendOTPRequest struct {
	Phone string `json:"phone" binding:"required"`
}

// VerifyOTPRequest is the request body for verifying OTP.
type VerifyOTPRequest struct {
	Phone string `json:"phone" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

// SendOTP generates a 6-digit OTP, stores it, and delivers it via the configured sender.
func (h *OTPHandler) SendOTP(c *gin.Context) {
	var req SendOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Generate a cryptographically secure 6-digit code
	code, err := generateCode(6)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate OTP"})
		return
	}

	// Store the OTP record
	record := &models.OTPRecord{
		Phone:     req.Phone,
		Code:      code,
		ExpiresAt: time.Now().Add(time.Duration(h.expiryMinutes) * time.Minute),
		Verified:  false,
	}

	if err := h.repo.Create(c.Request.Context(), record); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to store OTP"})
		return
	}

	// Send via the injected provider (console, whatsapp, etc.)
	if err := h.sender.SendOTP(c.Request.Context(), req.Phone, code); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to send OTP"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "OTP sent successfully",
	})
}

// VerifyOTP validates the user-provided code against the stored OTP.
func (h *OTPHandler) VerifyOTP(c *gin.Context) {
	var req VerifyOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Find the latest valid OTP for this phone
	record, err := h.repo.FindLatestByPhone(c.Request.Context(), req.Phone)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{
			"verified": false,
			"message":  "No valid OTP found. Please request a new one.",
		})
		return
	}

	// Check if the code matches
	if record.Code != req.Code {
		c.JSON(http.StatusOK, gin.H{
			"verified": false,
			"message":  "Invalid OTP code",
		})
		return
	}

	// Mark as verified
	if err := h.repo.MarkVerified(c.Request.Context(), record.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to verify OTP"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"verified": true,
		"message":  "OTP verified successfully",
	})
}

// generateCode creates a cryptographically secure random numeric code of the given length.
func generateCode(length int) (string, error) {
	code := ""
	for i := 0; i < length; i++ {
		n, err := rand.Int(rand.Reader, big.NewInt(10))
		if err != nil {
			return "", err
		}
		code += fmt.Sprintf("%d", n.Int64())
	}
	return code, nil
}

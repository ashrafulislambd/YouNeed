package handlers

import (
	"net/http"
	"payment/internal/models"
	"payment/internal/repository"

	"github.com/gin-gonic/gin"
)

type PaymentHandler struct {
	repo repository.PaymentRepository
}

func NewPaymentHandler(repo repository.PaymentRepository) *PaymentHandler {
	return &PaymentHandler{repo: repo}
}

func (h *PaymentHandler) InitiatePayment(c *gin.Context) {
	var req models.Transaction
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	req.Status = models.PaymentStatusCompleted // Simulating instant completion for now
	// Real world: Intergrate with payment gateway like Stripe/PayPal here

	err := h.repo.Create(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, req)
}

func (h *PaymentHandler) GetHistory(c *gin.Context) {
	userID := c.Param("userId")
	history, err := h.repo.GetByUserID(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return empty list instead of null if no history
	if history == nil {
		history = []models.Transaction{}
	}

	c.JSON(http.StatusOK, history)
}

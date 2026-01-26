package handlers

import (
	"credit/internal/repository"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CreditHandler struct {
	repo repository.CreditRepository
}

func NewCreditHandler(repo repository.CreditRepository) *CreditHandler {
	return &CreditHandler{repo: repo}
}

func (h *CreditHandler) GetBalance(c *gin.Context) {
	userID := c.Param("userId")
	account, err := h.repo.GetByUserID(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if account == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Account not found"})
		return
	}
	c.JSON(http.StatusOK, account)
}

func (h *CreditHandler) AddCredit(c *gin.Context) {
	var req struct {
		UserID string  `json:"user_id" binding:"required"`
		Amount float64 `json:"amount" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Simple upside logic: if account doesn't exist, create it (handled by repository Upsert mostly, but let's be explicit if needed)
	// For now using UpdateBalance with upsert in repo
	err := h.repo.UpdateBalance(c.Request.Context(), req.UserID, req.Amount)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "credited"})
}

func (h *CreditHandler) DeductCredit(c *gin.Context) {
	// Similar to Add, but negative amount or specific logic check
	var req struct {
		UserID string  `json:"user_id" binding:"required"`
		Amount float64 `json:"amount" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Check balance first
	account, err := h.repo.GetByUserID(c.Request.Context(), req.UserID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if account == nil || account.Balance < req.Amount {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Insufficient funds"})
		return
	}

	err = h.repo.UpdateBalance(c.Request.Context(), req.UserID, -req.Amount)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "deducted"})
}

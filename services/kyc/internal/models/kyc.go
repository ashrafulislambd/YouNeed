package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type KYCStatus string

const (
	StatusPending  KYCStatus = "PENDING"
	StatusApproved KYCStatus = "APPROVED"
	StatusRejected KYCStatus = "REJECTED"
)

type KYCRequest struct {
	ID             primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	UserID         string             `bson:"user_id" json:"user_id"`
	Type           string             `bson:"type" json:"type" binding:"required,oneof=NID PASSPORT"`
	DocumentNumber string             `bson:"document_number" json:"document_number" binding:"required"`
	Images         []string           `bson:"images" json:"images"` // URLs or file paths
	Status         KYCStatus          `bson:"status" json:"status"`
	Clarification  string             `bson:"clarification,omitempty" json:"clarification,omitempty"`
	CreatedAt      time.Time          `bson:"created_at" json:"created_at"`
	UpdatedAt      time.Time          `bson:"updated_at" json:"updated_at"`
}

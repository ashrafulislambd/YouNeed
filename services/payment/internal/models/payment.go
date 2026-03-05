package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type PaymentStatus string

const (
	PaymentStatusPending   PaymentStatus = "PENDING"
	PaymentStatusCompleted PaymentStatus = "COMPLETED"
	PaymentStatusFailed    PaymentStatus = "FAILED"
)

type Transaction struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	UserID    string             `bson:"user_id" json:"user_id"`
	Amount    float64            `bson:"amount" json:"amount"`
	Currency  string             `bson:"currency" json:"currency"`
	Status    PaymentStatus      `bson:"status" json:"status"`
	Type      string             `bson:"type" json:"type"` // e.g., "DEPOSIT", "WITHDRAWAL", "PAYMENT"
	Reference string             `bson:"reference" json:"reference"`
	CreatedAt time.Time          `bson:"created_at" json:"created_at"`
	UpdatedAt time.Time          `bson:"updated_at" json:"updated_at"`
}

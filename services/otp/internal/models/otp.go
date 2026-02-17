package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// OTPRecord represents an OTP entry stored in the database.
type OTPRecord struct {
	ID        primitive.ObjectID `bson:"_id,omitempty" json:"id"`
	Phone     string             `bson:"phone" json:"phone"`
	Code      string             `bson:"code" json:"code"`
	ExpiresAt time.Time          `bson:"expires_at" json:"expires_at"`
	Verified  bool               `bson:"verified" json:"verified"`
	CreatedAt time.Time          `bson:"created_at" json:"created_at"`
}

// IsExpired checks whether the OTP has passed its expiry time.
func (o *OTPRecord) IsExpired() bool {
	return time.Now().After(o.ExpiresAt)
}

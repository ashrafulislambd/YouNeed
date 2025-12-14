package models

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

// User represents a user in the system.
type User struct {
	// ID is the unique identifier for the user.
	ID primitive.ObjectID `bson:"_id,omitempty" json:"id"`

	// Name is the full name of the user.
	Name string `bson:"name" json:"name"`

	// Email is the unique email address of the user.
	Email string `bson:"email" json:"email"`

	// PasswordHash is the hashed password of the user.
	// It is not returned in JSON responses.
	PasswordHash string `bson:"password_hash" json:"-"`

	// CreatedAt is the timestamp when the user was created.
	CreatedAt time.Time `bson:"created_at" json:"created_at"`

	// UpdatedAt is the timestamp when the user was last updated.
	UpdatedAt time.Time `bson:"updated_at" json:"updated_at"`
}

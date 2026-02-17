package repository

import (
	"context"
	"time"

	"otp/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

// OTPRepository handles database operations for OTP records.
type OTPRepository struct {
	collection *mongo.Collection
}

// NewOTPRepository creates a new repository instance.
func NewOTPRepository(db *mongo.Database) *OTPRepository {
	return &OTPRepository{
		collection: db.Collection("otps"),
	}
}

// Create inserts a new OTP record into the database.
func (r *OTPRepository) Create(ctx context.Context, record *models.OTPRecord) error {
	record.CreatedAt = time.Now()
	result, err := r.collection.InsertOne(ctx, record)
	if err != nil {
		return err
	}
	record.ID = result.InsertedID.(primitive.ObjectID)
	return nil
}

// FindLatestByPhone returns the most recent unexpired, unverified OTP for a phone number.
func (r *OTPRepository) FindLatestByPhone(ctx context.Context, phone string) (*models.OTPRecord, error) {
	filter := bson.M{
		"phone":      phone,
		"verified":   false,
		"expires_at": bson.M{"$gt": time.Now()},
	}
	opts := options.FindOne().SetSort(bson.D{{Key: "created_at", Value: -1}})

	var record models.OTPRecord
	err := r.collection.FindOne(ctx, filter, opts).Decode(&record)
	if err != nil {
		return nil, err
	}
	return &record, nil
}

// MarkVerified marks an OTP record as verified by its ID.
func (r *OTPRepository) MarkVerified(ctx context.Context, id primitive.ObjectID) error {
	_, err := r.collection.UpdateOne(
		ctx,
		bson.M{"_id": id},
		bson.M{"$set": bson.M{"verified": true}},
	)
	return err
}

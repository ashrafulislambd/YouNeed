package repository

import (
	"context"
	"errors"
	"time"

	"kyc/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type KYCRepository struct {
	collection *mongo.Collection
}

func NewKYCRepository(db *mongo.Database) *KYCRepository {
	return &KYCRepository{
		collection: db.Collection("kyc_requests"),
	}
}

func (r *KYCRepository) Create(ctx context.Context, kyc *models.KYCRequest) error {
	kyc.CreatedAt = time.Now()
	kyc.UpdatedAt = time.Now()
	kyc.Status = models.StatusPending

	res, err := r.collection.InsertOne(ctx, kyc)
	if err != nil {
		return err
	}
	kyc.ID = res.InsertedID.(primitive.ObjectID)
	return nil
}

func (r *KYCRepository) GetByUserID(ctx context.Context, userID string) (*models.KYCRequest, error) {
	var kyc models.KYCRequest
	err := r.collection.FindOne(ctx, bson.M{"user_id": userID}).Decode(&kyc)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return nil, nil // Return nil if no KYC found
		}
		return nil, err
	}
	return &kyc, nil
}

func (r *KYCRepository) GetPending(ctx context.Context) ([]models.KYCRequest, error) {
	cursor, err := r.collection.Find(ctx, bson.M{"status": models.StatusPending})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var requests []models.KYCRequest
	if err = cursor.All(ctx, &requests); err != nil {
		return nil, err
	}
	return requests, nil
}

func (r *KYCRepository) UpdateStatus(ctx context.Context, id string, status models.KYCStatus, clarification string) error {
	objID, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return errors.New("invalid id")
	}

	update := bson.M{
		"$set": bson.M{
			"status":        status,
			"clarification": clarification,
			"updated_at":    time.Now(),
		},
	}

	_, err = r.collection.UpdateOne(ctx, bson.M{"_id": objID}, update)
	return err
}

func (r *KYCRepository) EnsureIndices(ctx context.Context) error {
	_, err := r.collection.Indexes().CreateOne(ctx, mongo.IndexModel{
		Keys:    bson.D{{Key: "user_id", Value: 1}},
		Options: options.Index().SetUnique(true),
	})
	return err
}

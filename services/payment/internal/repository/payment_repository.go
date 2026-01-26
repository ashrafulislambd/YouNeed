package repository

import (
	"context"
	"time"

	"payment/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type PaymentRepository interface {
	Create(ctx context.Context, transaction *models.Transaction) error
	GetByUserID(ctx context.Context, userID string) ([]models.Transaction, error)
}

type paymentRepository struct {
	collection *mongo.Collection
}

func NewPaymentRepository(db *mongo.Database) PaymentRepository {
	return &paymentRepository{
		collection: db.Collection("transactions"),
	}
}

func (r *paymentRepository) Create(ctx context.Context, transaction *models.Transaction) error {
	transaction.CreatedAt = time.Now()
	transaction.UpdatedAt = time.Now()
	// In a real scenario, default status could be PENDING
	if transaction.Status == "" {
		transaction.Status = models.PaymentStatusPending
	}
	_, err := r.collection.InsertOne(ctx, transaction)
	return err
}

func (r *paymentRepository) GetByUserID(ctx context.Context, userID string) ([]models.Transaction, error) {
	cursor, err := r.collection.Find(ctx, bson.M{"user_id": userID})
	if err != nil {
		return nil, err
	}
	defer cursor.Close(ctx)

	var transactions []models.Transaction
	if err = cursor.All(ctx, &transactions); err != nil {
		return nil, err
	}
	return transactions, nil
}

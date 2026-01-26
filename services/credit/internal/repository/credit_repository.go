package repository

import (
	"context"
	"time"

	"credit/internal/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type CreditRepository interface {
	GetByUserID(ctx context.Context, userID string) (*models.CreditAccount, error)
	Create(ctx context.Context, account *models.CreditAccount) error
	UpdateBalance(ctx context.Context, userID string, amount float64) error
}

type creditRepository struct {
	collection *mongo.Collection
}

func NewCreditRepository(db *mongo.Database) CreditRepository {
	return &creditRepository{
		collection: db.Collection("credits"),
	}
}

func (r *creditRepository) GetByUserID(ctx context.Context, userID string) (*models.CreditAccount, error) {
	var account models.CreditAccount
	err := r.collection.FindOne(ctx, bson.M{"user_id": userID}).Decode(&account)
	if err == mongo.ErrNoDocuments {
		return nil, nil
	}
	return &account, err
}

func (r *creditRepository) Create(ctx context.Context, account *models.CreditAccount) error {
	account.CreatedAt = time.Now()
	account.UpdatedAt = time.Now()
	_, err := r.collection.InsertOne(ctx, account)
	return err
}

func (r *creditRepository) UpdateBalance(ctx context.Context, userID string, amount float64) error {
	filter := bson.M{"user_id": userID}
	update := bson.M{
		"$inc": bson.M{"balance": amount},
		"$set": bson.M{"updated_at": time.Now()},
	}
	opts := options.Update().SetUpsert(true)
	_, err := r.collection.UpdateOne(ctx, filter, update, opts)
	return err
}

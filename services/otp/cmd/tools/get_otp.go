package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	uri := os.Getenv("MONGO_URI")
	if uri == "" {
		uri = "mongodb://localhost:27017"
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		log.Fatal(err)
	}
	defer client.Disconnect(ctx)

	coll := client.Database("youneed_otp").Collection("otps")

	var result struct {
		Phone string `bson:"phone"`
		Code  string `bson:"code"`
	}

	opts := options.FindOne().SetSort(bson.D{{"created_at", -1}})
	err = coll.FindOne(ctx, bson.M{"phone": "01712345678"}, opts).Decode(&result)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("VisualVerificationCode:%s\n", result.Code)
}

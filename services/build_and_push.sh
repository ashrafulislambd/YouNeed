#!/bin/bash

# Auth Service
echo "Building auth service..."
docker build -t ashraful42/auth-service:latest ./auth
docker push ashraful42/auth-service:latest

# Credit Service
echo "Building credit service..."
docker build -t ashraful42/credit-service:latest ./credit
docker push ashraful42/credit-service:latest

# KYC Service
echo "Building kyc service..."
docker build -t ashraful42/kyc-service:latest ./kyc
docker push ashraful42/kyc-service:latest

# Payment Service
echo "Building payment service..."
docker build -t ashraful42/payment-service:latest ./payment
docker push ashraful42/payment-service:latest

echo "All services built and pushed successfully!"

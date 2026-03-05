<<<<<<< HEAD
# qr_request_money

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# YouNeed Project

This repository contains the source code for the YouNeed application, including backend microservices and frontend applications.

## Backend Services

The backend consists of four microservices:
- **Auth Service**: Handles user registration and authentication.
- **Credit Service**: Manages user credits and balance.
- **Payment Service**: Processes payments and transactions.
- **KYC Service**: Handles Know Your Customer verification.

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed on your machine.
- [Docker Compose](https://docs.docker.com/compose/install/) installed.

### How to Run

There are two ways to run the backend services:

#### 1. Running with Pre-built Images (Recommended for Quick Start)
If you just want to run the backend without building the code yourself, use the pre-built images from Docker Hub.

1. Navigate to the `services` directory:
   ```bash
   cd services
   ```

2. Run the services using the Hub configuration:
   ```bash
   docker-compose -f docker-compose.hub.yml up -d
   ```

This will pull the latest images from `ashraful42/` repository and start all services along with MongoDB.

#### 2. Running Locally (For Development)
If you want to modify the code or build the images locally:

1. Navigate to the `services` directory:
   ```bash
   cd services
   ```

2. Build and start the services:
   ```bash
   docker-compose up --build -d
   ```

### Verification
Once the services are running, you can verify they are working by checking the health endpoints:

- **Auth Service**: `http://localhost:8080/health`
- **Credit Service**: `http://localhost:8081/health`
- **Payment Service**: `http://localhost:8082/health`
- **KYC Service**: `http://localhost:8083/health`

### API Documentation
Each service exposes its own API. Refer to the individual service directories for more details (if available).
>>>>>>> 3c4130a54ee16d7db81b8d459b809b8221944b4b

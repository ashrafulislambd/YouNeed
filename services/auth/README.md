# Auth Microservice

A dedicated microservice for handling user authentication (Signup, Login) and profile management. Built with Go, Gin, and MongoDB.

## 🚀 Data Flow & Architecture

- **Language**: Go 1.21+
- **Framework**: Gin Web Framework
- **Database**: MongoDB (Official Go Driver)
- **Auth**: JWT (JSON Web Tokens)
- **Security**: Bcrypt for password hashing

## 🛠 Prerequisites

- **Go**: v1.21 or higher
- **MongoDB**: v4.4 or higher (running locally or via Docker)

## 🏃 Quick Start

### 1. Clone & Setup

Navigate to the service directory:
```bash
cd services/auth
```

### 2. Environment Configuration

Create a `.env` file in the root of the directory (copy from example if available, or use the values below):

```env
PORT=8080
MONGO_URI=mongodb://localhost:27017
DB_NAME=auth_db
JWT_SECRET=your_secure_secret_key_here
```

### 3. Run the Service

**Development Mode:**
```bash
go run cmd/api/main.go
```

**Production Build:**
```bash
go build -o auth-service cmd/api/main.go
./auth-service
```

The server will start on `http://localhost:8080`.

## 🔌 API Endpoints

### Authentication

#### Register
Create a new user account.
- **URL**: `/auth/register`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "name": "Jane Doe",
    "email": "jane@example.com",
    "password": "securepassword123"
  }
  ```

#### Login
Authenticate and receive a JWT token.
- **URL**: `/auth/login`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "email": "jane@example.com",
    "password": "securepassword123"
  }
  ```
- **Response**:
  ```json
  {
    "token": "eyJhbGciOiJIUzI1Ni..."
  }
  ```

### Profile

#### Get Profile
Get the currently authenticated user's profile.
- **URL**: `/profile`
- **Method**: `GET`
- **Headers**: `Authorization: Bearer <token>`

#### Update Profile
Update user information.
- **URL**: `/profile`
- **Method**: `PUT`
- **Headers**: `Authorization: Bearer <token>`
- **Body**:
  ```json
  {
    "name": "Jane Smith"
  }
  ```

## 🧪 Testing

Run the unit tests:
```bash
go test ./...
```

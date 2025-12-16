# KYC Microservice

Microservice for **Know Your Customer (KYC)** verification. It handles document submission, secure storage, and **AI-powered automated verification**.

## 🚀 Features

- **Document Submission**: Secure upload for National ID (NID) or Passport images.
- **AI Gatekeeper**: 
  - Uses **Hugging Face Inference Router** (OpenAI-compatible protocol).
  - **Visual Question Answering (VQA)** model (`google/gemma-3-27b-it`) strictly verifies if the image is a valid identity document.
  - Automatically **rejects** irrelevant images (e.g., selfies, random objects).
- **Verification Workflow**:
  - `PENDING`: AI verified the image looks like an ID. Awaiting Admin.
  - `REJECTED`: AI (or Admin) flagged the image as invalid.
  - `APPROVED`: Admin confirmed the details.
- **Auth Integration**: Stateless validation via Auth Service.

## 🛠 Prerequisites

- **Go**: v1.21+
- **MongoDB**: v4.4+
- **Hugging Face API Key**: Required for AI verification.

## ⚙️ Configuration

Create a `.env` file in `services/kyc`:

```env
PORT=8081
MONOGO_URI=mongodb://localhost:27017
DB_NAME=kyc_db
AUTH_SERVICE_URL=http://localhost:8080
HUGGINGFACE_API_KEY=hf_xxxxxxxxxxxxxxxxx
# Optional (Defaults provided in code)
# HUGGINGFACE_ROUTER_URL=https://router.huggingface.co/v1/chat/completions
# HUGGINGFACE_MODEL_ID=google/gemma-3-27b-it:nebius
```

## 🧠 AI Verification Logic

This service uses a **Zero-Shot VQA** approach:
1.  Image is converted to **Base64** Data URI.
2.  Sent to **Hugging Face Router** (`v1/chat/completions`).
3.  Prompt: *"Analyze this image. Is it a valid official identity document...?"*
4.  Model Output strictly enforced: `VALID_PASSPORT`, `VALID_NID`, `VALID_LICENSE`, `VALID_VISA`, or `IRRELEVANT`.

## 🏃 Running

```bash
cd services/kyc
go mod tidy
go build -o kyc-service.exe cmd/api/main.go
./kyc-service.exe
```

## 🔌 API Endpoints

### User
- **POST** `/kyc/submit` (Multipart Form)
  - `type`: "NID" | "PASSPORT"
  - `document_number`: string
  - `images`: file (png/jpg/jpeg)
- **GET** `/kyc/status`

### Admin
- **GET** `/kyc/admin/pending`
- **PUT** `/kyc/admin/verify/:id`
  - Body: `{ "status": "APPROVED", "clarification": "Matched with database." }`

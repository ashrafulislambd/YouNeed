FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy
RUN go build -o kyc-service ./cmd/api

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/kyc-service .
# Create uploads directory as it might be needed
RUN mkdir -p uploads
COPY .env .

EXPOSE 8083

CMD ["./kyc-service"]

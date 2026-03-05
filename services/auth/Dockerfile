FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy
RUN go build -o auth-service ./cmd/api

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/auth-service .
COPY .env .

EXPOSE 8080

CMD ["./auth-service"]

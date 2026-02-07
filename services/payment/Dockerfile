FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go mod tidy
RUN go build -o payment-service ./cmd/api

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/payment-service .
COPY .env .

EXPOSE 8082

CMD ["./payment-service"]

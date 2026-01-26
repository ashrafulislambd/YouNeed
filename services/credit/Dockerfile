FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o credit-service ./cmd/api

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/credit-service .
COPY .env .

EXPOSE 8081

CMD ["./credit-service"]

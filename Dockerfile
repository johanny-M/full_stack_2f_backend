# Start with the Go base image
FROM golang:1.21 AS builder

WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the entire application code into the container
COPY . .

COPY cmd/ ./cmd/

RUN ls -la /app

# Build the Go application
RUN go build -o todoapp ./main.go 

# Final stage: create a lightweight image
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/todoapp .

RUN chmod +x todoapp

CMD ["./todoapp"]

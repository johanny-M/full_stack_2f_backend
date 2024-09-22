# Start with the Go base image
FROM golang:1.21 AS builder

WORKDIR /app

# Copy go.mod and go.sum first
COPY go.mod go.sum ./

# Update Go modules and clean up cache
RUN go mod tidy && go mod download

# Copy the rest of the application code, including main.go
COPY . .

# Build the Go application
RUN go build -o todoapp main.go  # Ensure this path is correct

# Final stage
FROM alpine:latest


WORKDIR /root/


COPY --from=builder /app/todoapp .


CMD ["./todoapp"]

# Start with the Go base image
FROM golang:1.21 AS builder

WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Update Go modules and clean up cache
RUN echo "Checking Go version..." && \
    go version && \
    echo "Cleaning module cache..." && \
    go clean -modcache && \
    echo "Removing go.sum..." && \
    rm -f go.sum && \
    echo "Running go mod tidy..." && \
    go mod tidy && \
    echo "Downloading dependencies..." && \
    go mod download

# Copy the rest of the application code
COPY . .

# Build the application
RUN go build -o main .

# Final stage
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]

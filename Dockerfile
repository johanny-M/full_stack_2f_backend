FROM golang:1.18-alpine AS builder

# Install dependencies for building Go applications
RUN apk add --no-cache git

# Set the working directory
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go application
RUN go build -o todoapp main.go

# Stage 2: Create a lightweight image for the application
FROM alpine:latest

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/todoapp .

EXPOSE 8080

CMD ["./todoapp"]

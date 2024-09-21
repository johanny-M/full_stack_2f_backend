# Stage 1: Build the Go application
FROM golang:1.18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to install dependencies
COPY go.mod go.sum ./

# Download all the dependencies. Dependencies will be cached if the go.mod and go.sum files are unchanged
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN go build -o main .

# Stage 2: Run the Go application
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose the port the app runs on (adjust to match your app's configuration)
EXPOSE 8080

# Command to run the Go app
CMD ["./main"]

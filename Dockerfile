# Stage 1: Build the Go application
FROM golang:1.18-alpine AS builder


# Set Go environment variables 

ENV GOPATH=/go

ENV GOROOT=usr/local/go

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum to download dependencies first
COPY go.mod go.sum ./

RUN go mod download -x

# Copy the source code
COPY . .

# Build the application
RUN go build -o main .

# Stage 2: Create the lightweight final image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./main"]

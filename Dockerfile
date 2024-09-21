FROM golang:1.18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum to download dependencies first

COPY go.mod go.sum ./

RUN --mount=type=cache,target="/root/.cache/go-build" --mount=type=cache,target="/go/pkg/mod" go build -a -o service ./cmd/service

# Copy the source code
COPY . .

# Build the Go application
RUN go build -o todoapp main.go

# Stage 2: Run the Go application
FROM alpine:latest

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/todoapp .

EXPOSE 8080

CMD ["./todoapp"]

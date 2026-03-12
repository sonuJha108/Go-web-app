# Use official Go image for building the application
FROM golang:1.22.5 AS base

# Set working directory
WORKDIR /app

# Copy dependency file first for caching
COPY go.mod .

# Download dependencies
RUN go mod download

# Copy all source code
COPY . .

# Build Go binary
RUN go build -o main .

# Use minimal distroless image for final container
FROM gcr.io/distroless/base

# Copy compiled binary from build stage
COPY --from=base /app/main .

# Copy static files
COPY --from=base /app/static/ ./static

# Expose application port
EXPOSE 8085

# Run the binary
CMD ["./main"]
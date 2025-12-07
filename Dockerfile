# Build stage
FROM golang:1.21-alpine AS build
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./cmd/server

# Run stage (distroless, non-root)
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=build /app/server /server

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/server"]

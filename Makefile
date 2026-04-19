# Makefile for Canopy - Fork of canopy-network/canopy

.PHONY: all build run stop clean test lint docker-build docker-up docker-down logs

# Variables
BINARY_NAME=canopy
DOCKER_COMPOSE=docker-compose
GO=go
GOFLAGS=-mod=mod

# Default target
all: build

## Build the Go binary
build:
	$(GO) build $(GOFLAGS) -o bin/$(BINARY_NAME) ./...

## Run the node locally
run:
	$(GO) run $(GOFLAGS) ./...

## Run tests
test:
	$(GO) test $(GOFLAGS) ./... -v -count=1

## Run tests with race detector
test-race:
	$(GO) test $(GOFLAGS) -race ./... -count=1

## Lint the code
lint:
	golangci-lint run ./...

## Format the code
fmt:
	$(GO) fmt ./...

## Tidy go modules
tidy:
	$(GO) mod tidy

## Build Docker image
docker-build:
	$(DOCKER_COMPOSE) build

## Start all services via Docker Compose
docker-up:
	$(DOCKER_COMPOSE) up -d

## Stop all services
docker-down:
	$(DOCKER_COMPOSE) down

## View logs
logs:
	$(DOCKER_COMPOSE) logs -f

## Clean build artifacts
clean:
	rm -rf bin/
	$(GO) clean ./...

## Show help
help:
	@echo "Available targets:"
	@grep -E '^##' Makefile | sed 's/## /  /'

## Run tests and output a coverage report
coverage:
	$(GO) test $(GOFLAGS) ./... -coverprofile=coverage.out
	$(GO) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report written to coverage.html"

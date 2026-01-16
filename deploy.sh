#!/bin/bash

# Praxis Deployment Script

echo "🚀 Starting Praxis deployment..."

# Check for .env file
if [ -f .env ]; then
    echo "✅ Found .env file."
elif [ -f backend/.env ]; then
    echo "⚠️  .env not found in root, but found in backend/.env"
    echo "📋 Copying backend/.env to root .env..."
    cp backend/.env .env
else
    echo "⚠️  No .env file found!"
    echo "Creating empty .env from example..."
    if [ -f .env.prod.example ]; then
        cp .env.prod.example .env
    else
        touch .env
    fi
    echo "📝 Please edit .env with your actual secrets (GEMINI_API_KEY, etc.) then run this script again."
    exit 1
fi

# Build and start containers
echo "📦 Building and starting containers..."
# Use --env-file explicitly just in case, though default is .env
docker compose -f docker-compose.prod.yml --env-file .env up -d --build

# Check status
if [ $? -eq 0 ]; then
    echo "✅ Application deployed successfully!"
    echo "🌍 Access the application at http://localhost"
else
    echo "❌ Deployment failed."
    exit 1
fi

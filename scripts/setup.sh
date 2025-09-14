#!/bin/bash

# Pact Landing Page - Quick Setup Script
# Run this script to set up the project for development

set -e

echo "🤝 Pact Landing Page - Quick Setup"
echo "=================================="
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first:"
    echo "   https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ npm found: $(npm --version)"

# Install Firebase CLI if not present
if ! command -v firebase &> /dev/null; then
    echo "🔥 Installing Firebase CLI..."
    npm install -g firebase-tools
    echo "✅ Firebase CLI installed"
else
    echo "✅ Firebase CLI found: $(firebase --version)"
fi

# Login to Firebase
echo ""
echo "🔐 Logging into Firebase..."
firebase login

# List available projects
echo ""
echo "📋 Available Firebase projects:"
firebase projects:list

# Prompt for project selection
echo ""
read -p "Enter your Firebase project ID: " project_id

if [ ! -z "$project_id" ]; then
    firebase use "$project_id"
    echo "✅ Using Firebase project: $project_id"
else
    echo "⚠️  No project selected. You can set it later with: firebase use <project-id>"
fi

# Create environment file
echo ""
echo "📄 Setting up environment configuration..."
if [ ! -f ".env" ]; then
    cp env.example .env
    echo "✅ Created .env file from template"
    echo "📝 Please edit .env file with your Firebase configuration"
else
    echo "⚠️  .env file already exists"
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

# Test local server
echo ""
echo "🧪 Testing local development server..."
timeout 10s firebase serve --host 0.0.0.0 --port 5000 &
sleep 5
if curl -s -o /dev/null -w "%{http_code}" http://localhost:5000 | grep -q "200"; then
    echo "✅ Local server is working!"
else
    echo "⚠️  Local server test failed (this might be normal)"
fi

# Kill the test server
pkill -f "firebase serve" || true

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your Firebase configuration"
echo "2. Update Firebase config in index.html (lines 681-689)"
echo "3. Run 'npm run dev' to start development server"
echo "4. Run 'npm run deploy' to deploy to Firebase"
echo ""
echo "For maintenance tasks, run: ./scripts/maintenance.sh"

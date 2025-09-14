#!/bin/bash

# Pact Landing Page - Maintenance Script
# Run this script for common maintenance tasks

set -e

echo "🤝 Pact Landing Page - Maintenance Script"
echo "=========================================="

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it first:"
    echo "   npm install -g firebase-tools"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "firebase.json" ]; then
    echo "❌ firebase.json not found. Please run this script from the project root."
    exit 1
fi

echo "✅ Environment check passed"
echo ""

# Function to show menu
show_menu() {
    echo "Select a maintenance task:"
    echo "1) 🚀 Deploy to production"
    echo "2) 🧪 Deploy to preview channel"
    echo "3) 📊 Check Firebase project status"
    echo "4) 🔍 Validate deployment (dry run)"
    echo "5) 🧹 Clean up preview channels"
    echo "6) 📝 View recent logs"
    echo "7) 🔄 Update dependencies"
    echo "8) ❌ Exit"
    echo ""
}

# Main menu loop
while true; do
    show_menu
    read -p "Enter your choice (1-8): " choice
    echo ""
    
    case $choice in
        1)
            echo "🚀 Deploying to production..."
            firebase deploy --only hosting
            echo "✅ Production deployment complete!"
            ;;
        2)
            echo "🧪 Deploying to preview channel..."
            firebase hosting:channel:deploy preview
            echo "✅ Preview deployment complete!"
            ;;
        3)
            echo "📊 Checking Firebase project status..."
            firebase projects:list
            firebase use
            ;;
        4)
            echo "🔍 Validating deployment (dry run)..."
            firebase deploy --only hosting --dry-run
            echo "✅ Validation complete!"
            ;;
        5)
            echo "🧹 Cleaning up preview channels..."
            firebase hosting:channel:list
            read -p "Enter channel name to delete (or press Enter to skip): " channel
            if [ ! -z "$channel" ]; then
                firebase hosting:channel:delete "$channel"
                echo "✅ Channel deleted!"
            fi
            ;;
        6)
            echo "📝 Viewing recent logs..."
            firebase functions:log --limit 50
            ;;
        7)
            echo "🔄 Updating dependencies..."
            npm update
            firebase --version
            echo "✅ Dependencies updated!"
            ;;
        8)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please try again."
            ;;
    esac
    echo ""
    read -p "Press Enter to continue..."
    echo ""
done

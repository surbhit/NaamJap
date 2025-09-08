#!/bin/bash

# Naam Jhap Website Deployment Script

echo "🕉️ Building Naam Jhap Website..."

# Build the Flutter web app
flutter build web --release

echo "✅ Build completed successfully!"

echo "📁 Build files are located in: build/web/"
echo "🌐 You can deploy the contents of build/web/ to any web hosting service"
echo ""
echo "🚀 Popular hosting options:"
echo "   - GitHub Pages"
echo "   - Netlify"
echo "   - Vercel"
echo "   - Firebase Hosting"
echo "   - AWS S3 + CloudFront"
echo ""
echo "📋 To deploy to GitHub Pages:"
echo "   1. Copy build/web/* to your gh-pages branch"
echo "   2. Push to GitHub"
echo ""
echo "📋 To deploy to Netlify:"
echo "   1. Drag and drop the build/web folder to netlify.com"
echo "   2. Or connect your GitHub repository"
echo ""
echo "✨ Om Namah Shivaya ✨"

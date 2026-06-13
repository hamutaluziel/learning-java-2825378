#!/bin/bash
# FitLife iOS App Setup Script
# Run this from the FitnessTracker directory on your Mac

set -e
echo "🏋️ FitLife Setup Script"
echo "========================"

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode not found. Please install Xcode from the App Store."
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -1)
echo "✅ Found $XCODE_VERSION"

# Check for XcodeGen
if ! command -v xcodegen &> /dev/null; then
    echo ""
    echo "📦 XcodeGen not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Install it first: https://brew.sh"
        exit 1
    fi
    brew install xcodegen
fi

echo "✅ XcodeGen found"
echo ""
echo "🔨 Generating Xcode project..."
xcodegen generate

echo ""
echo "✅ Xcode project generated: FitnessTracker.xcodeproj"
echo ""
echo "📋 Next steps:"
echo "  1. Open FitnessTracker.xcodeproj in Xcode"
echo "  2. Select your Team in Signing & Capabilities"
echo "  3. Build & Run on your iPhone (or Simulator)"
echo "  4. Go to Settings tab and add your Claude API key"
echo "     → Get a free key at: console.anthropic.com"
echo "  5. In the Runna app: Settings → Connections → Apple Health → Enable"
echo ""
echo "🎉 Enjoy FitLife!"

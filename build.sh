#!/bin/bash
# Itbaa (اطبع) Build Script
# Copyright (c) 2025, sudorw <ahmedrowaihi@sudorw.com>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LADYBIRD_COMMIT=$(cat "$SCRIPT_DIR/LADYBIRD_COMMIT" 2>/dev/null | head -1)

# Parse arguments
STATIC_BUILD=false
CLEAN_BUILD=false
SKIP_CLONE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --static)
            STATIC_BUILD=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --skip-clone)
            SKIP_CLONE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           Itbaa (اطبع) - HTML to PDF Converter               ║"
echo "║           Copyright (c) 2025, Ahmed Rowaihi                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Clone or update Ladybird
if [ "$SKIP_CLONE" = false ]; then
    if [ ! -d "$SCRIPT_DIR/ladybird" ]; then
        echo "📥 Cloning Ladybird..."
        git clone --depth 1 https://github.com/LadybirdBrowser/ladybird.git "$SCRIPT_DIR/ladybird"
        cd "$SCRIPT_DIR/ladybird"
        if [ -n "$LADYBIRD_COMMIT" ]; then
            git fetch --depth 1 origin "$LADYBIRD_COMMIT"
            git checkout "$LADYBIRD_COMMIT"
        fi
    else
        echo "📂 Ladybird directory exists"
    fi
fi

cd "$SCRIPT_DIR/ladybird"

# Apply patches
echo "🔧 Applying patches..."
for patch in "$SCRIPT_DIR/patches"/*.patch; do
    if [ -f "$patch" ]; then
        echo "  Applying $(basename "$patch")..."
        git apply --check "$patch" 2>/dev/null && git apply "$patch" || echo "  (already applied or skipped)"
    fi
done

# Copy new files
if [ -d "$SCRIPT_DIR/new-files" ]; then
    echo "📁 Copying new files..."
    cp -r "$SCRIPT_DIR/new-files"/* .
fi

# Configure
echo ""
echo "⚙️  Configuring..."
if [ "$STATIC_BUILD" = true ]; then
    PRESET="Itbaa_Static"
    BUILD_DIR="Build/itbaa-static"
else
    PRESET="Itbaa"
    BUILD_DIR="Build/itbaa"
fi

if [ "$CLEAN_BUILD" = true ] && [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
fi

cmake --preset "$PRESET"

# Build
echo ""
echo "🔨 Building..."
cmake --build "$BUILD_DIR" --target itbaa-cli

# Report
echo ""
echo "✅ Build complete!"
echo ""
echo "Binary location: $SCRIPT_DIR/ladybird/$BUILD_DIR/bin/itbaa"
echo ""
echo "Usage:"
echo "  $BUILD_DIR/bin/itbaa <input.html> <output.pdf>"
echo "  $BUILD_DIR/bin/itbaa --help"


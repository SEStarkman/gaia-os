#!/bin/bash
# GAIA OS - First-time setup helper
# Usage: bash scripts/setup.sh

set -e

echo "=== GAIA OS Setup ==="
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js: $NODE_VERSION"
else
    echo "❌ Node.js not found. Install it first: https://nodejs.org/"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ npm: $NPM_VERSION"
else
    echo "❌ npm not found. Should come with Node.js."
    exit 1
fi

# Check OpenClaw
if command -v openclaw &> /dev/null; then
    OC_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    echo "✅ OpenClaw: $OC_VERSION"
else
    echo "❌ OpenClaw not found."
    echo "   Install it: npm install -g openclaw"
    echo "   Then run: openclaw setup"
    echo "   Docs: https://docs.openclaw.ai/getting-started"
    exit 1
fi

echo ""

# Create memory directory
if [ ! -d "memory" ]; then
    mkdir -p memory
    echo "📁 Created memory/ directory"
else
    echo "📁 memory/ directory exists"
fi

# Create data directory (for tracking files)
if [ ! -d "data" ]; then
    mkdir -p data
    echo "📁 Created data/ directory"
else
    echo "📁 data/ directory exists"
fi

# Check for BOOTSTRAP.md
if [ -f "BOOTSTRAP.md" ]; then
    echo ""
    echo "🎯 BOOTSTRAP.md found — your agent will run the first-time setup"
    echo "   conversation when you start chatting."
fi

# Check workspace files
echo ""
echo "Workspace files:"
for file in AGENTS.md SOUL.md USER.md IDENTITY.md MEMORY.md TOOLS.md HEARTBEAT.md BOOTSTRAP.md; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
    fi
done

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Start the gateway: openclaw gateway start"
echo "  2. Send your first message to your agent"
echo "  3. The agent will use BOOTSTRAP.md to get to know you"
echo ""
echo "Docs: https://docs.openclaw.ai"

#!/bin/bash
# GAIA OS - First-time setup
# Usage: bash scripts/setup.sh

set -e

echo ""
echo "  🌍 GAIA OS Setup"
echo "  ─────────────────"
echo ""

# Check OpenClaw
if command -v openclaw &> /dev/null; then
    OC_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    echo "  ✅ OpenClaw installed ($OC_VERSION)"
else
    echo "  ❌ OpenClaw not found."
    echo ""
    echo "  Install it first:"
    echo "    npm install -g openclaw"
    echo "    openclaw setup"
    echo ""
    echo "  Guide: https://docs.openclaw.ai/getting-started"
    exit 1
fi

# Create directories
[ ! -d "memory" ] && mkdir -p memory && echo "  📁 Created memory/"
[ ! -d "data" ] && mkdir -p data && echo "  📁 Created data/"

# Check workspace files
echo ""
echo "  Workspace files:"
ALL_GOOD=true
for file in AGENTS.md SOUL.md USER.md IDENTITY.md MEMORY.md BOOTSTRAP.md; do
    if [ -f "$file" ]; then
        echo "    ✅ $file"
    else
        echo "    ❌ $file (missing)"
        ALL_GOOD=false
    fi
done

echo ""

if [ "$ALL_GOOD" = true ]; then
    echo "  Everything looks good."
else
    echo "  ⚠️  Some files are missing. Make sure you cloned the full repo."
fi

echo ""
echo "  Next steps:"
echo "    1. openclaw gateway start"
echo "    2. Send your first message"
echo "    3. Your agent will introduce itself and get to know you"
echo ""

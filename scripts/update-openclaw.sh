#!/bin/bash
# Update OpenClaw to the latest version
# Usage: bash scripts/update-openclaw.sh

set -e

echo "=== OpenClaw Update ==="
echo ""

# Check current version
CURRENT=$(openclaw --version 2>/dev/null || echo "not installed")
echo "Current version: $CURRENT"
echo ""

echo "Stopping OpenClaw gateway..."
openclaw gateway stop

echo "Updating OpenClaw..."
npm update -g openclaw

echo "Running doctor..."
openclaw doctor

echo "Starting OpenClaw gateway..."
openclaw gateway start

echo ""
NEW=$(openclaw --version 2>/dev/null || echo "unknown")
echo "Updated: $CURRENT → $NEW"
echo "Done."

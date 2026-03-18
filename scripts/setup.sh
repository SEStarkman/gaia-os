#!/bin/bash
# ============================================================
# GAIA Agent Setup Script
# Run this on a fresh Debian/Ubuntu VM to install everything.
# Usage: bash setup.sh
# ============================================================

set -e

echo ""
echo "========================================="
echo "  GAIA Agent Setup"
echo "========================================="
echo ""

# ----------------------------------------------------------
# Step 1: System prerequisites
# ----------------------------------------------------------
echo "[1/5] Installing system prerequisites..."
sudo apt update && sudo apt install -y git curl build-essential
echo "  Done."
echo ""

# ----------------------------------------------------------
# Step 2: Install Homebrew
# ----------------------------------------------------------
echo "[2/5] Installing Homebrew..."
if command -v brew &> /dev/null; then
    echo "  Homebrew already installed."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "  Done."
fi
echo ""

# ----------------------------------------------------------
# Step 3: Install Node.js
# ----------------------------------------------------------
echo "[3/5] Installing Node.js..."
if command -v node &> /dev/null; then
    echo "  Node.js already installed: $(node -v)"
else
    brew install node
    echo "  Installed: $(node -v)"
fi
echo "  npm: $(npm -v)"
echo ""

# ----------------------------------------------------------
# Step 4: Install OpenClaw
# ----------------------------------------------------------
echo "[4/5] Installing OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "  OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'version unknown')"
    echo "  Updating to latest..."
fi
npm install -g openclaw
echo "  Done."
echo ""

# ----------------------------------------------------------
# Step 5: Run the setup wizard
# ----------------------------------------------------------
echo "[5/5] Starting OpenClaw onboarding..."
echo ""
echo "  The wizard will ask you for:"
echo "    - Your Claude OAuth token (from 'claude setup-token' on your local machine)"
echo "      OR an Anthropic API key"
echo "    - Your Telegram bot token (from @BotFather)"
echo ""
echo "  Ready? Starting in 3 seconds..."
sleep 3
openclaw onboard

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "  Next steps:"
echo "    1. Start the agent:  openclaw gateway start"
echo "    2. Open Telegram, find your bot, send /start"
echo "    3. Approve the pairing:"
echo "       openclaw pairing approve telegram [PAIRING CODE]"
echo ""
echo "  Useful commands:"
echo "    openclaw gateway start    Start the agent"
echo "    openclaw gateway stop     Stop the agent"
echo "    openclaw gateway status   Check status"
echo ""
echo "  Need help?  Contact Sam at samstarkman.com"
echo ""

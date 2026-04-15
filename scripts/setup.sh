#!/bin/bash
# ============================================================
# OpenClaw Agent Setup
# One command to install everything on a fresh Debian/Ubuntu VM.
#
# Usage:
#   bash <(curl -sL https://raw.githubusercontent.com/SEStarkman/gaia-os/master/scripts/setup.sh)
# ============================================================

set -e

echo ""
echo "========================================="
echo "  OpenClaw Agent Setup"
echo "========================================="
echo ""

# ----------------------------------------------------------
# Step 1: System prerequisites
# ----------------------------------------------------------
echo "[1/4] Installing system prerequisites..."
sudo apt-get update -qq
sudo apt-get install -y -qq git curl build-essential > /dev/null
echo "  Done."
echo ""

# ----------------------------------------------------------
# Step 2: Install Homebrew
# ----------------------------------------------------------
echo "[2/4] Installing Homebrew (this takes a few minutes)..."
if command -v brew &> /dev/null; then
    echo "  Homebrew already installed."
else
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Make brew available now and on future logins
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        grep -qxF 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.bashrc 2>/dev/null \
            || echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        grep -qxF 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.profile 2>/dev/null \
            || echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    fi
    echo "  Done."
fi
echo ""

# ----------------------------------------------------------
# Step 3: Install Node.js
# ----------------------------------------------------------
echo "[3/4] Installing Node.js..."
if command -v node &> /dev/null; then
    echo "  Node.js already installed: $(node -v)"
else
    brew install node
    echo "  Installed Node.js $(node -v)"
fi
echo ""

# ----------------------------------------------------------
# Step 4: Install OpenClaw
# ----------------------------------------------------------
echo "[4/4] Installing OpenClaw..."
npm install -g openclaw
echo "  Installed OpenClaw $(openclaw --version 2>/dev/null || echo '')"
echo ""

# ----------------------------------------------------------
# Done
# ----------------------------------------------------------
echo "========================================="
echo "  Installation Complete"
echo "========================================="
echo ""
echo "  Everything is installed. To finish setup, run:"
echo ""
echo "    openclaw onboard"
echo ""
echo "  The wizard will ask for your Claude token"
echo "  and Telegram bot token."
echo ""
echo "  Need help?  samstarkman.com"
echo ""

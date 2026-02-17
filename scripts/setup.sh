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
# Step 1: System packages
# ----------------------------------------------------------
echo "[1/6] Updating system packages..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git build-essential curl tmux
echo "  Done."
echo ""

# ----------------------------------------------------------
# Step 2: Node.js 20.x
# ----------------------------------------------------------
echo "[2/6] Installing Node.js 20.x..."
if command -v node &> /dev/null; then
    NODE_VER=$(node -v)
    echo "  Node.js already installed: $NODE_VER"
else
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "  Installed: $(node -v)"
fi
echo "  npm: $(npm -v)"
echo ""

# ----------------------------------------------------------
# Step 3: Install OpenClaw
# ----------------------------------------------------------
echo "[3/6] Installing OpenClaw..."
if command -v openclaw &> /dev/null; then
    echo "  OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'version unknown')"
    echo "  Updating to latest..."
fi
sudo npm install -g openclaw
echo "  Done."
echo ""

# ----------------------------------------------------------
# Step 4: Create workspace
# ----------------------------------------------------------
WORKSPACE="$HOME/gaia"
echo "[4/6] Setting up workspace at $WORKSPACE..."
mkdir -p "$WORKSPACE"
mkdir -p "$WORKSPACE/memory"
mkdir -p "$WORKSPACE/skills"
mkdir -p "$WORKSPACE/scripts"
mkdir -p "$WORKSPACE/data"
mkdir -p "$WORKSPACE/output"
echo "  Workspace created."
echo ""

# ----------------------------------------------------------
# Step 5: Telegram bot setup (interactive)
# ----------------------------------------------------------
echo "[5/6] Telegram Bot Setup"
echo ""
echo "  You need a Telegram bot token from @BotFather."
echo "  Open Telegram, search for @BotFather, send /newbot,"
echo "  follow the prompts, then paste the token below."
echo ""
read -p "  Paste your Telegram bot token (or press Enter to skip): " BOT_TOKEN
echo ""

# ----------------------------------------------------------
# Step 6: Run OpenClaw onboarding
# ----------------------------------------------------------
echo "[6/6] Running OpenClaw onboarding..."
echo ""

if [ -n "$BOT_TOKEN" ]; then
    # Create config directory
    mkdir -p "$HOME/.openclaw"

    # Write config with Telegram integration
    cat > "$HOME/.openclaw/openclaw.json" << EOF
{
  "agents": {
    "defaults": {
      "workspace": "$WORKSPACE",
      "thinkingDefault": "high"
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "$BOT_TOKEN",
      "dmPolicy": "pairing",
      "groupPolicy": "allowlist",
      "streamMode": "partial",
      "linkPreview": false
    }
  },
  "gateway": {
    "port": 18789,
    "mode": "local",
    "bind": "loopback"
  }
}
EOF
    echo "  Config written with Telegram integration."
    echo ""
    echo "  Next steps:"
    echo "  1. Add your Anthropic API key:"
    echo "     openclaw configure"
    echo ""
    echo "  2. Start the agent:"
    echo "     openclaw gateway start"
    echo ""
    echo "  3. Open Telegram, find your bot, and send /start"
    echo ""
    echo "  4. Paste your filled-in initialization template as your first message"
    echo ""
else
    echo "  No bot token provided. Running interactive onboarding instead..."
    echo "  (You can set up Telegram later)"
    echo ""
    openclaw onboard --workspace "$WORKSPACE"
fi

# ----------------------------------------------------------
# Optional: Set up systemd service
# ----------------------------------------------------------
echo ""
read -p "  Set up auto-start on reboot? (y/n): " AUTOSTART

if [ "$AUTOSTART" = "y" ] || [ "$AUTOSTART" = "Y" ]; then
    USERNAME=$(whoami)

    sudo tee /etc/systemd/system/openclaw.service > /dev/null << EOF
[Unit]
Description=OpenClaw AI Agent
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=$WORKSPACE
ExecStart=$(which openclaw) gateway start --foreground
Restart=always
RestartSec=10
Environment=HOME=/home/$USERNAME

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable openclaw
    echo "  Auto-start enabled. The agent will start on every reboot."
    echo "  Commands: sudo systemctl start/stop/restart openclaw"
else
    echo "  Skipped. You can start manually with: openclaw gateway start"
fi

echo ""
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "  Workspace:  $WORKSPACE"
echo "  Config:     ~/.openclaw/openclaw.json"
echo "  Start:      openclaw gateway start"
echo "  Stop:       openclaw gateway stop"
echo "  Status:     openclaw gateway status"
echo "  Update:     bash ~/gaia/scripts/update-openclaw.sh"
echo ""
echo "  Need help?  Contact Sam at samstarkman.com"
echo ""

#!/bin/bash

set -e

APP_DIR="/var/www/lusi-app"
REPO_URL="https://github.com/Bo-Br/backend-test.git"
SERVICE_NAME="lusi"
NODE_VERSION="21"

echo "[1/7] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[2/7] Installing base dependencies..."
sudo apt-get install -y curl git build-essential

echo "[3/7] Installing Node.js (clean way via NodeSource)..."
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "[4/7] Preparing app directory..."
sudo mkdir -p $APP_DIR
sudo chown -R $USER:$USER $APP_DIR

echo "[5/7] Cloning repository..."
if [ -d "$APP_DIR/.git" ]; then
    echo "Repo already exists, pulling latest..."
    cd $APP_DIR
    git pull
else
    git clone $REPO_URL $APP_DIR
    cd $APP_DIR
fi

echo "[6/7] Installing and building app..."
npm install
npm run build

echo "[7/7] Creating systemd service..."

sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=LUSI RPG Dashboard
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=5
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl restart ${SERVICE_NAME}

echo "Deployment complete."

echo "Server status:"
sudo systemctl status ${SERVICE_NAME} --no-pager

echo "Access your app via:"
hostname -I

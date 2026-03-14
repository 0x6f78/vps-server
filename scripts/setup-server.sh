#!/bin/bash

set -e

echo -e "\033[0;35m[INFO] Installing Cloudflared\033[0m"
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
echo -e "\033[0;35m[INFO] Cloudflared Installed\033[0m"

echo -e "\033[0;35m[INFO] Installing Docker Prerequisites\033[0m"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
echo -e "\033[0;35m[INFO] Docker Prerequisites Installed\033[0m"

echo -e "\033[0;35m[INFO] Installing Docker Engine\033[0m"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "\033[0;35m[INFO] Docker Engine Installed\033[0m"

echo -e "\033[0;35m[INFO] Configuring User Permissions\033[0m"
sudo usermod -aG docker $USER
newgrp docker
echo -e "\033[0;35m[INFO] User Permissions Configured\033[0m"

echo -e "\033[0;35m[INFO] Creating Docker Networks\033[0m"
sudo docker network create traefik-public 2>/dev/null || true
sudo docker network create traefik-private 2>/dev/null || true
echo -e "\033[0;35m[INFO] Docker Networks Created\033[0m"

echo -e "\033[0;35m[INFO] Setting up ACME Certificate File\033[0m"
touch ~/vps-server/infra/traefik/acme.json
chmod 600 ~/vps-server/infra/traefik/acme.json
echo -e "\033[0;35m[INFO] ACME Certificate File Setup Complete\033[0m"

echo -e "\033[0;35m[INFO] Setup Complete\033[0m"

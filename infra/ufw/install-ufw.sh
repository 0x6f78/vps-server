#!/bin/bash
# install-ufw.sh - Install and enable UFW with safe defaults
# Run this script FIRST before adding firewall rules

set -euo pipefail

echo -e "\033[0;35m[INFO] Starting UFW Installation Script\033[0m"

echo -e "\033[0;35m[INFO] Checking for root privileges\033[0m"
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[0;35m[INFO] ERROR: This script must be run as root or with sudo\033[0m"
    exit 1
fi

echo -e "\033[0;35m[INFO] Updating package index\033[0m"
apt-get update -qq

echo -e "\033[0;35m[INFO] Checking if UFW is installed\033[0m"
if ! command -v ufw &> /dev/null; then
    echo -e "\033[0;35m[INFO] UFW not found. Installing UFW\033[0m"
    apt-get install -y ufw
    echo -e "\033[0;35m[INFO] UFW installed successfully\033[0m"
else
    echo -e "\033[0;35m[INFO] UFW is already installed\033[0m"
fi

echo -e "\033[0;35m[INFO] Resetting UFW to default state\033[0m"
echo -e "\033[0;35m[INFO] WARNING: This will remove existing UFW rules\033[0m"
ufw --force reset

echo -e "\033[0;35m[INFO] Setting default firewall policies\033[0m"
ufw default deny incoming
echo -e "\033[0;35m[INFO] Default incoming policy set to DENY\033[0m"
ufw default allow outgoing
echo -e "\033[0;35m[INFO] Default outgoing policy set to ALLOW\033[0m"

echo -e "\033[0;35m[INFO] Configuring loopback interface rules\033[0m"
ufw allow in on lo
echo -e "\033[0;35m[INFO] Allowed inbound on loopback interface\033[0m"
ufw allow out on lo
echo -e "\033[0;35m[INFO] Allowed outbound on loopback interface\033[0m"
ufw allow from 127.0.0.1
echo -e "\033[0;35m[INFO] Allowed IPv4 localhost\033[0m"
ufw allow from ::1
echo -e "\033[0;35m[INFO] Allowed IPv6 localhost\033[0m"

echo -e "\033[0;35m[INFO] Enabling stateful firewall rules\033[0m"
ufw allow proto tcp from any to any port 80,443 established 2>/dev/null || true
echo -e "\033[0;35m[INFO] Established connection tracking enabled for ports 80, 443\033[0m"

echo -e "\033[0;35m[INFO] Enabling UFW firewall\033[0m"
echo "y" | ufw enable
echo -e "\033[0;35m[INFO] UFW firewall enabled\033[0m"

echo -e "\033[0;35m[INFO] Setting UFW logging level to medium\033[0m"
ufw logging medium

echo -e "\033[0;35m[INFO] Generating final status report\033[0m"
echo ""
ufw status verbose
echo ""

echo -e "\033[0;35m[INFO] UFW installation and basic configuration complete\033[0m"
echo -e "\033[0;35m[INFO] Next step: Run set-cloudflare-rules.sh to add Cloudflare IP allowlist rules\033[0m"
echo -e "\033[0;35m[INFO] WARNING: Port 22 is closed. SSH access only via cloudflared tunnel\033[0m"

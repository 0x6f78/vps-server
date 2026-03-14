#!/bin/bash
# setup-cloudflare-rules.sh - Configure UFW to allow ONLY Cloudflare IPs on ports 80/443
# Prerequisite: Run install-ufw.sh first
# Port 22 is NOT opened - SSH access only via cloudflared tunnel

set -euo pipefail

echo -e "\033[0;35m[INFO] Starting Cloudflare UFW Rules Setup\033[0m"

echo -e "\033[0;35m[INFO] Checking for root privileges\033[0m"
if [[ $EUID -ne 0 ]]; then
    echo -e "\033[0;35m[INFO] ERROR: This script must be run as root or with sudo\033[0m"
    exit 1
fi

echo -e "\033[0;35m[INFO] Checking if UFW is installed\033[0m"
if ! command -v ufw &> /dev/null; then
    echo -e "\033[0;35m[INFO] ERROR: UFW not found. Please run install-ufw.sh first\033[0m"
    exit 1
fi
echo -e "\033[0;35m[INFO] UFW is installed\033[0m"

# Cloudflare IPv4 ranges (source: https://www.cloudflare.com/ips-v4/)
echo -e "\033[0;35m[INFO] Loading Cloudflare IPv4 ranges\033[0m"
CLOUDFLARE_IPV4=(
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
)

# Cloudflare IPv6 ranges (source: https://www.cloudflare.com/ips-v6/)
echo -e "\033[0;35m[INFO] Loading Cloudflare IPv6 ranges\033[0m"
CLOUDFLARE_IPV6=(
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
)

echo -e "\033[0;35m[INFO] Adding UFW rules for Cloudflare IPv4 ranges on port 80\033[0m"
for ip in "${CLOUDFLARE_IPV4[@]}"; do
    ufw allow from "$ip" to any port 80 proto tcp 2>/dev/null || true
done
echo -e "\033[0;35m[INFO] Added Cloudflare IPv4 rules for port 80\033[0m"

echo -e "\033[0;35m[INFO] Adding UFW rules for Cloudflare IPv4 ranges on port 443\033[0m"
for ip in "${CLOUDFLARE_IPV4[@]}"; do
    ufw allow from "$ip" to any port 443 proto tcp 2>/dev/null || true
done
echo -e "\033[0;35m[INFO] Added Cloudflare IPv4 rules for port 443\033[0m"

echo -e "\033[0;35m[INFO] Adding UFW rules for Cloudflare IPv6 ranges on port 80\033[0m"
for ip in "${CLOUDFLARE_IPV6[@]}"; do
    ufw allow from "$ip" to any port 80 proto tcp 2>/dev/null || true
done
echo -e "\033[0;35m[INFO] Added Cloudflare IPv6 rules for port 80\033[0m"

echo -e "\033[0;35m[INFO] Adding UFW rules for Cloudflare IPv6 ranges on port 443\033[0m"
for ip in "${CLOUDFLARE_IPV6[@]}"; do
    ufw allow from "$ip" to any port 443 proto tcp 2>/dev/null || true
done
echo -e "\033[0;35m[INFO] Added Cloudflare IPv6 rules for port 443\033[0m"

echo -e "\033[0;35m[INFO] Reloading UFW to apply changes\033[0m"
ufw reload

echo -e "\033[0;35m[INFO] Generating UFW status report\033[0m"
echo ""
ufw status verbose
echo ""

echo -e "\033[0;35m[INFO] Cloudflare UFW rules setup complete\033[0m"
echo -e "\033[0;35m[INFO] Allowed: Ports 80 and 443 from Cloudflare IPs only\033[0m"
echo -e "\033[0;35m[INFO] Blocked: All other incoming connections including port 22\033[0m"
echo -e "\033[0;35m[INFO] SSH access: Only via cloudflared tunnel (outbound connection)\033[0m"
echo -e "\033[0;35m[INFO] To update rules: Re-run this script when Cloudflare IP ranges change\033[0m"

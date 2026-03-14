## UFW Firewall Setup for Cloudflare Tunnel & Traefik

This guide explains how to secure your VPS by installing UFW and restricting incoming traffic to Cloudflare IPs only. By default, this configuration closes all ports including SSH (port 22), relying entirely on the Cloudflare Tunnel for remote access.

---
```bash
DO NOT RUN THESE SCRIPTS UNLESS YOU HAVE VERIFIED THE FOLLOWING:
```

1. **Cloudflare Tunnel (cloudflared) is running and connected.**
   - You must be able to SSH into this server via the Cloudflare Tunnel.
   - Direct SSH (port 22) will be **BLOCKED** after running these scripts.

2. **Traefik is configured and serving traffic.**
   - Ports 80 and 443 must be open only to Cloudflare IPs.
   - Your websites must be accessible via Cloudflare proxy.

```bash
IF YOU RUN THIS WITHOUT A WORKING TUNNEL, YOU WILL BE LOCKED OUT OF YOUR SERVER.
```

---

### Step 1: Verify Cloudflare Tunnel SSH Access

Before proceeding, open a **NEW** terminal window and test your tunnel SSH access. Do not close your current session until you confirm the new one works.

```bash
# Test your cloudflared SSH connection here
ssh your-tunnel-ssh-command
```

### Step 2: Install UFW

Run the installation script to install UFW and set default policies. This script configures the firewall to deny incoming traffic by default while allowing outgoing traffic.

```bash
sudo ./install-ufw.sh
```

### Step 3: Apply Cloudflare Rules
Run the rules script to allow only Cloudflare IPs on ports 80 and 443. This ensures Traefik can receive traffic while blocking all other direct connections.

```bash
sudo ./setup-cloudflare-rules.sh
```

### Step 4: Verification
Check the firewall status to ensure rules are applied correctly.

```bash
sudo ufw status verbose
```

---

### Summary

- SSH Access: Direct SSH (port 22) is blocked; access only via cloudflared tunnel.
- Web Traffic: Ports 80 and 443 allowed from Cloudflare IPs only.
- Security: All routing and firewall changes are managed through UFW and Cloudflare configuration.
- Lockout Risk: High if tunnel is not verified; use VPS console for recovery.


## Cloudflared SSH Tunnel Setup

This guide explains how to configure the Cloudflared Docker container to expose SSH through a Cloudflare Tunnel, while keeping Traefik separate for public web traffic.

### Step 1: Create the Cloudflare Tunnel

1. Log in to the Cloudflare Zero Trust Dashboard
2. Navigate to Networks > Tunnels
3. Click Create a Tunnel
4. Select Docker as the environment
5. Name your tunnel (for example: vps-ssh-tunnel)
6. Copy the Tunnel Token displayed. You will need this for the .env file.
7. Keep the page open, you will need it!
---

### Step 2: Edit the .env File

Replace <YOUR_TOKEN_HERE> with the actual token from previus step.

```env
CLOUDFLARE_TUNNEL_TOKEN=<YOUR_CLOUDFLARED_TUNNEL_TOKEN>
```

After saving the .env file, restart your Cloudflared container to load the new environment variable:

```bash
docker compose down
docker compose up -d
```

Verify the tunnel is connected:

```bash
docker logs cloudflared
```

If its on the Cloudflare Dashboard the tunnel status should be Active as well.

---

### Step 3: Configure Tunnel Routing (Public Hostname)

Once the tunnel is active in the dashboard:

1. In the Zero Trust Dashboard, go to Networks > Tunnels
2. Click your tunnel name, then click Configure
3. Go to the Public Hostnames tab
4. Click Add a public hostname and configure the following:
   - Subdomain: ssh
   - Domain: yourdomain.com (select your domain from the dropdown)
   - URL: tcp://localhost:22
5. Click Save Tunnel

---

### Step 4: Set Up Cloudflare Access Policies

To prevent unauthorized access, configure an Access policy that requires identity verification before allowing SSH connections.

#### Create the Access Application

1. In the Zero Trust Dashboard, go to Access > Applications
2. Click Add an Application
3. Select Self-Hosted
4. Configure the application settings:
   - Application name: VPS SSH Access (example)
   - Subdomain: ssh
   - Domain: yourdomain.com
   - Session duration: 12h (or your preferred duration)
5. Click Next

#### Configure the Access Policy

1. Click Add a Policy
2. Configure the policy rule:
   - Policy name: Allow My Email
   - Action: Allow
   - Configure rules:
     - Selector: Email
     - Operator: Is
     - Value: you@example.com (replace with your authorized email address)
3. Optional: Add a second rule to explicitly deny all other users:
   - Policy name: Deny Others
   - Action: Deny
   - Configure rules: Email *

---

### Check Browser-Based SSH Terminal

Visit https://ssh.yourdomain.com in any web browser:

1. Enter your authorized email address
2. Receive and enter the 6-digit PIN sent to your email
3. A web-based SSH terminal loads, providing direct access to your VPS

***This method is useful for accessing your server from devices where installing cloudflared is not practical, use cloudflared with ssh keys!***

---
### We done for now.
---

## Summary

- No inbound ports need to be opened on your VPS firewall
- Identity verification via email and PIN occurs before SSH access is granted
- The setup works alongside Traefik with no configuration conflicts
- Both CLI and browser-based SSH access are supported
- All access attempts are logged in Cloudflare Zero Trust for audit purposes

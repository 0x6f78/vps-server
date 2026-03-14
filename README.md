# VPS-Server

Lightweight VPS setup for hosting websites and services behind Cloudflare.

## Stack

- [Traefik](https://traefik.io/) - Reverse proxy and SSL termination
- [Cloudflared](https://www.cloudflare.com/products/tunnel/) - Zero Trust tunnel for SSH access
- [WordPress](https://wordpress.org/) - Content management system
- [WooCommerce](https://woocommerce.org/) - E-commerce platform
- Docker & Docker Compose - Container orchestration

## Features

- Secure reverse proxy routing via Traefik with automatic Let's Encrypt certificates
- Containerized application environments for easy deployment and isolation
- Cloudflared tunnel for SSH access without exposing port 22 to the public internet
- Modular structure: each service has its own configuration and documentation
- Environment-based configuration via `.env` files

## Quick Start

1. Clone the repository to your VPS:
   ```bash
   git clone https://github.com/yourusername/vps-server.git
   cd vps-server
   ```

2. Set up Traefik (reverse proxy and SSL):
   ```bash
   cd traefik
   # Follow instructions in traefik/readme.md
   ```

3. Set up Cloudflared (SSH tunnel):
   ```bash
   cd ../cloudflared
   # Follow instructions in cloudflared/readme.md
   ```

4. Configure your applications:
   ```bash
   # Copy example environment files and edit with your values
   cp apps/wordpress/.env.example apps/wordpress/.env
   cp apps/woocommerce/.env.example apps/woocommerce/.env
   
   # Edit each .env file with your credentials, domain names, etc.
   vim apps/wordpress/.env
   vim apps/woocommerce/.env
   ```

5. Run the server setup script (optional, for initial VPS preparation):
   ```bash
   bash scripts/setup-server.sh
   ```

6. Start all services:
   ```bash
   bash scripts/start.sh
   ```

7. Verify services are running:
   ```bash
   docker compose ps
   ```

## Service URLs

After setup, your services will be available at:

| Service | URL | Notes |
|---------|-----|-------|
| Traefik Dashboard | https://dashboard.yourdomain.com | Protected by Basic Auth |
| WordPress | https://yourdomain.com | Main website |
| WooCommerce | https://shop.yourdomain.com | E-commerce store |
| SSH Access | ssh.yourdomain.com | Via Cloudflare Access (browser or CLI) |

Replace `yourdomain.com` with your actual domain.

## Managing Services

### Start all services
```bash
bash scripts/start.sh
```

### Stop all services
```bash
bash scripts/stop.sh
```

### Restart a specific service
```bash
cd apps/wordpress
docker compose restart
```

### View logs
```bash
# Traefik logs
docker logs traefik

# WordPress logs
docker logs wordpress

# Follow logs in real-time
docker logs -f wordpress
```

## Scripts Reference

### setup-server.sh
Prepares a fresh VPS for deployment:
- Installs Docker and Docker Compose
- Configures firewall rules
- Sets up system users and permissions

### start.sh
Starts all services in the correct order:
1. Traefik (proxy layer)
2. Cloudflared (SSH tunnel)
3. Applications (WordPress, WooCommerce)

### stop.sh
Stops all services in reverse order:
```bash
bash scripts/stop.sh
```

### backup.sh
Runs automated backups for databases and application data:
```bash
bash scripts/backup.sh
```

Backups are stored in the `backups/wordpress` or `backups/woocommerce` directory with timestamps. Backups older then 7days will be automatically deleted.

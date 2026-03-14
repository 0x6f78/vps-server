# VPS-Server

Lightweight VPS setup for hosting websites and services behind Cloudflare.

## Stack

- [Traefik](https://traefik.io/)
- Coudflared
- [WordPress](https://wordpress.org/)
- [WooCommerce](https://woocommerce.org/)
- Docker & Docker Compose

## Features

- Secure reverse proxy routing via Traefik
- Containerized application environments
- Automatic SSL certificates with Let's Encrypt
- Cloudflared for SSH through Cloudflare proxy

## Usage

1. Clone the repository.
2. Create your `.env` files, see `.env.example`s
   - `apps/wordpress/.env`
   - `apps/woocommerce/.env`
   - `infra/traefik/.env`
3. Run `script/setup-server.sh`.
4. Run `script/start.sh` to start

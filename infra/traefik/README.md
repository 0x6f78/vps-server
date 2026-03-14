## Traefik Dashboard Setup

This guide explains how to enable and configure access to the Traefik Dashboard. By default its turned off for security reasons.

### Step 1: Edit the .env File

Create or edit your `.env` file based on `.env.example`. Add your desired subdomain for the dashboard:

```env
TRAEFIK_DASHBOARD_SUBDOMAIN=dashboard
```

This will make your dashboard available at `dashboard.yourdomain.com`. Replace `dashboard` with any subdomain you prefer.

---

### Step 2: Restart the Traefik Container

After saving the `.env` file, restart your Traefik container to load the new environment variable:

```bash
docker compose down
docker compose up -d
```
---

### Step 3: Enable the Dashboard in traefik.yml

The Traefik dashboard is disabled by default. To enable it, edit your `traefik.yml` configuration file:

```yaml
api:
  dashboard: true
```

Change `dashboard: false` to `dashboard: true`, then restart Traefik:

```bash
docker compose restart traefik
```

---

### Step 4: Configure HTTP Access (Optional, for Debugging)

By default, the dashboard is only accessible via HTTPS. For local debugging, you can enable HTTP access by editing the relevant section in your configuration:

```yaml
#  insecure: true # Enable HTTP dashboard, access via HTTP
  insecure: false # Disable HTTP dashboard, access via HTTPS only
```

Uncomment the `insecure: true` line and comment out `insecure: false` to allow HTTP access. Use this only for temporary debugging, as HTTP traffic is not encrypted.

---

### Access the Dashboard

Visit `https://dashboard.yourdomain.com` in your web browser.

If you enabled HTTP access, you can also visit `http://dashboard.yourdomain.com`.

***Note: The Traefik dashboard provides real-time visibility into your routers, services, and middleware. It is a powerful debugging tool but should be protected in production environments.***

---

### Optional: Secure the Dashboard with Basic Auth

To prevent unauthorized access to the dashboard, configure HTTP Basic Authentication:

1. Generate a password hash:
   ```bash
   echo $(htpasswd -nb user password) | sed -e s/\\$/\\$\\$/g
   ```

2. Add the hash to your .env file and reference it in `traefik.yml` or Docker Compose labels:
   ```yaml
   labels:
     - "traefik.http.middlewares.dashboard-auth.basicauth.users=user:${YOUR_PASSWORD_HASH}"
     - "traefik.http.routers.dashboard.middlewares=dashboard-auth"
   ```

3. Restart Traefik to apply changes.

---

## Summary

- Dashboard subdomain is configured via `.env` file
- Dashboard is disabled by default; enable via `traefik.yml`
- HTTP access is optional and intended for debugging only
- Basic Auth is recommended for production environments
- All routing and middleware changes are managed through Traefik labels or configuration files

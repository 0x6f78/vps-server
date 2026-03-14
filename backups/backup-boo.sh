#!/bin/bash
set -e

ENV_FILE="$HOME/vps-server/apps/boo/.env"
BACKUP_DIR="$HOME/vps-server/backups/boo"
PROJECT_ROOT="$HOME/vps-server/apps/boo"

if [ ! -f "$ENV_FILE" ]; then
    echo -e "\033[0;31m[ERROR] .env not found at $ENV_FILE\033[0m"
    exit 1
fi

# Load environment variables
set -a
source "$ENV_FILE"
set +a

# Validate PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo -e "\033[0;31m[ERROR] PROJECT_NAME is not set in $ENV_FILE\033[0m"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup file name (Static site = files only)
BACKUP_FILE="${PROJECT_NAME}_backup_${TIMESTAMP}.tar.gz"

echo -e "\033[0;35m[INFO] Starting backup for $PROJECT_NAME: $BACKUP_FILE\033[0m"

# --- 1. Files Backup (Project Root) ---
echo -e "\033[0;35m[INFO] Archiving static site files...\033[0m"

# Exclude the backup directory itself and .git to save space
tar --exclude="$BACKUP_DIR" --exclude="./.git" -czf "$BACKUP_DIR/$BACKUP_FILE" -C "$PROJECT_ROOT" .

echo -e "\033[0;32m[OK] Files archived: ${BACKUP_FILE}\033[0m"

# --- 2. Cleanup (older than 7 days) ---
echo -e "\033[0;35m[INFO] Cleaning up old backups (older than 7 days)...\033[0m"
find "$BACKUP_DIR" -name "${PROJECT_NAME}_backup_*.tar.gz" -mtime +7 -delete

echo -e "\033[0;35m[INFO] Full backup completed successfully\033[0m"

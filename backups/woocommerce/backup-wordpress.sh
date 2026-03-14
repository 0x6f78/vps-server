#!/bin/bash
set -e

ENV_FILE="$HOME/vps-server/apps/wordpress/.env"
BACKUP_DIR="$HOME/vps-server/backups/wordpress"
PROJECT_ROOT="$HOME/vps-server/apps/wordpress"

if [ ! -f "$ENV_FILE" ]; then
    echo -e "\033[0;31m[ERROR] .env not found at $ENV_FILE\033[0m"
    exit 1
fi

set -a
source "$ENV_FILE"
set +a

DB_CONTAINER="${PROJECT_NAME}-db"
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Backup file names
DB_BACKUP_FILE="${PROJECT_NAME}_${DB_NAME}_${TIMESTAMP}.sql"
FILES_BACKUP_FILE="${PROJECT_NAME}_files_${TIMESTAMP}.tar.gz"

echo -e "\033[0;35m[INFO] Starting backup: $DB_BACKUP_FILE\033[0m"

# --- 1. Database Backup ---
docker exec "$DB_CONTAINER" mysqldump -u"root" -p"$DB_ROOT_PASSWORD" "$DB_NAME" > "$BACKUP_DIR/$DB_BACKUP_FILE"

gzip "$BACKUP_DIR/$DB_BACKUP_FILE"

echo -e "\033[0;32m[OK] Backup completed: ${DB_BACKUP_FILE}.gz\033[0m"

# --- 2. Files Backup (www + uploads) ---
echo -e "\033[0;35m[INFO] Archiving WordPress files...\033[0m"

tar --exclude="$BACKUP_DIR" --exclude="./.git" -czf "$BACKUP_DIR/$FILES_BACKUP_FILE" -C "$PROJECT_ROOT" .

echo -e "\033[0;32m[OK] Files archived: ${FILES_BACKUP_FILE}\033[0m"

# --- 3. Cleanup (older than 7 days) ---
find "$BACKUP_DIR" -name "${PROJECT_NAME}_${DB_NAME}_*.sql.gz" -mtime +7 -delete
find "$BACKUP_DIR" -name "${PROJECT_NAME}_files_*.tar.gz" -mtime +7 -delete

echo -e "\033[0;35m[INFO] Full backup completed successfully\033[0m"

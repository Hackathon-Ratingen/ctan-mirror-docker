#!/bin/bash
set -e

CTAN_SYNC_CRON="${CTAN_SYNC_CRON:-21 * * * *}"
HOST="${HOST:-localhost}"

if [[ "$CTAN_SYNC_CRON" == *$'\n'* || "$CTAN_SYNC_CRON" == *$'\r'* ]]; then
    echo "CTAN_SYNC_CRON must contain exactly one cron schedule" >&2
    exit 1
fi

read -r -a cron_fields <<< "$CTAN_SYNC_CRON"
if (( ${#cron_fields[@]} != 5 )) && \
    [[ ! "$CTAN_SYNC_CRON" =~ ^@(yearly|annually|monthly|weekly|daily|midnight|hourly|reboot)$ ]]; then
    echo "CTAN_SYNC_CRON must contain five schedule fields or a supported @period" >&2
    exit 1
fi

if [[ ! "$HOST" =~ ^[A-Za-z0-9._-]+(:[0-9]{1,5})?$ ]]; then
    echo "HOST must be a hostname, optionally followed by a port" >&2
    exit 1
fi

if ! printf '%s %s\n' \
    "$CTAN_SYNC_CRON" \
    '/usr/local/bin/sync-ctan.sh >> /var/log/ctan-sync.log 2>&1' \
    | crontab -; then
    echo "CTAN_SYNC_CRON is not a valid cron schedule: $CTAN_SYNC_CRON" >&2
    exit 1
fi

printf 'ServerName %s\n' "$HOST" \
    > /etc/apache2/conf-enabled/ctan-server-name.conf

apache2ctl configtest

# Check if initial sync is needed
if [ ! -f /var/www/html/tex-archive/.sync-timestamp ]; then
    echo "Performing initial CTAN sync (this will take several hours)..."
    /usr/local/bin/sync-ctan.sh
fi

# Start cron after the initial sync so the scheduled job cannot overlap it.
service cron start

# Start Apache in foreground
exec apache2ctl -D FOREGROUND

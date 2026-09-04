#!/bin/bash
set -e

# Start cron
service cron start

# Check if initial sync is needed
if [ ! -f /var/www/html/tex-archive/.sync-timestamp ]; then
    echo "Performing initial CTAN sync (this will take several hours)..."
    /usr/local/bin/sync-ctan.sh
fi

# Start Apache in foreground
exec apache2ctl -D FOREGROUND
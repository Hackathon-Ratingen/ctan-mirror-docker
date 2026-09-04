#!/bin/bash
# CTAN requires daily sync from rsync.dante.ctan.org

RSYNC_SOURCE="rsync://rsync.dante.ctan.org/CTAN"
LOCAL_DIR="/var/www/html/tex-archive"

rsync -av --delete \
  --timeout=300 \
  --contimeout=60 \
  "$RSYNC_SOURCE" "$LOCAL_DIR"

# Update timestamps for monitoring
touch "$LOCAL_DIR/.sync-timestamp"
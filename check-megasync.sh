#!/bin/bash
# Check if mega-sync is running
if ! pgrep -x "mega-sync" >/dev/null 2>&1; then
    echo "$(date): mega-sync not running, starting it..."
    mega-sync /mega_sync/ / &
else
    echo "$(date): mega-sync is running"
fi

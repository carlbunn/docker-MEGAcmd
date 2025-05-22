#!/bin/bash
# Start cron daemon
crond

# Start megasync initially
mega-sync /mega_sync/ / &

# Keep the container running
tail -f /var/log/megasync-monitor.log

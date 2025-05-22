#!/bin/bash
# Start cron daemon
crond

# Start megasync initially
mega-sync &

# Keep the container running
tail -f /var/log/megasync-monitor.log

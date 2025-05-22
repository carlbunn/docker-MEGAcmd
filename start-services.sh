#!/bin/bash
# Start cron daemon
crond

# Start megasync initially
megasync &

# Keep the container running
tail -f /var/log/megasync-monitor.log

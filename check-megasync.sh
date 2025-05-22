#!/bin/bash
# Check if megasync is running
if ! pgrep -x "megasync" >/dev/null 2>&1; then
    echo "$(date): megasync not running, starting it..."
    megasync &
else
    echo "$(date): megasync is running"
fi

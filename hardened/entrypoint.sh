#!/bin/bash
set -e

echo "=== Starting hardened WordPress ==="

# Run the original WordPress entrypoint in background to set up files
docker-entrypoint.sh apache2-foreground &
APACHE_PID=$!

# Wait for WordPress files to be set up then apply hardening
sleep 15
/usr/local/bin/hardening.sh

# Keep Apache running in foreground
wait $APACHE_PID

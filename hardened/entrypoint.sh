#!/bin/bash
set -e

echo "=== Starting hardened WordPress ==="

docker-entrypoint.sh apache2-foreground &
APACHE_PID=$!

sleep 15
/usr/local/bin/hardening.sh

wait $APACHE_PID
 

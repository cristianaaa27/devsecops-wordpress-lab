#!/bin/bash
set -e

echo "=== Starting hardened WordPress ==="

docker-entrypoint.sh true 2>/dev/null || true

/usr/local/bin/hardening.sh

echo "=== Starting Apache ==="
exec "$@"

#!/bin/bash
set -e

echo "=== Applying WordPress hardening ==="

# Remove sensitive files
rm -f /var/www/html/readme.html
rm -f /var/www/html/license.txt
rm -f /var/www/html/wp-config-sample.php

# Disable XML-RPC by replacing it with a blocking stub
cat > /var/www/html/xmlrpc.php << 'EOF'
<?php
// XML-RPC disabled for security
http_response_code(403);
die('XML-RPC is disabled.');
EOF

# Set correct file permissions (hardened)
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# wp-config.php should be tightly locked if it exists
if [ -f /var/www/html/wp-config.php ]; then
    chmod 400 /var/www/html/wp-config.php
fi

echo "=== Hardening complete ==="

#!/bin/bash
set -e

echo "=== Applying WordPress hardening ==="

WP_ROOT=/var/www/html

# Wait for WordPress files to exist
for i in $(seq 1 30); do
    if [ -f "$WP_ROOT/wp-login.php" ]; then
        echo "WordPress files found."
        break
    fi
    echo "Waiting for WordPress files... attempt $i"
    sleep 2
done

# Remove sensitive files
rm -f "$WP_ROOT/readme.html"
rm -f "$WP_ROOT/license.txt"
rm -f "$WP_ROOT/wp-config-sample.php"

# Disable XML-RPC
cat > "$WP_ROOT/xmlrpc.php" << 'EOF'
<?php
http_response_code(403);
die('XML-RPC is disabled.');
EOF

# Block wp-cron via .htaccess addition
if [ -f "$WP_ROOT/.htaccess" ]; then
    if ! grep -q "wp-cron" "$WP_ROOT/.htaccess"; then
        cat >> "$WP_ROOT/.htaccess" << 'EOF'

# Block direct access to wp-cron.php
<Files wp-cron.php>
    Require all denied
</Files>

# Disable directory browsing
Options -Indexes
EOF
    fi
fi

# Set correct permissions
find "$WP_ROOT" -type d -exec chmod 755 {} \;
find "$WP_ROOT" -type f -exec chmod 644 {} \;

echo "=== Hardening complete ==="

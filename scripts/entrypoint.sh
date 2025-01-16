#!/bin/bash
set -e

# Ensure the certs directory exists
mkdir -p /etc/nginx/certs

# Generate a self-signed SSL certificate if not present
if [ ! -f /etc/nginx/certs/server.crt ] || [ ! -f /etc/nginx/certs/server.key ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/certs/server.key \
        -out /etc/nginx/certs/server.crt \
        -subj "/CN=localhost"
fi

# Run the update script
echo "Running update script at startup..."
/usr/local/bin/update_script.sh

# Start Nginx in the background
nginx &

# Start Gunicorn to serve the Flask app
exec gunicorn -w 4 -b 0.0.0.0:5050 backend.app:app

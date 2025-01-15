# Base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    cron \
    nginx \
    npm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd -g 1000 dockster && \
    useradd -u 1000 -g dockster -m dockster && \
    mkdir -p /srv/logs && \
    chown -R dockster:dockster /srv/logs

# Set up Nginx
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    echo 'server { \
        listen 1010; \
        server_name localhost; \
        location / { \
            root /srv/logs; \
            index index.html; \
            autoindex on; \
        } \
    }' > /etc/nginx/sites-available/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Copy scripts
COPY scripts/healthcheck.sh /usr/local/bin/container_healthcheck.sh
COPY scripts/update_script.sh /usr/local/bin/update_script.sh
RUN chmod +x /usr/local/bin/container_healthcheck.sh /usr/local/bin/update_script.sh

# Set up backend
COPY backend /app/backend
RUN pip install --no-cache-dir -r backend/requirements.txt

# Set up frontend
COPY frontend /app/frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Expose port
EXPOSE 1010

# Start services
CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]

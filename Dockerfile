# Use multi-stage build to reduce final image size
# Stage 1: Build the frontend assets
FROM node:18-slim AS frontend-builder

WORKDIR /app/frontend

# Copy package.json and install dependencies
COPY frontend/package.json ./
RUN npm install

# Copy all frontend source files
COPY frontend ./

# Build production-ready frontend assets
RUN npm run build

# Stage 2: Final Image with backend, frontend, and Nginx
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies required for the application
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl jq cron nginx python3-pip openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user for better security
RUN groupadd -g 1000 dockster && \
    useradd -u 1000 -g dockster -m dockster && \
    mkdir -p /srv/logs && \
    chown -R dockster:dockster /srv/logs

# Copy backend files
COPY backend /app/backend

# Create the backend logs directory
RUN mkdir -p /app/backend/logs && \
    touch /app/backend/logs/app.log && \
    chown -R dockster:dockster /app/backend/logs

# Install Python dependencies and Gunicorn
RUN python3 -m ensurepip --upgrade && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir -r /app/backend/requirements.txt gunicorn

# Copy the update script into the container
COPY scripts/update_script.sh /usr/local/bin/update_script.sh

# Make the update script executable
RUN chmod +x /usr/local/bin/update_script.sh

# Create logs directory for script outputs
RUN mkdir -p /srv/logs && \
    touch /srv/logs/update.log /srv/logs/error.log && \
    chown -R dockster:dockster /srv/logs

# Copy Nginx configuration
COPY scripts/nginx.conf /etc/nginx/sites-available/default
RUN [ ! -L /etc/nginx/sites-enabled/default ] || rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Copy the frontend build artifacts from Stage 1
COPY --from=frontend-builder /app/frontend/dist /app/backend/static

# Copy entrypoint script
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy health check script
COPY scripts/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

# Add a health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 CMD /usr/local/bin/healthcheck.sh

# Expose the application port
EXPOSE 1010

# Start services
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

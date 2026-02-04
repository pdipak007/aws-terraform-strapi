#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install build tools
apt-get install -y build-essential git

# Create strapi user
useradd -m -s /bin/bash strapi

# Create strapi directory
mkdir -p /opt/strapi
chown strapi:strapi /opt/strapi

# Install Strapi as strapi user
su - strapi << 'EOF'
cd /opt/strapi

# Create Strapi project
npx create-strapi-app@${strapi_version} myapp --quickstart --no-run --skip-cloud

cd myapp

# Configure environment
cat > .env << 'ENVEOF'
HOST=0.0.0.0
PORT=1337
APP_KEYS=toBeModified1,toBeModified2,toBeModified3,toBeModified4
API_TOKEN_SALT=tobemodified
ADMIN_JWT_SECRET=tobemodified
TRANSFER_TOKEN_SALT=tobemodified
JWT_SECRET=tobemodified
DATABASE_CLIENT=better-sqlite3
DATABASE_FILENAME=.tmp/data.db
ENVEOF

# Install PM2 globally for process management
npm install -g pm2

# Start Strapi with PM2
pm2 start npm --name strapi -- run develop
pm2 save
pm2 startup systemd -u strapi --hp /home/strapi
EOF

# Get PM2 startup command and execute it
su - strapi -c "pm2 startup systemd -u strapi --hp /home/strapi" | tail -n 1 | bash

# Create systemd service for persistence
systemctl enable pm2-strapi

echo "Strapi installation completed!"
echo "Access Strapi at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):1337"

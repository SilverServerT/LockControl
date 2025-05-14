#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Lock Control Configuration Update Script${NC}"
echo "This script will help you set up your configuration file."

# Default Docker paths
DEFAULT_DOCKER_PATH="/config/www/lockcontrol"
CURRENT_DIR=$(pwd)

echo -e "${YELLOW}Docker Path Information:${NC}"
echo "Default Docker path: ${DEFAULT_DOCKER_PATH}"
echo "Current directory: ${CURRENT_DIR}"
echo
echo "If you're running this in a Docker container, make sure this directory"
echo "is properly mounted to your Home Assistant configuration."
echo
read -p "Is this the correct directory for your Docker container? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter the correct Docker path: " CUSTOM_DOCKER_PATH
    if [ -z "$CUSTOM_DOCKER_PATH" ]; then
        echo -e "${RED}Error: Docker path is required.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Using custom Docker path: ${CUSTOM_DOCKER_PATH}${NC}"
fi

# Check if config.local.js already exists
if [ -f "config.local.js" ]; then
    echo -e "${YELLOW}Warning: config.local.js already exists.${NC}"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Operation cancelled.${NC}"
        exit 1
    fi
fi

# Get Home Assistant URL
read -p "Enter your Home Assistant URL (e.g., https://ha.silverserver.nl): " HA_URL
if [ -z "$HA_URL" ]; then
    echo -e "${RED}Error: Home Assistant URL is required.${NC}"
    exit 1
fi

# Get Home Assistant token
read -p "Enter your Home Assistant long-lived access token: " HA_TOKEN
if [ -z "$HA_TOKEN" ]; then
    echo -e "${RED}Error: Home Assistant token is required.${NC}"
    exit 1
fi

# Create config.local.js
cat > config.local.js << EOL
// Home Assistant Configuration
const config = {
    HA_TOKEN: '${HA_TOKEN}',
    HA_URL: '${HA_URL}',
    DOCKER_PATH: '${CUSTOM_DOCKER_PATH:-$DEFAULT_DOCKER_PATH}'
};

// Prevent modification of the config object
Object.freeze(config);
EOL

# Set proper permissions
chmod 600 config.local.js

echo -e "${GREEN}Configuration file created successfully!${NC}"
echo -e "${YELLOW}Important:${NC}"
echo "1. Make sure config.local.js is in your .gitignore"
echo "2. Never commit this file to version control"
echo "3. Keep your token secure"
echo "4. Docker path is set to: ${CUSTOM_DOCKER_PATH:-$DEFAULT_DOCKER_PATH}"

# Verify .gitignore
if grep -q "config.local.js" .gitignore; then
    echo -e "${GREEN}config.local.js is properly ignored in .gitignore${NC}"
else
    echo -e "${YELLOW}Warning: config.local.js is not in .gitignore${NC}"
    read -p "Do you want to add it now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "config.local.js" >> .gitignore
        echo -e "${GREEN}Added to .gitignore${NC}"
    fi
fi

echo
echo -e "${YELLOW}Docker Setup Instructions:${NC}"
echo "1. Make sure your Docker container has the correct volume mount:"
echo "   -v /path/to/your/config/www/lockcontrol:/config/www/lockcontrol"
echo "2. The files should be accessible through your Home Assistant instance at:"
echo "   http://your-ha-ip:8123/local/lockcontrol/"
echo "3. If you need to change the path, update the DOCKER_PATH in config.local.js"

echo
echo -e "${YELLOW}Home Assistant Integration Instructions:${NC}"
echo "1. Copy all files to your Home Assistant www directory:"
echo "   - For Docker: Copy to /config/www/lockcontrol/"
echo "   - For Home Assistant OS: Copy to /config/www/lockcontrol/"
echo "   - For Home Assistant Supervised: Copy to /config/www/lockcontrol/"
echo
echo "2. Required files to copy:"
echo "   - lockcontrol.html"
echo "   - config.local.js (created by this script)"
echo "   - All other .html files"
echo "   - All .js files"
echo "   - All .css files"
echo
echo "3. After copying, restart Home Assistant or reload the www folder"
echo "4. Access the interface at: http://your-ha-ip:8123/local/lockcontrol/lockcontrol.html"
echo
echo -e "${YELLOW}Note:${NC} If you're using Docker, make sure the volume mount includes the www directory"
echo "      and that the permissions are set correctly (usually www-data:www-data)" 
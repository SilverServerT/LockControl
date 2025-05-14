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

echo -e "${YELLOW}Home Assistant Installation Type:${NC}"
echo "Please select your Home Assistant installation type:"
echo "1) Home Assistant OS"
echo "2) Home Assistant Container"
echo "3) Home Assistant Supervised"
echo "4) Home Assistant Core"
echo "5) Local Development"
read -p "Enter your choice (1-5): " HA_TYPE

case $HA_TYPE in
    1|2|3)
        HA_PATH="/config/www/lockcontrol"
        ;;
    4)
        HA_PATH="/homeassistant/www/lockcontrol"
        ;;
    5)
        read -p "Enter your local web server path: " HA_PATH
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Path Information:${NC}"
echo "Selected path: ${HA_PATH}"
echo "Current directory: ${CURRENT_DIR}"
echo
echo "If you're running this in a Docker container, make sure this directory"
echo "is properly mounted to your Home Assistant configuration."
echo
read -p "Is this the correct directory? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter the correct path: " CUSTOM_PATH
    if [ -z "$CUSTOM_PATH" ]; then
        echo -e "${RED}Error: Path is required.${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Using custom path: ${CUSTOM_PATH}${NC}"
    HA_PATH=$CUSTOM_PATH
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
    DOCKER_PATH: '${HA_PATH}'
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
echo "4. Path is set to: ${HA_PATH}"

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
echo -e "${YELLOW}Home Assistant Integration Instructions:${NC}"
echo "1. Copy all files to your Home Assistant www directory:"
echo "   Selected path: ${HA_PATH}"
echo
echo "2. Required files to copy:"
echo "   - lockcontrol.html"
echo "   - config.local.js (created by this script)"
echo "   - All other .html files"
echo "   - All .js files"
echo "   - All .css files"
echo
echo "3. After copying, restart Home Assistant or reload the www folder"
echo "4. Access the interface:"
if [ "$HA_TYPE" = "5" ]; then
    echo "   - Via your local web server URL"
else
    echo "   - If using Home Assistant's built-in web server: http://your-ha-ip:8123/local/lockcontrol/lockcontrol.html"
    echo "   - If using a reverse proxy: https://your-domain/local/lockcontrol/lockcontrol.html"
fi
echo
echo -e "${YELLOW}Note:${NC} Make sure the directory has the correct permissions"
echo "      (usually www-data:www-data for Home Assistant installations)" 
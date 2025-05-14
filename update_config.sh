#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to read values from a config file
read_config_file() {
    local config_file=$1
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}Error: Config file not found: $config_file${NC}"
        exit 1
    fi

    # Debug: Show file contents
    echo -e "${YELLOW}Reading config file:${NC}"
    cat "$config_file"
    echo "-------------------"

    # Read values from config file, handling both with and without quotes
    HA_URL=$(grep "^HA_URL=" "$config_file" | sed -E 's/^HA_URL=["]?([^"]*)["]?$/\1/' | tr -d '\r')
    HA_TOKEN=$(grep "^HA_TOKEN=" "$config_file" | sed -E 's/^HA_TOKEN=["]?([^"]*)["]?$/\1/' | tr -d '\r')

    # Debug: Show extracted values
    echo -e "${YELLOW}Extracted values:${NC}"
    echo "HA_URL: $HA_URL"
    echo "HA_TOKEN: $HA_TOKEN"
    echo "-------------------"

    # Validate values
    if [ -z "$HA_URL" ]; then
        echo -e "${RED}Error: HA_URL not found in config file${NC}"
        exit 1
    fi
    if [ -z "$HA_TOKEN" ]; then
        echo -e "${RED}Error: HA_TOKEN not found in config file${NC}"
        exit 1
    fi

    # Validate URL format
    if [[ ! "$HA_URL" =~ ^https?:// ]]; then
        echo -e "${RED}Error: Invalid URL format in HA_URL${NC}"
        exit 1
    fi
}

echo -e "${YELLOW}Lock Control Configuration Update Script${NC}"
echo "This script will help you set up your configuration file."

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

# Check if a config file was provided as an argument
if [ $# -eq 1 ]; then
    echo -e "${GREEN}Reading configuration from: $1${NC}"
    read_config_file "$1"
else
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
fi

# Create config.local.js
cat > config.local.js << EOL
// Home Assistant Configuration
const config = {
    HA_TOKEN: '${HA_TOKEN}',
    HA_URL: '${HA_URL}'
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
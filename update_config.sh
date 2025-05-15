#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Lock Control Configuration Update Script${NC}"
echo "This script will help you set up your configuration file."

# Function to validate keypad code
validate_keypad_code() {
    local code=$1
    # Remove any non-numeric characters
    code=$(echo "$code" | tr -cd '0-9')
    
    # Check if code is empty
    if [ -z "$code" ]; then
        return 1
    fi
    
    # Check if code is within valid range (4-8 digits)
    if [ ${#code} -ge 4 ] && [ ${#code} -le 8 ]; then
        return 0
    else
        return 1
    fi
}

# Function to format keypad code
format_keypad_code() {
    local code=$1
    # Remove any non-numeric characters
    code=$(echo "$code" | tr -cd '0-9')
    
    # Format as 4-8 digit code
    if [ ${#code} -ge 4 ] && [ ${#code} -le 8 ]; then
        echo "$code"
    else
        return 1
    fi
}

# Default path
DEFAULT_PATH="/var/lib/docker/volumes/hass_config/_data/www/admin-dashboard"
CURRENT_DIR=$(pwd)

# Function to extract value from config.local.js
extract_config_value() {
    local key=$1
    local value=$(grep -o "${key}: '[^']*'" config.local.js 2>/dev/null | cut -d"'" -f2)
    echo "$value"
}

# Check for existing config.local.js and read values
if [ -f "config.local.js" ]; then
    echo -e "${YELLOW}Found existing config.local.js${NC}"
    EXISTING_PATH=$(extract_config_value "DOCKER_PATH")
    EXISTING_URL=$(extract_config_value "HA_URL")
    EXISTING_TOKEN=$(extract_config_value "HA_TOKEN")
    
    if [ ! -z "$EXISTING_PATH" ]; then
        DEFAULT_PATH=$EXISTING_PATH
        echo "Found existing path: $EXISTING_PATH"
        read -p "Do you want to use a different path? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            HA_PATH=$EXISTING_PATH
        else
            read -p "Enter the new target directory path: " HA_PATH
            if [ -z "$HA_PATH" ]; then
                echo -e "${RED}Error: Path is required.${NC}"
                exit 1
            fi
        fi
    else
        read -p "Enter the target directory path (press Enter for default: $DEFAULT_PATH): " HA_PATH
        HA_PATH=${HA_PATH:-$DEFAULT_PATH}
    fi
else
    read -p "Enter the target directory path (press Enter for default: $DEFAULT_PATH): " HA_PATH
    HA_PATH=${HA_PATH:-$DEFAULT_PATH}
fi

echo -e "${YELLOW}Selected path: ${HA_PATH}${NC}"

# Get Home Assistant URL
if [ ! -z "$EXISTING_URL" ]; then
    read -p "Enter your Home Assistant URL (press Enter for existing: $EXISTING_URL): " HA_URL
    HA_URL=${HA_URL:-$EXISTING_URL}
else
    read -p "Enter your Home Assistant URL (e.g., https://ha.silverserver.nl): " HA_URL
fi

if [ -z "$HA_URL" ]; then
    echo -e "${RED}Error: Home Assistant URL is required.${NC}"
    exit 1
fi

# Get Home Assistant token
if [ ! -z "$EXISTING_TOKEN" ]; then
    read -p "Enter your Home Assistant long-lived access token (press Enter to keep existing): " HA_TOKEN
    HA_TOKEN=${HA_TOKEN:-$EXISTING_TOKEN}
else
    read -p "Enter your Home Assistant long-lived access token: " HA_TOKEN
fi

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
    DOCKER_PATH: '${HA_PATH}',
    KEYPAD_FORMAT: 'numeric', // numeric keypad format (4-8 digits)
    KEYPAD_VALIDATION: true,
    MIN_CODE_LENGTH: 4,
    MAX_CODE_LENGTH: 8
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
echo "5. Keypad format is set to numeric (4-8 digits)"

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

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p "${HA_PATH}/accesscontrol"

# Copy files
echo -e "${YELLOW}Copying files...${NC}"
cp -v lockcontrol.html "${HA_PATH}/"
cp -v lockcontrolv2.html "${HA_PATH}/"
cp -v admin_panel.html "${HA_PATH}/"
cp -v config.local.js "${HA_PATH}/"
cp -v config.template "${HA_PATH}/"
cp -v keylock_reader.yaml "${HA_PATH}/"
cp -v accesscontrol/access_control.yaml "${HA_PATH}/accesscontrol/"
cp -v accesscontrol/access_control_iterations.yaml "${HA_PATH}/accesscontrol/"

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chmod 644 "${HA_PATH}"/*.html
chmod 644 "${HA_PATH}"/*.yaml
chmod 644 "${HA_PATH}/accesscontrol"/*.yaml
chmod 600 "${HA_PATH}/config.local.js"

echo
echo -e "${YELLOW}Setup Instructions:${NC}"
echo "1. Files have been copied to: ${HA_PATH}"
echo
echo "2. Directory structure:"
echo "   ${HA_PATH}/"
echo "   ├── lockcontrol.html"
echo "   ├── lockcontrolv2.html"
echo "   ├── admin_panel.html"
echo "   ├── config.local.js"
echo "   ├── config.template"
echo "   ├── keylock_reader.yaml"
echo "   └── accesscontrol/"
echo "       ├── access_control.yaml"
echo "       └── access_control_iterations.yaml"
echo
echo "3. After copying, restart Home Assistant or reload the www folder"
echo "4. Access the interfaces:"
echo "   - Main interface: ${HA_URL}/local/admin-dashboard/lockcontrol.html"
echo "   - New interface: ${HA_URL}/local/admin-dashboard/lockcontrolv2.html"
echo "   - Admin panel: ${HA_URL}/local/admin-dashboard/admin_panel.html"
echo
echo -e "${YELLOW}Note:${NC} Make sure the directory has the correct permissions"
echo "      (usually www-data:www-data for Home Assistant installations)"
echo
echo -e "${YELLOW}Keypad Code Information:${NC}"
echo "The system is configured to use numeric keypad codes:"
echo "- Codes must be 4-8 digits long"
echo "- Only numbers 0-9 are allowed"
echo "- Example codes: 1234, 567890, 12345678"
echo
echo -e "${GREEN}Setup complete!${NC}" 
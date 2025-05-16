#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_CONFIG="config.js"
CONFIG_FILE=""
TEMPLATE_FILE="config.template.js"
BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FORCE_MODE=false
AUTO_CONFIRM=false

# Parse command line arguments
while getopts "fy" opt; do
  case $opt in
    f)
      FORCE_MODE=true
      ;;
    y)
      AUTO_CONFIRM=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Get the input file from the first non-option argument
shift $((OPTIND-1))
if [ ! -z "$1" ]; then
    CONFIG_FILE="$1"
else
    CONFIG_FILE="$DEFAULT_CONFIG"
fi

# Function to create backup
create_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    cp "$CONFIG_FILE" "$BACKUP_DIR/${CONFIG_FILE%.*}_${TIMESTAMP}.js"
    echo "Created backup: $BACKUP_DIR/${CONFIG_FILE%.*}_${TIMESTAMP}.js"
}

# Function to update config
update_config() {
    if [ -f "$CONFIG_FILE" ]; then
        create_backup
    fi

    # Create new config file from template
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    echo "Created new config file from template"
}

# Function to show summary
show_summary() {
    echo -e "\n=== Update Summary ==="
    echo "1. Backup created: $BACKUP_DIR/${CONFIG_FILE%.*}_${TIMESTAMP}.js"
    echo "2. New config file created from template"
    echo "3. Next steps:"
    echo "   - Verify the new config file"
    echo "   - Update any custom settings"
    echo "   - Restart the application"
    echo "====================="
}

echo -e "${YELLOW}Lock Control Configuration Update Script${NC}"
echo "Using config file: $CONFIG_FILE"

# Function to extract value from config file
extract_config_value() {
    local key=$1
    local value=$(grep -o "${key}: '[^']*'" "$CONFIG_FILE" 2>/dev/null | cut -d"'" -f2)
    echo "$value"
}

# Check for existing config file and read values
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}Found existing $CONFIG_FILE${NC}"
    EXISTING_PATH=$(extract_config_value "DOCKER_PATH")
    EXISTING_URL=$(extract_config_value "HA_URL")
    EXISTING_TOKEN=$(extract_config_value "HA_TOKEN")
    
    if [ "$FORCE_MODE" = true ] || [ "$AUTO_CONFIRM" = true ]; then
        # Use existing values without prompts
        HA_PATH=$EXISTING_PATH
        HA_URL=$EXISTING_URL
        HA_TOKEN=$EXISTING_TOKEN
    else
        # Interactive mode with prompts
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

        # Get Home Assistant URL
        if [ ! -z "$EXISTING_URL" ]; then
            read -p "Enter your Home Assistant URL (press Enter for existing: $EXISTING_URL): " HA_URL
            HA_URL=${HA_URL:-$EXISTING_URL}
        else
            read -p "Enter your Home Assistant URL (e.g., https://ha.silverserver.nl): " HA_URL
        fi

        # Get Home Assistant token
        if [ ! -z "$EXISTING_TOKEN" ]; then
            read -p "Enter your Home Assistant long-lived access token (press Enter to keep existing): " HA_TOKEN
            HA_TOKEN=${HA_TOKEN:-$EXISTING_TOKEN}
        else
            read -p "Enter your Home Assistant long-lived access token: " HA_TOKEN
        fi
    fi
else
    echo -e "${RED}Error: Config file not found: $CONFIG_FILE${NC}"
    exit 1
fi

# Ensure URL starts with https://
if [[ ! "$HA_URL" =~ ^https:// ]]; then
    if [[ "$HA_URL" =~ ^http:// ]]; then
        HA_URL="https://${HA_URL#http://}"
    else
        HA_URL="https://${HA_URL}"
    fi
fi

# Remove trailing slash if present
HA_URL=${HA_URL%/}

if [ -z "$HA_URL" ] || [ -z "$HA_TOKEN" ] || [ -z "$HA_PATH" ]; then
    echo -e "${RED}Error: Missing required values in config file: $CONFIG_FILE${NC}"
    exit 1
fi

echo -e "${YELLOW}Using values from config:${NC}"
echo "HA_URL: ${HA_URL}"
echo "HA_TOKEN: ${HA_TOKEN:0:10}...${HA_TOKEN: -5}"
echo "DOCKER_PATH: ${HA_PATH}"

# Create config file
cat > "$CONFIG_FILE" << EOL
// Home Assistant Configuration
const config = {
    HA_TOKEN: '${HA_TOKEN}',
    HA_URL: '${HA_URL}',
    DOCKER_PATH: '${HA_PATH}',
    VERSION: '2.0.0',
    timezone: 'Europe/Amsterdam',
    codeLength: 6,
    maxAttempts: 3,
    lockoutDuration: 300,
    codeExpiry: 86400,
    tasmotaSwitch: 'tasmota.switch',
    simulationMode: true,
    stateEntities: {
        dailyCode: 'input_text.lockcontrol_daily_code',
        dailyCodeExpiry: 'input_datetime.lockcontrol_daily_code_expiry',
        oneTimeCode: 'input_text.lockcontrol_one_time_code',
        oneTimeCodeExpiry: 'input_datetime.lockcontrol_one_time_code_expiry'
    }
};

// Prevent modification of the config object
Object.freeze(config);
EOL

# Set proper permissions
chmod 600 "$CONFIG_FILE"

echo -e "${GREEN}Configuration file updated successfully!${NC}"

# Create directory structure and copy files
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p "${HA_PATH}/accesscontrol"

# Copy files
echo -e "${YELLOW}Copying files...${NC}"
cp -f lockcontrol.html "${HA_PATH}/"
cp -f lockcontrolv2.html "${HA_PATH}/"
cp -f admin_panel.html "${HA_PATH}/"
cp -f "$CONFIG_FILE" "${HA_PATH}/"
cp -f config.template "${HA_PATH}/"
cp -f keylock_reader.yaml "${HA_PATH}/"
cp -f version_tracking.js "${HA_PATH}/"
cp -f accesscontrol/access_control.yaml "${HA_PATH}/accesscontrol/"
cp -f accesscontrol/access_control_iterations.yaml "${HA_PATH}/accesscontrol/"

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chmod 644 "${HA_PATH}"/*.html
chmod 644 "${HA_PATH}"/*.yaml
chmod 644 "${HA_PATH}"/*.js
chmod 644 "${HA_PATH}/accesscontrol"/*.yaml
chmod 600 "${HA_PATH}/$CONFIG_FILE"

# Ensure proper ownership
echo -e "${YELLOW}Setting ownership...${NC}"
if [ -d "/var/lib/docker" ]; then
    chown www-data:www-data "${HA_PATH}"/*.html
    chown www-data:www-data "${HA_PATH}"/*.yaml
    chown www-data:www-data "${HA_PATH}"/*.js
    chown www-data:www-data "${HA_PATH}/accesscontrol"/*.yaml
    chown www-data:www-data "${HA_PATH}/$CONFIG_FILE"
else
    chown $(whoami):$(whoami) "${HA_PATH}"/*.html
    chown $(whoami):$(whoami) "${HA_PATH}"/*.yaml
    chown $(whoami):$(whoami) "${HA_PATH}"/*.js
    chown $(whoami):$(whoami) "${HA_PATH}/accesscontrol"/*.yaml
    chown $(whoami):$(whoami) "${HA_PATH}/$CONFIG_FILE"
fi

echo -e "${GREEN}Setup complete!${NC}" 
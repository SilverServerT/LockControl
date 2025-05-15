# Lock Control Interface

A simple web interface for controlling a lock via Home Assistant.

![Lock Control Interface](lockcontrol.png)

## Hardware Setup

### Required Components
- Shelly Plus 1 (or similar Shelly relay)
- 220V AC to 12V DC Magnetic Lock Controller
  - Input: 220V AC
  - Output: 12V DC
  - Features: Normally Open (NO) and Normally Closed (NC) contacts
  - Manual override switch
- 12V Magnetic Lock

### Important Setup Notes
1. Research and understand how to properly connect a Shelly Plus 1 to your specific magnetic lock controller
2. Consult your magnetic lock controller's documentation for proper wiring instructions
3. Ensure you understand the difference between fail-safe and fail-secure operation
4. Always follow local electrical codes and safety regulations
5. Consider consulting with a qualified electrician for installation

### Home Assistant Configuration
1. Add the Shelly Plus 1 to Home Assistant:
   ```yaml
   # Example configuration.yaml entry
   shelly:
     discovery: true
   ```

2. Create a lock entity in Home Assistant:
   ```yaml
   # Example lock.yaml
   lock:
     - platform: template
       name: "Front Door Lock"
       unique_id: front_door_lock
       value_template: "{{ states('input_boolean.door_lock_state') }}"
       lock:
         service: switch.turn_on
         target:
           entity_id: switch.shelly_plus_1_relay_0
       unlock:
         service: switch.turn_off
         target:
           entity_id: switch.shelly_plus_1_relay_0
   ```

### Safety Considerations
1. Always use a properly rated magnetic lock controller
2. Ensure proper grounding of all components
3. Use appropriate wire gauges for both AC and DC circuits
4. Consider adding a backup power supply for the lock
5. Test the manual override switch regularly
6. Label all wires and connections clearly
7. Consider adding a power indicator LED
8. Install a circuit breaker for the AC input
9. Never work on live electrical circuits
10. Follow all manufacturer safety guidelines

### Troubleshooting
1. If the lock doesn't respond:
   - Check AC power to the controller
   - Verify DC output voltage (should be 12V)
   - Check Shelly Plus 1 connection to NO/NC contacts
   - Verify Shelly Plus 1 is connected to WiFi
   - Check Home Assistant entity states

2. If manual override doesn't work:
   - Check switch connections
   - Verify controller's manual override functionality
   - Test with power disconnected

## Interface Overview

The interface provides a clean, modern UI for controlling your lock with the following features:

### Main Controls
- **Lock/Unlock Button**: Large toggle button that changes color and icon based on lock state
  - Green when locked
  - Red when unlocked
  - Shows loading state during operations

### Quick Access Timers
- **10 Second Unlock**: Temporarily unlocks the door for 10 seconds
- **30 Minute Unlock**: Keeps the door unlocked for 30 minutes
- **Until Sunset**: Unlocks the door until the next sunset (only available during daytime)

### Status Information
- **Lock Status**: Shows current lock state with visual indicator
- **Timer Display**: Shows countdown when a timer is active
- **Info Bar**: Displays:
  - Current time
  - Current date
  - Weather conditions
  - Sunset time

### Additional Features
- **P2000 Notifications**: Shows recent emergency service notifications
- **Garbage Collection**: Displays next day's garbage collection schedule
- **Debug Mode**: Accessible via URL parameter `?debug` for testing time-based features

## Features

- Clean, modern UI with a lock/unlock button
- Real-time status updates
- Visual feedback for actions
- Error handling and user notifications
- Docker support with customizable paths
- Easy configuration script

## Installation

### Option 1: Using the Configuration Script (Recommended)

1. Clone this repository
2. Run the configuration script:
   ```bash
   ./update_config.sh
   ```
3. Follow the prompts to set up your configuration
4. The script will guide you through the Docker path setup and file copying process

### Option 2: Manual Installation

1. Clone this repository
2. Copy `config.js` to `config.local.js` and update the following values:
   - `HA_TOKEN`: Your Home Assistant long-lived access token
   - `HA_URL`: Your Home Assistant instance URL
   - `DOCKER_PATH`: Your Home Assistant www directory path (default: /config/www/lockcontrol)

## Home Assistant Integration

### File Location
Copy all files to your Home Assistant www directory. The location depends on your Home Assistant installation type:

- **Home Assistant OS**: `/config/www/lockcontrol/`
- **Home Assistant Container**: `/config/www/lockcontrol/`
- **Home Assistant Supervised**: `/config/www/lockcontrol/`
- **Home Assistant Core**: `/homeassistant/www/lockcontrol/`

### Required Files
Make sure to copy:
- `lockcontrol.html` (main interface)
- `config.local.js` (your configuration)
- All other `.html` files
- All `.js` files
- All `.css` files

### Docker Setup
If using Docker, ensure your volume mount includes:
```yaml
volumes:
  - /path/to/your/config/www/lockcontrol:/config/www/lockcontrol
```

### Accessing the Interface
After copying the files:
1. Restart Home Assistant or reload the www folder
2. Access the interface through your Home Assistant instance:
   - If using Home Assistant's built-in web server: `http://your-ha-ip:8123/local/lockcontrol/lockcontrol.html`
   - If using a reverse proxy: `https://your-domain/local/lockcontrol/lockcontrol.html`
   - If using a custom web server: Configure according to your setup

### Local Development
For local development and testing:
1. Copy the files to your local web server directory
2. Access via your local web server URL
3. Make sure your Home Assistant instance is accessible from your development machine

## Security Notes

- Never commit your `config.local.js` file with real credentials
- Keep your Home Assistant token secure
- Consider using HTTPS for your Home Assistant instance
- Ensure proper file permissions (usually www-data:www-data)

## Dependencies

- Home Assistant instance
- Modern web browser with JavaScript enabled
- Docker (optional, for containerized setup)

## License

GPL

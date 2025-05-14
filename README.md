# Lock Control Interface

A simple web interface for controlling a lock via Home Assistant.

![Lock Control Interface](lockcontrol.png)

## Hardware Setup

### Required Components
- Shelly Plus 1 (or similar Shelly relay)
- 12V Magnetic Lock Controller
- 12V Power Supply
- Magnetic Lock (12V)
- Door Contact Sensor (optional, for status feedback)

### Wiring Diagram
```
12V Power Supply
    │
    ├─── Shelly Plus 1 (Power)
    │    │
    │    └─── Shelly Plus 1 (Switch)
    │         │
    │         └─── Magnetic Lock Controller
    │              │
    │              └─── Magnetic Lock
    │
    └─── Door Contact Sensor (optional)
         │
         └─── Shelly Plus 1 (Input)
```

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

3. Optional: Add door contact sensor for status feedback:
   ```yaml
   # Example binary_sensor.yaml
   binary_sensor:
     - platform: template
       sensors:
         door_contact:
           friendly_name: "Door Contact"
           value_template: "{{ states('sensor.shelly_plus_1_input') == 'on' }}"
   ```

### Safety Considerations
1. Always use a properly rated power supply for your magnetic lock
2. Consider adding a backup power supply for the lock
3. Ensure proper grounding of all components
4. Use appropriate wire gauges for the current requirements
5. Consider adding a manual override switch for emergency situations

### Troubleshooting
1. If the lock doesn't respond:
   - Check power supply voltage
   - Verify Shelly Plus 1 is connected to WiFi
   - Check Home Assistant entity states
   - Verify wiring connections

2. If status feedback is incorrect:
   - Check door contact sensor alignment
   - Verify sensor wiring
   - Check Home Assistant entity configuration

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

MIT License 
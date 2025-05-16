# Lock Control Interface

A modern, mobile-friendly interface for controlling magnetic locks with Home Assistant integration.

## Features

- Real-time lock status monitoring
- Multiple unlock duration options (10s, 30min, until sunset)
- Mobile-friendly interface with touch support
- Automatic timer management
- Weather and time information
- Brandweer (Fire Department) notifications
- Garbage collection schedule display
- Version checking and YAML update notifications
- Debug tools for state management
- Clear separation of immediate and timed lock control

## Mobile Support

The interface is fully optimized for mobile devices with:
- Touch-friendly controls
- Responsive design
- Mobile-specific optimizations
- Debug panel for troubleshooting (🔍 button in bottom right)
- Cache management tools
- State management debugging

## Installation

1. Copy the `lockcontrol` folder to your Home Assistant's `www` directory
2. Add the following to your `configuration.yaml`:

```yaml
input_text:
  lockcontrol_daily_code:
    name: Daily Code
    max: 6
  lockcontrol_one_time_code:
    name: One Time Code
    max: 6
  version:
    name: Version

input_datetime:
  lockcontrol_daily_code_expiry:
    name: Daily Code Expiry
    has_date: true
    has_time: true
  lockcontrol_one_time_code_expiry:
    name: One Time Code Expiry
    has_date: true
    has_time: true
  lock_unlock_end:
    name: Lock Unlock End
    has_date: true
    has_time: true
```

3. Create a `config.js` file in the `lockcontrol` directory with your Home Assistant token:

```javascript
const config = {
    HA_TOKEN: 'your_long_lived_access_token',
    HA_URL: 'https://your-home-assistant-url',
    VERSION: '2.1.0'
};
```

## Usage

1. Access the interface through your Home Assistant instance at `/local/lockcontrol/lockcontrol.html`
2. Use the interface to control your magnetic lock:
   - Main toggle button for immediate lock/unlock
   - Duration buttons for timed unlocks
   - Debug button to clear all states if needed
3. For mobile devices, use the debug panel (🔍) if you encounter any issues

## Troubleshooting

### Mobile Issues
1. Click the 🔍 debug button in the bottom right
2. Check the debug panel for error messages
3. Use the "Clear Cache & Reload" button if needed

### Lock State Issues
1. Use the "Clear All States" debug button to reset all states
2. Verify the lock state in Home Assistant
3. Check the debug panel for state transition errors

### Configuration Issues
1. Verify your `config.js` file is in the correct location
2. Check the debug panel for config loading errors
3. Ensure your Home Assistant token is valid

## Version Information

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and version history.

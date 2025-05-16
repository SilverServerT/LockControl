# Lock Control System

⚠️ **IMPORTANT: This is example code only** ⚠️

This codebase contains debug logging and several unfinished features. It is provided as a reference implementation and should not be used in production without significant modifications.

## Features

- Magnetic lock control with status display
- Daily code generation and display
- One-time code generation and display
- Automatic lock status updates
- Weather information display
- Sunset/sunrise time display
- Brandweer (Fire Department) status display
- Debug logging and state management
- Version tracking and YAML update notifications

## Debug Features

- Extensive console logging for troubleshooting
- State change tracking
- Error reporting
- Cache clearing functionality
- Manual refresh capability

## Unfinished Features

- WebSocket implementation (currently using polling)
- Some error handling scenarios
- Complete state synchronization
- Full mobile responsiveness
- Complete documentation

## Requirements

- Home Assistant instance
- Tasmota switch for lock control
- Input text entities for codes
- Input datetime entities for expiry times
- Weather entity
- Sun entity
- Brandweer sensor

## Configuration

The system requires several entities to be set up in Home Assistant:

- `input_text.lockcontrol_daily_code`
- `input_datetime.lockcontrol_daily_code_expiry`
- `input_text.lockcontrol_one_time_code`
- `input_datetime.lockcontrol_one_time_code_expiry`
- `input_datetime.lock_unlock_end`
- `sensor.brandweerdiensten`
- `sensor.lockcontrol_version`

## Installation

1. Copy the files to your Home Assistant `www` directory
2. Set up the required entities in Home Assistant
3. Configure the `config.js` file with your settings
4. Access the interface through your Home Assistant instance

## Usage

The interface provides:
- Lock status display
- Daily code display
- One-time code display
- Weather information
- Sunset/sunrise times
- Brandweer status
- Debug controls

## Debug Mode

The system includes extensive debug logging. Check the browser console for detailed information about:
- State changes
- API calls
- Error conditions
- Timing information
- Configuration status

## Known Issues

- Some features may not work as expected
- Error handling is incomplete
- Mobile responsiveness needs improvement
- State synchronization may have delays
- Documentation is incomplete

## Contributing

This is example code and not actively maintained. Feel free to use it as a reference for your own implementations.

## License

This code is provided as-is with no warranty. Use at your own risk.

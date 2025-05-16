# Lock Control System

A secure and flexible door access control system integrated with Home Assistant.

## Overview

The Lock Control System is a comprehensive door access management solution designed for Home Assistant environments. It provides a secure and user-friendly interface for managing door access through various authentication methods while maintaining detailed logs and security controls.

### Purpose
This system is designed for:
- Managing secure access to buildings or rooms
- Providing temporary access through daily and one-time codes
- Monitoring door status and access attempts
- Integrating with Home Assistant for automation and control
- Supporting emergency services access (Brandweer/Fire Department)

### How It Works

1. **Access Control**
   - Daily codes are generated and automatically rotated
   - One-time codes can be generated for temporary access
   - Night mode protection automatically disables daily codes after sunset
   - Magnetic lock control with configurable unlock durations

2. **Security Features**
   - Automatic code rotation and expiration
   - Night mode protection
   - Access logging and monitoring
   - Door state verification
   - Integration with Home Assistant security features

3. **Integration**
   - Connects to Home Assistant for centralized control
   - Uses Tasmota switches for lock control
   - Integrates with weather and sun position data
   - Supports emergency services status monitoring

4. **User Interface**
   - Mobile-friendly design
   - Real-time status updates
   - Weather and time information
   - Emergency services status
   - Debug controls for troubleshooting

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
- Daily code generation with night mode protection
- One-time code support
- Home Assistant integration
- Mobile-friendly interface
- Real-time status updates
- Secure access control

## Security
The system includes several security features:
- Night mode protection for daily codes
- Code expiration and rotation
- Access logging
- Door state monitoring

For a complete list of security features and planned improvements, see [TODO.md](TODO.md).

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

1. Copy the files to your Home Assistant configuration directory
2. Configure the required entities in Home Assistant
3. Set up the necessary automations
4. Configure the web interface

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

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

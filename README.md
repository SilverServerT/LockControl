# Lock Control System (Experimental)

⚠️ **EXPERIMENTAL CODE - USE AT YOUR OWN RISK** ⚠️

This is an experimental project exploring secure door access control using Home Assistant. The code is provided as-is with no guarantees of functionality or security. This is a work in progress and should not be used in production environments.

## Project Goals

I'm working towards creating a secure, flexible, and user-friendly door access system that:
- Provides secure access control through multiple methods
- Integrates seamlessly with Home Assistant
- Supports emergency services access
- Implements proper security measures
- Is easy to maintain and extend

## Current Status

This is an experimental implementation that includes:
- Basic door control functionality
- Daily and one-time code generation
- Night mode protection
- Weather and time information display
- Emergency services status monitoring
- Debug features for development

## Features (Experimental)

- Magnetic lock control
- Daily code system with night mode
- One-time code generation
- Weather information display
- Sunset/sunrise time display
- Emergency services status
- Debug logging and controls
- Mobile-friendly interface

## Security Notice

This is experimental code and has not undergone proper security auditing. Several security improvements are planned and documented in [TODO.md](TODO.md). Do not use this code in any environment where security is critical.

## Requirements

- Home Assistant instance
- Tasmota switch for lock control
- Various Home Assistant entities (see Configuration)

## Configuration

Required Home Assistant entities:
- `input_text.lockcontrol_daily_code`
- `input_datetime.lockcontrol_daily_code_expiry`
- `input_text.lockcontrol_one_time_code`
- `input_datetime.lockcontrol_one_time_code_expiry`
- `input_datetime.lock_unlock_end`
- `sensor.brandweerdiensten`
- `sensor.lockcontrol_version`

## Installation

1. Copy files to Home Assistant configuration directory
2. Set up required entities
3. Configure automations
4. Test thoroughly in a safe environment

## Debug Features

- Console logging
- State tracking
- Error reporting
- Cache controls
- Manual refresh

## Known Issues

- Incomplete error handling
- Limited mobile support
- State synchronization delays
- Incomplete documentation
- Security vulnerabilities (see TODO.md)

## Contributing

This is experimental code. Feel free to:
- Test and report issues
- Suggest improvements
- Fork and experiment
- Share your findings

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This software is provided "as is", without warranty of any kind. The author is not responsible for any damage or issues that may arise from using this code. Use at your own risk.

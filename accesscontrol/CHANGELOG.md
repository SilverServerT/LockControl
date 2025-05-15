# Changelog

## [1.0.1] - 2024-03-07

### Added
- Consolidated YAML configurations into a single `access_control.yaml`
- Added proper version tracking with `input_text.version`
- Added daily code functionality with `input_text.daily_code`
- Added access mode selection with `input_select.access_mode`
- Added max attempts and lockout duration controls
- Added Home Assistant notification integration
- Added weather forecast integration
- Added brandweer notifications
- Added garbage collection information
- Added sunset-based unlocking feature

### Changed
- Updated entity ID from `switch.tasmota_maglock` to `switch.tasmota`
- Improved MQTT configuration for better reliability
- Enhanced automation rules for better security
- Updated timer functionality with proper state management
- Improved error handling in lock control
- Updated UI to show version status and YAML update requirements

### Fixed
- Fixed 404 errors related to incorrect entity IDs
- Fixed timer state persistence issues
- Fixed notification configuration
- Fixed MQTT topic configuration
- Fixed duplicate YAML configurations

### Security
- Added proper access control settings
- Added daily code reset automation
- Added max attempts tracking
- Added lockout duration configuration
- Added proper MQTT security settings

### Documentation
- Added proper YAML documentation
- Added version tracking
- Added configuration comments
- Added changelog

### Removed
- Removed duplicate `admin-dashboard.yaml`
- Removed redundant configurations
- Removed unused notification settings

### Technical Details
- Updated to use Home Assistant's native notification system
- Improved MQTT QoS and retain settings
- Added proper state class and device class configurations
- Added proper template configurations for weather
- Added proper datetime handling for timers 
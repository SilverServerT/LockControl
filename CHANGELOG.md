# Changelog

All notable changes to the Lock Control Interface will be documented in this file.

## [2.1.0] - 2024-03-20

### Added
- Debug button to clear all states
- Improved state management for magnetic lock
- Enhanced timer handling system

### Fixed
- Lock state persistence issues
- Timer interference with manual lock/unlock
- Countdown timer display issues
- State transitions for magnetic lock (ON = locked, OFF = unlocked)

### Changed
- Separated immediate toggle from timed unlock functionality
- Improved timer state management
- Enhanced error handling for state transitions
- Better UI feedback for lock operations

## [2.0.0] - 2024-03-19

### Added
- Mobile debug panel (🔍 button in bottom right)
  - Detailed logs with timestamps
  - Device information display
  - Config loading attempt tracking
  - Network request monitoring
  - JavaScript error catching
  - Unhandled promise rejection monitoring
- Cache management features
  - "Clear Cache & Reload" button for mobile
  - Automatic cache-busting for config files
  - LocalStorage backup for configuration
- Enhanced mobile support
  - Improved touch handling
  - Better error recovery
  - Mobile-specific optimizations
- Detailed logging system
  - Config loading status
  - Network request details
  - Error tracking
  - Device information

### Fixed
- Config loading issues on mobile devices
- Cache-related problems
- Mobile-specific error handling
- Token status display
- Version checking reliability

### Changed
- Improved error handling system
- Enhanced mobile UI responsiveness
- Better config file path handling
- More robust initialization process

## [1.0.0] - 2024-03-18

### Added
- Initial release
- Basic lock control functionality
- Timer-based unlocking
- Weather and time information
- Brandweer notifications
- Garbage collection schedule
- Version checking 
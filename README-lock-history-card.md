# Lock History Card

A custom card for Home Assistant that displays the history of lock operations.

## Installation

1. Copy the `lock-history-card.js` file to your Home Assistant's `www` directory (e.g., `/config/www/lockcontrol/`).

2. Add the following to your `configuration.yaml`:
```yaml
frontend:
  extra_module_url:
    - /local/lockcontrol/lock-history-card.js
```

3. Restart Home Assistant.

## Usage

Add the card to your dashboard using the UI editor or by adding the following to your dashboard configuration:

```yaml
type: 'custom:lock-history-card'
entity: input_text.lockcontrol_last_opener
title: 'Lock History'  # Optional
max_items: 10         # Optional, defaults to 10
```

### Configuration Options

| Option | Type | Required | Default | Description |
|--------|------|----------|---------|-------------|
| entity | string | Yes | - | The entity ID to track (e.g., `input_text.lockcontrol_last_opener`) |
| title | string | No | 'Lock History' | Custom title for the card |
| max_items | number | No | 10 | Maximum number of history items to display |

## Features

- Displays the last 24 hours of lock operations
- Shows the type of operation and timestamp
- Automatically updates when new operations occur
- Responsive design that matches Home Assistant's theme
- Error handling for missing entities or API issues

## Example

```yaml
type: 'custom:lock-history-card'
entity: input_text.lockcontrol_last_opener
title: 'Door Access History'
max_items: 5
```

## Troubleshooting

If the card doesn't appear:
1. Make sure the JavaScript file is in the correct location
2. Verify that the entity ID is correct
3. Check the browser console for any errors
4. Ensure the frontend configuration is properly set up

## Support

For issues or feature requests, please create an issue in the repository. 
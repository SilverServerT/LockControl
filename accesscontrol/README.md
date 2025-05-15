# Access Control System

## Security Notice

Before committing to GitHub or sharing this code:

1. **NEVER commit sensitive files:**
   - `secrets.yaml`
   - `config.local.js`
   - `config.js`
   - Any files containing tokens or credentials

2. **Use templates:**
   - Copy `secrets.yaml.template` to `secrets.yaml`
   - Fill in your actual credentials in `secrets.yaml`
   - Keep `secrets.yaml` in your local environment only

3. **Token Security:**
   - Generate a long-lived access token in Home Assistant
   - Keep your token secure and never share it
   - Rotate tokens periodically
   - Use the minimum required permissions

4. **MQTT Security:**
   - Use strong passwords
   - Enable TLS/SSL if possible
   - Use unique credentials for each device
   - Keep MQTT credentials secure

5. **File Security:**
   - Check `.gitignore` is properly configured
   - Review all files before committing
   - Remove any hardcoded credentials
   - Use environment variables where possible

## Installation

1. Copy `secrets.yaml.template` to `secrets.yaml`
2. Update `secrets.yaml` with your credentials
3. Install the configuration in Home Assistant
4. Restart Home Assistant

## Configuration

See `access_control.yaml` for configuration options.

## Changelog

See `CHANGELOG.md` for version history. 
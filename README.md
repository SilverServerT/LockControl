# Lock Control Interface

A simple web interface for controlling a lock via Home Assistant.

## Features

- Clean, modern UI with a lock/unlock button
- Real-time status updates
- Visual feedback for actions
- Error handling and user notifications

## Setup

1. Clone this repository
2. Configure your Home Assistant credentials using one of these methods:

   **Method 1 - Using the configuration template:**
   ```bash
   # Copy the template
   cp config.template config.private
   
   # Edit config.private with your credentials
   nano config.private
   
   # Run the update script
   ./update_config.sh config.private
   ```

   **Method 2 - Interactive setup:**
   ```bash
   # Run the update script and follow the prompts
   ./update_config.sh
   ```

3. Open `lockcontrol.html` in a web browser

## Security Notes

### Current Implementation Limitations
The current implementation stores the Home Assistant token in a JavaScript file (`config.local.js`). This is **NOT** a secure method for production use because:
- JavaScript files are accessible to anyone who can access your web server
- Browser developer tools can expose the token
- The token is stored in plain text

### Recommended Security Improvements

1. **Use a Backend Proxy**
   - Create a simple backend service (Node.js, Python, PHP) that acts as a proxy
   - Store the token securely on the server side
   - Have the frontend communicate with your proxy instead of directly with Home Assistant
   - Example structure:
     ```
     Frontend -> Your Backend Proxy -> Home Assistant
     ```

2. **Implement Proper Authentication**
   - Add user authentication to your interface
   - Use session-based authentication
   - Implement rate limiting
   - Consider using OAuth2 if available

3. **Use Environment Variables**
   - Store sensitive data in environment variables
   - Never commit environment files to version control
   - Use a proper secrets management system in production

4. **Enable HTTPS**
   - Always use HTTPS for your Home Assistant instance
   - Use HTTPS for your interface
   - Consider using a reverse proxy with SSL termination

5. **Regular Token Rotation**
   - Regularly rotate your Home Assistant tokens
   - Implement a token rotation schedule
   - Have a process for updating tokens when they change

### For Development/Testing Only
The current implementation is suitable for:
- Local development
- Testing environments
- Personal use in trusted networks
- Learning and experimentation

For any production or public-facing deployment, please implement the security improvements listed above.

## Dependencies

- Home Assistant instance
- Modern web browser with JavaScript enabled

## License

MIT License 
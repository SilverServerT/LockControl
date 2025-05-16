// Home Assistant Configuration
const config = {
    HA_TOKEN: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiMTFjOTAxMzk0ZWI0ZTk4YTdhY2ZiMDNmN2NhNzQyNiIsImlhdCI6MTc0NjY0OTIyNSwiZXhwIjoyMDYyMDA5MjI1fQ.s3ccw_z17XxiJRMEO-29txiVKktbYgFNPL-X-pvl_JI',
    HA_URL: 'https://ha.silverserver.nl',
    DOCKER_PATH: '/var/lib/docker/volumes/hass_config/_data/www/admin-dashboard',
    VERSION: '2.1.0',
    timezone: 'Europe/Amsterdam',
    codeLength: 6,
    maxAttempts: 3,
    lockoutDuration: 300,
    codeExpiry: 86400,
    tasmotaSwitch: 'tasmota.switch',
    simulationMode: true,
    stateEntities: {
        dailyCode: 'input_text.lockcontrol_daily_code',
        dailyCodeExpiry: 'input_datetime.lockcontrol_daily_code_expiry',
        oneTimeCode: 'input_text.lockcontrol_one_time_code',
        oneTimeCodeExpiry: 'input_datetime.lockcontrol_one_time_code_expiry'
    }
};

// Prevent modification of the config object
Object.freeze(config); 
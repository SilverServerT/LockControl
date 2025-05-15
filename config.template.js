// Home Assistant Configuration
const config = {
    HA_TOKEN: 'your-token-here',
    HA_URL: 'http://192.168.1.100:8123',  // Update this with your Home Assistant URL
    DOCKER_PATH: '/var/lib/docker/volumes/hass_config/_data/www/admin-dashboard',
    VERSION: '2.0.0',
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
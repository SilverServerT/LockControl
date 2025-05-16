// Version tracking functionality
class VersionTracker {
    constructor(config) {
        this.config = config;
        this.versionStatus = document.getElementById('versionStatus');
        this.versionInfo = document.getElementById('versionInfo');
        this.versionNumber = document.getElementById('versionNumber');
        
        if (this.versionNumber) {
            this.versionNumber.textContent = `v${config.VERSION}`;
        }

        // Initialize version entities if they don't exist
        this.initializeVersionEntities();
    }

    async initializeVersionEntities() {
        try {
            // Check if version entities exist
            const response = await fetch(`${this.config.HA_URL}/api/states/input_text.version_lockcontrol`, {
                headers: { 'Authorization': `Bearer ${this.config.HA_TOKEN}` }
            });

            if (!response.ok) {
                // Create version entities
                await this.createVersionEntities();
            }
        } catch (error) {
            console.error('Error initializing version entities:', error);
        }
    }

    async createVersionEntities() {
        try {
            // Create version entities
            const entities = {
                'version_lockcontrol': 'Lock Control Version'
            };

            for (const [entityId, name] of Object.entries(entities)) {
                await fetch(`${this.config.HA_URL}/api/services/input_text/set_value`, {
                    method: 'POST',
                    headers: {
                        'Authorization': `Bearer ${this.config.HA_TOKEN}`,
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        entity_id: `input_text.${entityId}`,
                        value: this.config.VERSION
                    })
                });
            }

            // Create automation for version sync check
            await this.createVersionSyncAutomation();
        } catch (error) {
            console.error('Error creating version entities:', error);
        }
    }

    async createVersionSyncAutomation() {
        try {
            const automation = {
                alias: "Check Lock Control Version Sync",
                trigger: [{
                    platform: "time_pattern",
                    minutes: "/5"
                }],
                action: [{
                    service: "persistent_notification.create",
                    data: {
                        title: "Version Sync Check",
                        message: `
                            {% set versions = {
                                'lockcontrol': states('input_text.version_lockcontrol')
                            } %}
                            {% set all_same = versions.values()|unique|length == 1 %}
                            {% if all_same %}
                                All versions are in sync: {{ versions.values()|first }}
                            {% else %}
                                Version mismatch detected:
                                {% for name, version in versions.items() %}
                                    {{ name }}: {{ version }}
                                {% endfor %}
                            {% endif %}
                        `,
                        notification_id: "version_sync_check"
                    }
                }]
            };

            await fetch(`${this.config.HA_URL}/api/services/automation/create`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${this.config.HA_TOKEN}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(automation)
            });
        } catch (error) {
            console.error('Error creating version sync automation:', error);
        }
    }

    async checkVersion() {
        try {
            if (!this.versionStatus || !this.versionInfo) {
                console.warn('Version check elements not found');
                return;
            }

            const response = await fetch(`${window.location.origin}/api/states/sensor.lock_control_version`, {
                headers: { 'Authorization': `Bearer ${this.config.HA_TOKEN}` }
            });
            
            if (!response.ok) {
                this.showVersionMismatch('YAML update required');
                return;
            }
            
            const data = await response.json();
            if (data.state === this.config.VERSION) {
                this.showVersionMatch();
            } else {
                this.showVersionMismatch(`YAML version: ${data.state}`);
            }
        } catch (error) {
            console.error('Error checking YAML version:', error);
            this.showVersionMismatch('Version check failed');
        }
    }

    showVersionMatch() {
        if (this.versionStatus && this.versionInfo) {
            this.versionStatus.style.display = 'none';
            this.versionInfo.style.opacity = '1';
        }
    }

    showVersionMismatch(message) {
        if (this.versionStatus && this.versionInfo) {
            this.versionStatus.style.display = 'inline';
            this.versionStatus.textContent = `(${message})`;
            this.versionInfo.style.opacity = '0.5';
        }
    }

    // Add version info element if it doesn't exist
    static addVersionInfoElement() {
        if (!document.getElementById('versionInfo')) {
            const versionInfo = document.createElement('div');
            versionInfo.id = 'versionInfo';
            versionInfo.className = 'version-info';
            versionInfo.innerHTML = `
                <span class="material-icons">info</span>
                <span id="versionNumber">v2.1.0</span>
                <span id="versionStatus"></span>
            `;
            document.body.appendChild(versionInfo);
        }
    }
}

// Add version tracking styles
const style = document.createElement('style');
style.textContent = `
    .version-info {
        text-align: center;
        margin-top: 10px;
        font-size: 0.8em;
        color: #888;
        opacity: 0.5;
        transition: opacity 0.3s ease;
    }
    .version-info .material-icons {
        font-size: 0.9em;
        vertical-align: middle;
    }
    #versionStatus {
        font-size: 0.9em;
        margin-left: 5px;
        color: #ff9800;
        display: none;
    }
`;
document.head.appendChild(style);

// Add version info element if it doesn't exist
VersionTracker.addVersionInfoElement(); 
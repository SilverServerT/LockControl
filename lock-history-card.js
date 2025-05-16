// Register the card with Home Assistant
window.customCards = window.customCards || [];
window.customCards.push({
    type: 'lock-history-card',
    name: 'Lock History Card',
    description: 'A card to display lock operation history',
    preview: true,
    documentationURL: 'https://github.com/your-repo/lock-history-card'
});

class LockHistoryCard extends HTMLElement {
    static get properties() {
        return {
            hass: {},
            config: {}
        };
    }

    constructor() {
        super();
        this.attachShadow({ mode: 'open' });
    }

    setConfig(config) {
        this.config = config;
        this.render();
    }

    set hass(hass) {
        this._hass = hass;
        this.render();
    }

    async render() {
        if (!this.config || !this.config.entity) {
            this.shadowRoot.innerHTML = `
                <ha-card>
                    <div class="error">Entity not configured</div>
                </ha-card>
            `;
            return;
        }

        const entity = this.config.entity;
        const title = this.config.title || 'Lock History';
        const maxItems = this.config.max_items || 10;

        // Get history
        const now = new Date();
        const startTime = new Date(now.getTime() - (24 * 60 * 60 * 1000));
        
        try {
            const response = await fetch(`/api/history/period/${startTime.toISOString()}?filter_entity_id=${entity}`);
            const data = await response.json();
            const history = data[0] || [];
            const lastEntries = history.slice(-maxItems).reverse();

            this.shadowRoot.innerHTML = `
                <style>
                    ha-card {
                        padding: 16px;
                    }
                    .header {
                        display: flex;
                        align-items: center;
                        margin-bottom: 16px;
                    }
                    .header ha-icon {
                        margin-right: 8px;
                        color: var(--primary-color);
                    }
                    .header .title {
                        font-size: 1.2em;
                        font-weight: 500;
                    }
                    .history-item {
                        display: flex;
                        align-items: flex-start;
                        padding: 8px 0;
                        border-bottom: 1px solid var(--divider-color);
                    }
                    .history-item:last-child {
                        border-bottom: none;
                    }
                    .history-item ha-icon {
                        margin-right: 8px;
                        color: var(--primary-color);
                    }
                    .history-content {
                        flex: 1;
                    }
                    .history-time {
                        font-size: 0.8em;
                        color: var(--secondary-text-color);
                    }
                    .history-method {
                        font-size: 0.9em;
                        color: var(--primary-text-color);
                        margin-top: 4px;
                    }
                    .empty {
                        text-align: center;
                        color: var(--secondary-text-color);
                        padding: 16px;
                    }
                    .error {
                        color: var(--error-color);
                        padding: 16px;
                        text-align: center;
                    }
                    .locked {
                        color: var(--error-color);
                    }
                    .unlocked {
                        color: var(--success-color);
                    }
                </style>
                <ha-card>
                    <div class="header">
                        <ha-icon icon="mdi:history"></ha-icon>
                        <span class="title">${title}</span>
                    </div>
                    ${lastEntries.length > 0 ? lastEntries.map(entry => {
                        const isLocked = entry.state === 'on';
                        const icon = isLocked ? 'mdi:lock' : 'mdi:lock-open';
                        const method = entry.attributes?.method || 'Unknown';
                        return `
                            <div class="history-item">
                                <ha-icon icon="${icon}" class="${isLocked ? 'locked' : 'unlocked'}"></ha-icon>
                                <div class="history-content">
                                    <div>${isLocked ? 'Locked' : 'Unlocked'}</div>
                                    <div class="history-method">${method}</div>
                                    <div class="history-time">${new Date(entry.last_changed).toLocaleString()}</div>
                                </div>
                            </div>
                        `;
                    }).join('') : `
                        <div class="empty">No history available</div>
                    `}
                </ha-card>
            `;
        } catch (error) {
            this.shadowRoot.innerHTML = `
                <ha-card>
                    <div class="error">Error loading history</div>
                </ha-card>
            `;
        }
    }

    getCardSize() {
        return 3;
    }
}

customElements.define('lock-history-card', LockHistoryCard); 
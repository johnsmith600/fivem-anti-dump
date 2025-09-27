# FiveM Anti-Dump Detection System v2.0.0

A comprehensive anti-cheat and server protection system designed specifically for FiveM servers to detect and prevent server dumping, cheating, and malicious activities.

## 🚀 Features

### Core Detection Engine
- **Real-time Process Monitoring**: Detects suspicious processes and behaviors
- **Network Traffic Analysis**: Monitors network connections and identifies anomalies
- **Memory Scanning**: Advanced memory pattern detection and protection
- **Behavioral Analysis**: AI-powered detection of suspicious player behavior
- **Signature-based Detection**: Comprehensive database of known cheat signatures

### Prevention System
- **Anti-Debug Protection**: Prevents reverse engineering and debugging attempts
- **Hook Prevention**: Detects and prevents API hooking and function interception
- **Memory Protection**: Advanced memory allocation and code injection prevention
- **Network Protection**: Blocks suspicious network ports and connections
- **Process Management**: Automatic termination of malicious processes

### Notification System
- **Player Notifications**: Real-time warnings and alerts for players
- **Admin Alerts**: Comprehensive notification system for server administrators
- **Discord Integration**: Webhook notifications for major security events
- **Logging System**: Detailed logging with rotation and multiple output formats

### Advanced Features
- **Framework Integration**: Support for ESX, QBCore, vRP, and standalone servers
- **Database Support**: MySQL/MariaDB integration for persistent data storage
- **Performance Monitoring**: Real-time system performance and resource tracking
- **Export System**: Complete API for integration with other resources
- **Configuration Hot-reload**: Runtime configuration updates without restart

## 📋 Requirements

- FiveM Server (build 2683 or higher)
- MySQL Database (optional, for enhanced features)
- Basic knowledge of FiveM server administration

## ⚡ Installation

### Step 1: Download and Setup
1. Download the latest release from the repository
2. Extract the `antidump` folder to your server's `resources` directory
3. Ensure the resource folder structure is correct:
```
resources/
└── antidump/
    ├── fxmanifest.lua
    ├── server/
    ├── client/
    ├── database/
    └── docs/
```

### Step 2: Database Setup (Optional)
1. Create a new MySQL database for the anti-dump system
2. Import the database schema:
```sql
mysql -u username -p database_name < database/install.sql
```
3. Update database configuration in `server/config.lua`

### Step 3: Configuration
1. Open `server/config.lua`
2. Configure basic settings:
```lua
Config.DebugMode = false  -- Set to false for production
Config.Database.Enabled = true  -- Enable if using database
Config.Notifications.Discord.Enabled = true  -- Enable Discord webhooks
```
3. Configure framework integration:
```lua
Config.Framework.AutoDetect = true  -- Auto-detect framework
Config.Framework.PreferredFramework = "esx"  -- or "qbcore", "vrp", "standalone"
```

### Step 4: Server Configuration
Add the resource to your `server.cfg`:
```
ensure antidump  # Load early in startup sequence
```

## 🔧 Configuration

### Basic Configuration
```lua
Config = {
    DebugMode = false,
    Environment = "production",
    AutoReload = true
}
```

### Detection Configuration
```lua
Config.Detection = {
    Enabled = true,
    ScanInterval = 5000,  -- 5 second intervals
    Sensitivity = "Medium",  -- Low, Medium, High, Ultra
    EnableProcessMonitor = true,
    EnableNetworkMonitor = true,
    EnableMemoryScanner = true
}
```

### Framework Integration
```lua
Config.Framework = {
    AutoDetect = true,
    ESX = { Enabled = true },  -- Enable for ESX servers
    QBCore = { Enabled = true },  -- Enable for QBCore servers
    Standalone = { Enabled = true }  -- Enable for standalone servers
}
```

### Database Configuration
```lua
Config.Database = {
    Enabled = true,
    Type = "mysql",
    Host = "localhost",
    Port = 3306,
    Database = "fivem_antidump",
    Username = "root",
    Password = "your_password"
}
```

### Discord Webhooks
```lua
Config.Notifications.Discord = {
    Enabled = true,
    WebhookURL = "https://discord.com/api/webhooks/...",
    CriticalDetectionsURL = "https://discord.com/api/webhooks/..."
}
```

## 📊 Usage

### Console Commands
The system provides comprehensive console commands for administration:

```bash
# System Status
antidump status          # Show detailed system status
antidump health          # Show system health and module status

# Detection Management
antidump scan            # Trigger manual detection scan
antidump stats           # Show detection statistics
antidump history [limit] # Show detection history

# System Management
antidump modules         # Show active modules
antidump performance     # Show performance metrics
antidump database        # Show database status
antidump restart         # Restart the system

# Testing and Debugging
antidump test notification  # Send test notification
antidump test detection    # Log test detection event
antidump test database     # Test database logging

# Help
antidump help            # Show all available commands
```

### Export Functions
The system provides exports for integration with other resources:

```lua
-- System Information
exports.AntiDump:GetSystemStatus()
exports.AntiDump:GetSystemHealth()
exports.AntiDump:GetSystemVersion()

-- Detection Management
exports.AntiDump:TriggerManualScan()
exports.AntiDump:GetDetectionStats()
exports.AntiDump:GetDetectionHistory(limit)

-- Module Information
exports.AntiDump:GetActiveModules()
exports.AntiDump:GetModuleStatus(moduleName)

-- Notifications
exports.AntiDump:SendPlayerNotification(playerId, type, message, severity)
exports.AntiDump:SendAdminNotification(playerId, threatInfo, severity)
exports.AntiDump:SendDiscordNotification(webhookType, data)
```

### API Integration
```lua
-- Check system status
local status = exports.AntiDump:GetSystemStatus()
if status.initialized then
    print("Anti-Dump system is running")
end

-- Trigger manual scan
local results = exports.AntiDump:TriggerManualScan()
if results then
    print("Scan completed: " .. results.detectionCount .. " detections")
end

-- Send custom notification
exports.AntiDump:SendPlayerNotification(
    playerId,
    "warning",
    "Custom security message",
    "MEDIUM"
)
```

## 🛠️ Framework Integration

### ESX Integration
The system automatically integrates with ESX servers:
- Player data synchronization
- Economy integration
- Permission system integration
- Enhanced logging with ESX identifiers

### QBCore Integration
Full QBCore support:
- Player management integration
- Job system compatibility
- Inventory system integration
- QBCore permission integration

### vRP Integration
vRP framework support:
- vRP player identification
- Permission system integration
- Economy and inventory integration

### Standalone Mode
For servers without frameworks:
- Native FiveM player identification
- Basic permission system
- Standalone configuration options

## 📈 Performance

### Performance Monitoring
The system includes comprehensive performance monitoring:
- Real-time CPU and memory usage tracking
- Detection scan performance metrics
- Database query performance analysis
- Network latency monitoring

### Optimization Features
- Adaptive scanning intervals based on system load
- Memory usage limits and garbage collection
- Configurable thread management
- Performance-based detection scaling

### Performance Commands
```bash
antidump performance     # Show current performance metrics
antidump health         # Show system health status
```

## 🔒 Security

### Built-in Security Features
- **Anti-Tampering**: Protection against configuration modification
- **Access Control**: IP whitelisting and API token authentication
- **Audit Logging**: Comprehensive audit trail of all system activities
- **Rate Limiting**: Protection against abuse and spam

### Security Configuration
```lua
Config.Security = {
    EncryptSensitiveData = true,
    AccessControl = {
        EnableIPWhitelist = true,
        AllowedIPs = {"127.0.0.1", "your.ip.address"},
        RequireAuthentication = true
    }
}
```

## 🚨 Troubleshooting

### Common Issues

**System not initializing:**
- Check server console for error messages
- Verify all required modules are present
- Check database connectivity if enabled
- Review configuration for syntax errors

**Detection not working:**
- Verify detection modules are enabled in config
- Check scan intervals are not set too high
- Review whitelist for false positives
- Check system resource usage

**Notifications not sending:**
- Verify Discord webhook URLs are correct
- Check notification module status
- Review notification configuration
- Test with `antidump test notification`

**Database connection issues:**
- Verify database credentials in config
- Check database server is running
- Ensure database schema is imported
- Test with `antidump test database`

### Debug Mode
Enable debug mode for detailed logging:
```lua
Config.DebugMode = true
Config.Logging.LogLevel = "DEBUG"
```

### Log Files
Log files are located in `resources/antidump/logs/`:
- `antidump.log` - Main system log
- Rotated logs with timestamps
- Configurable log levels and rotation

## 📝 Changelog

### Version 2.0.0
- Complete system rewrite with modular architecture
- Enhanced detection engine with behavioral analysis
- Comprehensive framework integration
- Advanced database support with stored procedures
- Improved performance monitoring and optimization
- Enhanced security and anti-tampering measures
- Discord webhook integration
- Export system for third-party integration

### Version 1.5.0
- Added memory scanning capabilities
- Improved process monitoring
- Enhanced notification system
- Database integration improvements

### Version 1.0.0
- Initial release
- Basic process monitoring
- Simple notification system
- Core detection functionality

## 🤝 Contributing

We welcome contributions to the Anti-Dump system:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Setup
```bash
git clone https://github.com/antidump/fivem-antidump.git
cd fivem-antidump
# Configure for development
cp server/config.lua server/config.development.lua
# Edit configuration for development environment
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- FiveM Development Team for the excellent platform
- Community contributors and testers
- Framework developers (ESX, QBCore, vRP)
- Security researchers and anti-cheat developers

## 🆘 Support

### Getting Help
- Check the troubleshooting section above
- Review the configuration examples
- Enable debug mode for detailed logging
- Check the GitHub repository for known issues

### Reporting Issues
When reporting issues, please include:
- System version and FiveM build number
- Complete server configuration (without sensitive data)
- Server console logs
- Steps to reproduce the issue
- Expected vs actual behavior

### Feature Requests
Feature requests are welcome! Please:
- Describe the feature and its use case
- Explain why it would benefit the community
- Provide implementation suggestions if possible
- Consider contributing the feature yourself

---

**⚠️ Disclaimer**: This system is designed to enhance server security but should not be considered foolproof. Always maintain regular backups and monitor your server logs. No anti-cheat system can provide 100% protection against determined attackers.

For the latest updates and information, visit the [GitHub repository](https://github.com/antidump/fivem-antidump).
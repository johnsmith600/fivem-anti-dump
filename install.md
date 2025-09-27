# FiveM Anti-Dump System - Installation Guide

## 🚀 Quick Start

Get the FiveM Anti-Dump system up and running in 3 simple steps:

1. **Download & Setup**
   ```bash
   # Copy the antidump resource to your server's resources directory
   # Ensure proper folder structure:
   # resources/antidump/
   # ├── fxmanifest.lua
   # ├── server/
   # ├── client/
   # ├── database/
   # └── docs/
   ```

2. **Configure**
   ```lua
   -- In server/config.lua, set basic configuration:
   Config.DebugMode = false
   Config.Database.Enabled = true  -- Optional
   Config.Notifications.Discord.Enabled = true  -- Optional
   ```

3. **Start Server**
   ```cfg
   # Add to server.cfg:
   ensure antidump
   ```

That's it! The system will start automatically and begin monitoring for suspicious activities.

## 📋 Prerequisites

### Server Requirements
- **FiveM Server**: Build 2683 or higher (recommended: latest stable)
- **Operating System**: Windows/Linux (64-bit recommended)
- **Memory**: Minimum 2GB RAM (4GB+ recommended for production)
- **Storage**: 500MB free space for logs and database
- **Network**: Stable internet connection for updates and Discord webhooks

### Optional Dependencies
- **MySQL Database**: Version 5.7+ (recommended for production)
  - MySQL Community Server
  - MariaDB (compatible alternative)
- **Web Server**: For Discord webhooks (optional)

### Framework Support
- **ESX**: Version 1.10.0+ (Legacy and Extended modes supported)
- **QBCore**: Version 1.0.0+ (Modern QBCore supported)
- **vRP**: Version 1.0.0+ (vRP 2.0+ recommended)
- **Standalone**: Native FiveM servers supported

## 📦 Installation

### Step 1: Resource Setup
1. **Download** the latest release from the [GitHub repository](https://github.com/antidump/fivem-antidump)
2. **Extract** the `antidump` folder to your FiveM server's `resources` directory
3. **Verify** the folder structure:
   ```
   resources/
   └── antidump/
       ├── fxmanifest.lua          # Main resource manifest
       ├── client/
       │   └── antidump_client.lua # Client-side scripts
       ├── server/
       │   ├── config.lua          # Main configuration
       │   ├── antidump.lua        # Main server script
       │   └── [modules...]        # Detection & prevention modules
       ├── database/
       │   └── install.sql         # Database schema
       ├── docs/
       │   ├── README.md           # Basic documentation
       │   └── ARCHITECTURE.md     # Technical documentation
       └── examples/               # Configuration examples
   ```

### Step 2: Server Configuration
Add the resource to your `server.cfg` file:

```cfg
# FiveM Server Configuration
# Place this line early in your startup sequence
ensure antidump

# Optional: Set server convars for the anti-dump system
set antidump_debug false
set antidump_database true
set antidump_discord true
set antidump_autostart true
```

**Important**: Load order matters! Place `ensure antidump` before other resources that might conflict with detection systems.

### Step 3: Initial Configuration
Open `server/config.lua` and configure basic settings:

```lua
Config = {
    -- Basic Settings
    Environment = "production",     -- development, staging, production
    DebugMode = false,             -- Set to false for production
    AutoReload = true,             -- Enable hot configuration reload

    -- Database (Optional)
    Database = {
        Enabled = false,           -- Enable for persistent storage
        Type = "mysql",            -- mysql, sqlite, postgresql
        Host = "localhost",
        Database = "fivem_antidump"
    },

    -- Framework Auto-Detection
    Framework = {
        AutoDetect = true,          -- Let system detect your framework
        PreferredFramework = "auto" -- auto, esx, qbcore, vrp, standalone
    }
}
```

### Step 4: Framework-Specific Setup
The system will automatically detect your framework, but you can manually configure:

#### ESX Servers
```lua
Config.Framework = {
    AutoDetect = false,
    PreferredFramework = "esx",
    ESX = {
        Enabled = true,
        ExportName = "esx",
        UseLegacy = false
    }
}
```

#### QBCore Servers
```lua
Config.Framework = {
    AutoDetect = false,
    PreferredFramework = "qbcore",
    QBCore = {
        Enabled = true,
        ExportName = "qb-core"
    }
}
```

#### vRP Servers
```lua
Config.Framework = {
    AutoDetect = false,
    PreferredFramework = "vrp",
    vRP = {
        Enabled = true,
        ExportName = "vrp"
    }
}
```

### Step 5: Start the Server
1. **Start/Restart** your FiveM server
2. **Check console** for initialization messages:
   ```
   [Anti-Dump] Enhanced Configuration v2.0.0 loaded
   [Anti-Dump] Environment: production
   [Anti-Dump] Anti-Dump system starting...
   [Anti-Dump] System initialized successfully
   ```
3. **Verify** the system is running with: `antidump status`

## ⚙️ Configuration

### Detection Configuration
Configure detection sensitivity and scan intervals:

```lua
Config.Detection = {
    Enabled = true,
    ScanInterval = 5000,           -- Milliseconds between scans
    Sensitivity = "Medium",        -- Low, Medium, High, Ultra
    MaxConcurrentScans = 3,        -- Maximum simultaneous scans

    -- Enable detection modules
    Modules = {
        ProcessMonitor = true,
        NetworkMonitor = true,
        MemoryScanner = true,
        SignatureScanner = true,
        BehavioralAnalyzer = true,
        HeuristicEngine = true
    }
}
```

### Prevention Configuration
Configure automatic responses to detections:

```lua
Config.Prevention = {
    Enabled = true,
    AutoTerminateProcesses = true,
    BlockNetworkPorts = true,
    MemoryProtection = true,

    -- Response timing
    ResponseDelay = 1000,          -- ms before taking action
    EscalationDelay = 5000,        -- ms before escalating
    CooldownPeriod = 30000,        -- ms between repeated actions
}
```

### Whitelist Configuration
Add trusted processes and network connections:

```lua
Config.Whitelist = {
    Processes = {
        "explorer.exe",
        "taskmgr.exe",
        "steam.exe",
        "fiveM.exe",
        "fiveM_b2802.exe"
    },

    NetworkConnections = {
        "127.0.0.0/8",    -- Localhost
        "10.0.0.0/8"      -- Private networks
    }
}
```

### Advanced Configuration Options

#### Performance Settings
```lua
Config.Performance = {
    MaxProcessesToScan = 500,
    MaxNetworkConnectionsToAnalyze = 1000,
    ProcessTimeout = 5000,
    NetworkTimeout = 3000,

    Memory = {
        MaxMemoryUsage = 512,      -- MB
        GCInterval = 300000        -- 5 minutes
    }
}
```

#### Security Settings
```lua
Config.Security = {
    EncryptSensitiveData = false,
    AccessControl = {
        EnableIPWhitelist = false,
        AllowedIPs = {"127.0.0.1"},
        RequireAuthentication = false
    }
}
```

## 🗄️ Database Setup

### MySQL/MariaDB Setup (Recommended)

1. **Create Database**
   ```sql
   CREATE DATABASE fivem_antidump;
   ```

2. **Import Schema**
   ```bash
   mysql -u root -p fivem_antidump < database/install.sql
   ```

3. **Configure Connection**
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

### Database Tables Created
The installation script creates the following tables:
- `antidump_detections` - Detection events and history
- `antidump_processes` - Process monitoring data
- `antidump_network_activity` - Network connection logs
- `antidump_players` - Player information and statistics
- `antidump_incidents` - Major security incidents
- `antidump_statistics` - System performance metrics

### SQLite Setup (Development)
```lua
Config.Database = {
    Enabled = true,
    Type = "sqlite",
    Database = "antidump.db"  -- File will be created automatically
}
```

## 🔗 Framework Integration

### ESX Integration
The system provides deep ESX integration:

```lua
Config.Framework.ESX = {
    Enabled = true,
    ExportName = "esx",
    UseLegacy = false,

    -- Economy monitoring
    Economy = {
        EnableMoneyCheck = true,
        SuspiciousTransactionThreshold = 1000000
    },

    -- Job-based risk assessment
    JobIntegration = {
        Enabled = true,
        WhitelistJobs = {"police", "ambulance"},
        JobRiskModifier = {
            police = 0.5,    -- Lower risk for police
            ambulance = 0.7  -- Lower risk for ambulance
        }
    }
}
```

### QBCore Integration
Full QBCore compatibility:

```lua
Config.Framework.QBCore = {
    Enabled = true,
    ExportName = "qb-core",

    -- QBCore-specific features
    Advanced = {
        EnablePlayerValidation = true,
        EnableDetailedLogging = true
    }
}
```

### vRP Integration
vRP framework support:

```lua
Config.Framework.vRP = {
    Enabled = true,
    ExportName = "vrp",

    -- vRP-specific settings
    Advanced = {
        EnablePlayerValidation = true,
        EnableEconomyIntegration = true
    }
}
```

### Standalone Mode
For servers without frameworks:

```lua
Config.Framework = {
    AutoDetect = false,
    PreferredFramework = "standalone",
    Standalone = {
        Enabled = true,
        PlayerIdentifier = "license",  -- license, steam, discord
        AdminPermission = "admin"
    }
}
```

## 📢 Discord Integration

### Webhook Setup
1. **Create Discord Webhook**:
   - Go to Server Settings → Integrations → Webhooks
   - Create new webhook for your security channel
   - Copy the webhook URL

2. **Configure Webhooks**
   ```lua
   Config.Notifications.Discord = {
       Enabled = true,
       WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_TOKEN",
       CriticalDetectionsURL = "https://discord.com/api/webhooks/YOUR_CRITICAL_WEBHOOK_ID/YOUR_TOKEN",
       Username = "Anti-Dump System",
       AvatarURL = "https://example.com/avatar.png",

       -- Rate limiting
       RateLimitPerMinute = 10,
       Timeout = 5000,

       -- Features
       EnableEmbeds = true,
       EnableMentions = false
   }
   ```

### Webhook Types
- **Critical Detections**: Immediate alerts for high-severity threats
- **High Severity**: Important security events
- **Regular Notifications**: General system notifications
- **Player Warnings**: Individual player alerts

### Testing Discord Integration
```bash
antidump test discord
```

## ✅ Testing & Verification

### System Status Check
```bash
# Check if system is running
antidump status

# Expected output:
# [Anti-Dump] System Status: RUNNING
# [Anti-Dump] Version: 2.0.0
# [Anti-Dump] Uptime: 0d 0h 5m 23s
# [Anti-Dump] Modules Active: 8/8
```

### Module Status Verification
```bash
# Check active modules
antidump modules

# Expected output:
# [Anti-Dump] Active Modules:
# [Anti-Dump] ✓ Process Monitor: RUNNING
# [Anti-Dump] ✓ Network Monitor: RUNNING
# [Anti-Dump] ✓ Memory Scanner: RUNNING
# [Anti-Dump] ✓ Signature Scanner: RUNNING
# [Anti-Dump] ✓ Behavioral Analyzer: RUNNING
# [Anti-Dump] ✓ Heuristic Engine: RUNNING
```

### Detection Testing
```bash
# Trigger test detection
antidump test detection

# Check detection history
antidump history 10
```

### Database Testing
```bash
# Test database connectivity
antidump test database

# Expected output:
# [Anti-Dump] Database connection: SUCCESS
# [Anti-Dump] Tables verified: 6/6
# [Anti-Dump] Test data inserted successfully
```

### Performance Testing
```bash
# Check system performance
antidump performance

# Expected output:
# [Anti-Dump] Performance Metrics:
# [Anti-Dump] CPU Usage: 15.2%
# [Anti-Dump] Memory Usage: 89.3MB / 512MB
# [Anti-Dump] Active Scans: 2/3
# [Anti-Dump] Avg Scan Time: 245ms
```

## 🖥️ Console Commands

### System Management
```bash
antidump status              # Show detailed system status
antidump health              # Show system health and module status
antidump restart             # Restart the anti-dump system
antidump shutdown            # Gracefully shutdown the system
```

### Detection Management
```bash
antidump scan                # Trigger manual detection scan
antidump stats               # Show detection statistics
antidump history [limit]     # Show detection history (default: 50)
antidump modules             # Show active modules status
```

### Performance Monitoring
```bash
antidump performance         # Show performance metrics
antidump memory              # Show memory usage details
antidump threads             # Show thread information
```

### Testing Commands
```bash
antidump test detection      # Log test detection event
antidump test notification   # Send test player notification
antidump test discord        # Send test Discord notification
antidump test database       # Test database operations
antidump test performance    # Test performance monitoring
```

### Configuration
```bash
antidump config reload       # Reload configuration from disk
antidump config validate     # Validate current configuration
antidump config export       # Export current configuration
```

### Help and Information
```bash
antidump help                # Show all available commands
antidump version             # Show system version information
antidump about               # Show system information
```

## 🔌 Export Functions

### System Information
```lua
-- Get system status
local status = exports.AntiDump:GetSystemStatus()
-- Returns: {initialized, version, uptime, active_modules}

-- Get system health
local health = exports.AntiDump:GetSystemHealth()
-- Returns: {cpu, memory, disk, database, performance_score}

-- Get system version
local version = exports.AntiDump:GetSystemVersion()
-- Returns: "2.0.0"
```

### Detection Management
```lua
-- Trigger manual scan
local results = exports.AntiDump:TriggerManualScan()
-- Returns: {detection_count, scan_duration, modules_used}

-- Get detection statistics
local stats = exports.AntiDump:GetDetectionStats()
-- Returns: {total_detections, today_detections, avg_risk_score}

-- Get detection history
local history = exports.AntiDump:GetDetectionHistory(limit)
-- Returns: array of detection events
```

### Module Information
```lua
-- Get active modules
local modules = exports.AntiDump:GetActiveModules()
-- Returns: {ProcessMonitor, NetworkMonitor, ...}

-- Get specific module status
local status = exports.AntiDump:GetModuleStatus("ProcessMonitor")
-- Returns: {enabled, running, last_scan, detection_count}
```

### Notification System
```lua
-- Send player notification
exports.AntiDump:SendPlayerNotification(
    playerId,           -- Target player ID
    "warning",          -- Notification type
    "Custom message",   -- Message content
    "MEDIUM"            -- Severity level
)

-- Send admin notification
exports.AntiDump:SendAdminNotification(
    playerId,           -- Related player ID
    threatInfo,         -- Threat information
    "HIGH"              -- Severity level
)

-- Send Discord notification
exports.AntiDump:SendDiscordNotification(
    "critical",         -- Webhook type
    notificationData    -- Notification data
)
```

### Database Operations
```lua
-- Check database connection
local connected = exports.AntiDump:IsDatabaseConnected()
-- Returns: boolean

-- Get database statistics
local stats = exports.AntiDump:GetDatabaseStats()
-- Returns: {tables, size_mb, connection_count}
```

### Framework Integration
```lua
-- Get current framework
local framework = exports.AntiDump:GetCurrentFramework()
-- Returns: "esx", "qbcore", "vrp", or "standalone"

-- Get framework players
local players = exports.AntiDump:GetFrameworkPlayers()
-- Returns: array of player objects
```

## ⚡ Performance Tuning

### Memory Optimization
```lua
Config.Performance.Memory = {
    EnableGarbageCollection = true,
    GCInterval = 300000,           -- 5 minutes
    MaxMemoryUsage = 512,          -- MB
    EnableMemoryOptimization = true,
    MemoryOptimizationInterval = 600000  -- 10 minutes
}
```

### Scan Optimization
```lua
Config.Detection.Performance = {
    EnableAdaptiveScanning = true,
    AdaptiveScanReduction = 0.5,   -- Reduce frequency under load
    MaxCPUTimePerScan = 100,       -- ms per scan
    MemoryLimitPerScan = 50        -- MB per scan
}
```

### Thread Management
```lua
Config.Performance.Threads = {
    MinWorkerThreads = 2,
    MaxWorkerThreads = 8,
    QueueSize = 1000,
    ThreadTimeout = 30000          -- ms
}
```

### Adaptive Settings
```lua
Config.Performance.Advanced = {
    EnablePerformanceMonitoring = true,
    MonitorInterval = 60000,       -- 1 minute
    AdaptiveLimits = true,
    ResourceThresholds = {
        CPUUsage = 70,             -- % max CPU
        MemoryUsage = 80,          -- % max memory
        DiskUsage = 85             -- % max disk
    }
}
```

### Production Optimizations
For high-traffic servers:

```lua
Config.Detection = {
    ScanInterval = 10000,          -- Longer intervals
    MaxConcurrentScans = 2,        -- Fewer concurrent scans
    Sensitivity = "High"           -- Higher accuracy threshold
}

Config.Performance = {
    MaxProcessesToScan = 300,      -- Lower process limit
    MaxNetworkConnectionsToAnalyze = 500,
    Advanced = {
        AutoScaleDetection = true,
        MinScanInterval = 5000,    -- Minimum 5 seconds
        MaxScanInterval = 30000    -- Maximum 30 seconds
    }
}
```

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### System Not Initializing
**Symptoms**: System fails to start, no console messages
**Solutions**:
1. Check file permissions in the antidump resource folder
2. Verify all required files are present
3. Check server.cfg for syntax errors
4. Ensure FiveM build is 2683+

**Debug Commands**:
```bash
antidump test init
# Check console for detailed error messages
```

#### Detection Not Working
**Symptoms**: No detections logged, scans appear inactive
**Solutions**:
1. Verify detection modules are enabled in config
2. Check scan intervals are reasonable
3. Review whitelist for false positives
4. Check system resource usage

**Debug Commands**:
```bash
antidump modules      # Check module status
antidump performance  # Check resource usage
antidump scan         # Trigger manual scan
```

#### Database Connection Issues
**Symptoms**: Database-related errors, failed logging
**Solutions**:
1. Verify database credentials in config
2. Check database server is running
3. Ensure database schema is imported
4. Test network connectivity

**Debug Commands**:
```bash
antidump test database
# Expected: "Database connection: SUCCESS"
```

#### Discord Notifications Not Sending
**Symptoms**: Discord messages not appearing
**Solutions**:
1. Verify webhook URLs are correct
2. Check Discord server permissions
3. Test webhook with `antidump test discord`
4. Check rate limiting settings

**Debug Commands**:
```bash
antidump test discord
# Should send test message to Discord
```

#### Performance Issues
**Symptoms**: High CPU/memory usage, slow scans
**Solutions**:
1. Reduce scan frequency
2. Limit concurrent scans
3. Enable adaptive scanning
4. Check for memory leaks

**Optimization Commands**:
```bash
antidump performance
antidump config reload  # Apply performance settings
```

### Log Files
Log files are located in `resources/antidump/antidump.log`:
- Check log levels and rotation settings
- Enable DEBUG mode for detailed troubleshooting
- Monitor log file sizes and disk space

### Debug Mode
Enable detailed logging:
```lua
Config.DebugMode = true
Config.Logging.LogLevel = "DEBUG"
Config.Notifications.Logging.LogLevel = "DEBUG"
```

## 🆘 Support

### Getting Help
1. **Check Documentation**: Review this installation guide thoroughly
2. **Enable Debug Mode**: Set `Config.DebugMode = true` for detailed logs
3. **Review Logs**: Check the `antidump.log` file for error messages
4. **Test Components**: Use the test commands to isolate issues

### Reporting Issues
When reporting problems, please include:

- **System Information**:
  - FiveM build number
  - Anti-Dump system version
  - Server operating system

- **Configuration**:
  - Your `server.cfg` entries
  - Relevant parts of `config.lua` (remove sensitive data)
  - Framework type and version

- **Error Details**:
  - Complete error messages from console/logs
  - Steps to reproduce the issue
  - Expected vs actual behavior

- **Debug Information**:
  ```bash
  antidump status
  antidump health
  antidump performance
  ```

### Feature Requests
We welcome feature requests! Please:
- Describe the feature and its use case
- Explain why it would benefit the community
- Provide implementation suggestions if possible
- Consider the security implications

### Community Support
- **GitHub Repository**: [https://github.com/antidump/fivem-antidump](https://github.com/antidump/fivem-antidump)
- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: Use GitHub discussions for questions and help

---

**⚠️ Important Notes**:
- This system enhances server security but is not foolproof
- Always maintain regular backups of your server
- Monitor system performance, especially on high-traffic servers
- Keep the system updated for the latest security improvements
- Review logs regularly for suspicious activities

For updates and the latest information, visit the [GitHub repository](https://github.com/antidump/fivem-antidump).
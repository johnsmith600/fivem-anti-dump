
-- FiveM Anti-Dump Configuration
-- Enhanced configuration management system for anti-dump detection
-- Version: 2.0.0

Config = {}

-- System Information
Config.Version = "2.0.0"
Config.Author = "Anti-Dump System"
Config.Description = "Enhanced FiveM Anti-Server Dump Protection"

-- Environment configuration
Config.Environment = "production" -- development, staging, production
Config.AutoReload = true -- Enable hot configuration reload

-- Debug configuration
Config.DebugMode = false -- Set to true for development/testing
Config.DebugLevel = "INFO" -- TRACE, DEBUG, INFO, WARN, ERROR

-- Enhanced Detection engine settings
Config.Detection = {
    Enabled = true,
    ScanInterval = 5000, -- Milliseconds between full scans
    ProcessScanInterval = 3000, -- Process-specific scan interval
    NetworkScanInterval = 10000, -- Network scan interval
    MemoryScanInterval = 15000, -- Memory scan interval
    MaxConcurrentScans = 3, -- Maximum concurrent scan operations

    -- Advanced detection settings
    EnableProcessMonitor = true,
    EnableNetworkMonitor = true,
    EnableMemoryScanner = true,
    EnableSignatureScanning = true,
    EnableBehavioralAnalysis = true,
    EnableHeuristicDetection = true,

    -- Detection sensitivity levels
    SensitivityLevels = {
        Low = 30,
        Medium = 60,
        High = 90,
        Ultra = 95
    },

    -- Current sensitivity setting
    Sensitivity = "Medium", -- Low, Medium, High, Ultra

    -- Detection thresholds
    Thresholds = {
        CriticalRiskScore = 90,
        HighRiskScore = 70,
        MediumRiskScore = 50,
        LowRiskScore = 25
    },

    -- Advanced thresholds
    AdvancedThresholds = {
        ProcessCountThreshold = 100,
        MemoryUsageThreshold = 500, -- MB
        NetworkConnectionThreshold = 50,
        SuspiciousProcessThreshold = 10,
        AnomalyDetectionThreshold = 75
    },

    -- Module toggles
    Modules = {
        ProcessMonitor = true,
        NetworkMonitor = true,
        MemoryScanner = true,
        SignatureScanner = true,
        BehavioralAnalyzer = true,
        HeuristicEngine = true
    },

    -- Performance tuning
    Performance = {
        EnableAdaptiveScanning = true,
        AdaptiveScanReduction = 0.5, -- Reduce scan frequency by 50% under load
        MaxCPUTimePerScan = 100, -- Maximum CPU time per scan in milliseconds
        MemoryLimitPerScan = 50 -- Maximum memory usage per scan in MB
    }
}

-- Enhanced Prevention system configuration
Config.Prevention = {
    -- Core prevention settings
    Enabled = true,
    AutoTerminateProcesses = true,
    BlockNetworkPorts = true,
    MemoryProtection = true,
    AntiDebugging = true,
    HookPrevention = true,

    -- Response timing
    ResponseDelay = 1000, -- milliseconds before taking action
    EscalationDelay = 5000, -- milliseconds before escalating response
    CooldownPeriod = 30000, -- milliseconds between repeated actions

    -- Process management
    ProcessManagement = {
        ForceTerminate = true,
        KillProcessTree = false, -- Kill parent and child processes
        TerminationTimeout = 5000, -- milliseconds to wait for graceful termination
        MaxRetries = 3 -- Maximum termination attempts
    },

    -- Network protection
    NetworkProtection = {
        BlockSuspiciousPorts = true,
        PortBlockDuration = 300000, -- 5 minutes
        EnableIPBlocking = false,
        IPBlockDuration = 600000, -- 10 minutes
        BlockedPorts = { 80, 443, 21, 22, 23, 25, 53, 110, 143, 993, 995 },
        AllowedPorts = { 30120, 30110 } -- FiveM server ports
    },

    -- Memory protection
    MemoryProtection = {
        EnableAllocationProtection = true,
        EnableCodeInjectionPrevention = true,
        MonitorMemoryRegions = true,
        PreventDLLInjection = true,
        ScanFrequency = 10000 -- milliseconds
    },

    -- Anti-debugging measures
    AntiDebugging = {
        DetectDebuggers = true,
        DetectVirtualMachines = true,
        DetectSandboxes = true,
        PreventReverseEngineering = true,
        ObfuscationLevel = "High" -- Low, Medium, High
    },

    -- Hook prevention
    HookPrevention = {
        DetectAPIHooks = true,
        DetectInlineHooks = true,
        DetectIATHooks = true,
        RestoreHookedFunctions = false,
        HookDetectionFrequency = 15000 -- milliseconds
    }
}

-- Response actions configuration
Config.Responses = {
    -- What actions to take when detections occur
    OnDetection = {
        LogToConsole = true,
        LogToDatabase = true, -- Requires database setup
        NotifyAdmins = false, -- Requires admin notification system
        CreateServerLog = true
    },

    -- Critical detection responses
    OnCriticalDetection = {
        LogToConsole = true,
        LogToDatabase = true,
        NotifyAdmins = true,
        TakeAutomaticAction = false, -- Set to true to enable auto-bans/kicks
        AutomaticActionDelay = 5000 -- Delay before taking action (milliseconds)
    },

    -- High severity detection responses
    OnHighSeverityDetection = {
        LogToConsole = true,
        LogToDatabase = true,
        NotifyAdmins = false,
        TakeAutomaticAction = false
    }
}

-- Whitelist configuration
Config.Whitelist = {
    -- Processes that should never be flagged (be careful with this)
    Processes = {
        "explorer.exe",
        "taskmgr.exe",
        "services.exe",
        "lsass.exe",
        "winlogon.exe",
        "csrss.exe",
        "smss.exe",
        "system",
        "conhost.exe"
    },

    -- Network connections that should be ignored
    NetworkConnections = {
        -- Add IP ranges or specific connections to ignore
        -- Example: "192.168.1.0/24", "10.0.0.0/8"
    },

    -- Memory usage thresholds per process (in MB)
    MemoryThresholds = {
        -- Example: ["notepad.exe"] = 100, -- Allow up to 100MB for notepad.exe
    }
}

-- Logging configuration
Config.Logging = {
    Enabled = true,
    LogLevel = "INFO", -- DEBUG, INFO, WARN, ERROR
    LogFile = "antidump.log",
    MaxLogSize = 10 * 1024 * 1024, -- 10MB max log size
    BackupLogs = true,

    -- What to log
    LogEvents = {
        SystemStart = true,
        SystemStop = true,
        Detections = true,
        CriticalDetections = true,
        ModuleStatus = true,
        Errors = true
    }
}

-- Enhanced Database configuration for persistent storage
Config.Database = {
    Enabled = false,
    Type = "mysql", -- mysql, sqlite, postgresql
    Host = "localhost",
    Port = 3306,
    Database = "fivem_antidump",
    Username = "root",
    Password = "",

    -- Connection settings
    ConnectionTimeout = 10000, -- milliseconds
    MaxConnections = 10,
    EnableConnectionPooling = true,
    ReconnectAttempts = 3,
    ReconnectDelay = 5000, -- milliseconds

    -- Tables to create/use
    Tables = {
        Detections = "antidump_detections",
        Processes = "antidump_processes",
        NetworkActivity = "antidump_network_activity",
        Players = "antidump_players",
        Incidents = "antidump_incidents",
        Statistics = "antidump_statistics"
    },

    -- Backup settings
    Backup = {
        Enabled = false,
        Interval = 86400000, -- 24 hours in milliseconds
        RetentionDays = 30,
        CompressionEnabled = true
    },

    -- Migration settings
    Migration = {
        Enabled = true,
        Version = "2.0.0",
        AutoUpdate = true,
        BackupBeforeMigration = true
    }
}

-- Framework-specific settings
Config.Framework = {
    -- Framework detection and integration
    AutoDetect = true,
    PreferredFramework = "auto", -- auto, esx, qbcore, vrp, standalone

    -- ESX Integration
    ESX = {
        Enabled = false,
        ExportName = "esx",
        UseLegacy = false,
        Version = "1.10.0+"
    },

    -- QBCore Integration
    QBCore = {
        Enabled = false,
        ExportName = "qb-core",
        Version = "1.0.0+"
    },

    -- vRP Integration
    vRP = {
        Enabled = false,
        ExportName = "vrp",
        Version = "1.0.0+"
    },

    -- Standalone configuration
    Standalone = {
        Enabled = true,
        PlayerIdentifier = "license", -- license, steam, discord
        AdminPermission = "admin"
    }
}

-- Enhanced Performance settings and monitoring
Config.Performance = {
    -- Limits to prevent system overload
    MaxProcessesToScan = 500,
    MaxNetworkConnectionsToAnalyze = 1000,
    MaxMemoryRegionsToCheck = 10000,

    -- Timeouts
    ProcessTimeout = 5000, -- Timeout for process operations (ms)
    NetworkTimeout = 3000, -- Timeout for network operations (ms)
    MemoryTimeout = 10000, -- Timeout for memory operations (ms)

    -- Advanced performance tuning
    Advanced = {
        EnablePerformanceMonitoring = true,
        MonitorInterval = 60000, -- 1 minute
        AdaptiveLimits = true,
        ResourceThresholds = {
            CPUUsage = 70, -- Maximum CPU usage percentage
            MemoryUsage = 80, -- Maximum memory usage percentage
            DiskUsage = 85 -- Maximum disk usage percentage
        },
        AutoScaleDetection = true,
        MinScanInterval = 1000, -- Minimum scan interval in milliseconds
        MaxScanInterval = 60000 -- Maximum scan interval in milliseconds
    },

    -- Memory management
    Memory = {
        EnableGarbageCollection = true,
        GCInterval = 300000, -- 5 minutes
        MaxMemoryUsage = 512, -- MB
        EnableMemoryOptimization = true,
        MemoryOptimizationInterval = 600000 -- 10 minutes
    },

    -- Thread management
    Threads = {
        MinWorkerThreads = 2,
        MaxWorkerThreads = 8,
        QueueSize = 1000,
        ThreadTimeout = 30000 -- milliseconds
    }
}

-- Security and encryption settings
Config.Security = {
    -- Configuration encryption
    EncryptSensitiveData = false,
    EncryptionKey = "", -- Set to encrypt database passwords, webhook URLs, etc.
    ConfigEncryption = false,

    -- Access control
    AccessControl = {
        EnableIPWhitelist = false,
        AllowedIPs = {},
        EnableAPIToken = false,
        APIToken = "",
        RequireAuthentication = false
    },

    -- Audit logging
    Audit = {
        Enabled = true,
        LogConfigChanges = true,
        LogAccessAttempts = true,
        LogAdminActions = true,
        RetentionDays = 90
    },

    -- Rate limiting
    RateLimiting = {
        Enabled = true,
        MaxRequestsPerMinute = 60,
        MaxRequestsPerHour = 1000,
        EnableBurstProtection = true,
        BurstLimit = 10
    }
}

-- Advanced settings
Config.Advanced = {
    -- Cache settings
    CacheEnabled = true,
    CacheTimeout = 30000, -- 30 seconds

    -- Rate limiting
    RateLimitingEnabled = true,
    MaxDetectionsPerMinute = 100,

    -- Custom signatures file
    CustomSignaturesFile = nil, -- Set to path if using custom signatures

    -- Integration settings
    DiscordWebhooks = {
        Enabled = false,
        CriticalDetectionsURL = "",
        HighSeverityDetectionsURL = ""
    }
}

-- Notification system configuration
Config.Notifications = {
    Enabled = true,

    -- Player notifications
    PlayerNotifications = {
        Enabled = true,
        ProgressiveWarnings = true,
        MaxWarnings = 3,
        WarningCooldown = 60000, -- 1 minute

        -- Custom messages (optional)
        Messages = {
            FirstWarning = "~r~[SECURITY] Server dumping attempt detected from your system. This is your first warning.",
            FinalWarning = "~r~[SECURITY] Final warning: Server dumping activity continues to be detected. Immediate action will be taken.",
            DetectionAlert = "~r~[SECURITY] Critical: Server dumping attempt detected. You will be removed from the server.",
            CooldownMessage = "~y~[SECURITY] Please wait before performing this action again."
        }
    },

    -- Admin notifications
    AdminNotifications = {
        Enabled = true,
        ConsoleNotifications = true,
        AdminChatNotifications = true,
        PriorityAlertsOnly = false, -- Set to true to only notify for high/critical detections

        -- Admin permission integration
        PermissionLevels = {
            SuperAdmin = "antidump.superadmin",
            Admin = "antidump.admin",
            Moderator = "antidump.moderator"
        }
    },

    -- Logging system
    Logging = {
        Enabled = true,
        LogLevel = "INFO", -- DEBUG, INFO, WARN, ERROR, CRITICAL
        LogFile = "antidump.log",
        MaxLogSize = 10 * 1024 * 1024, -- 10MB
        BackupLogs = true,
        MaxLogEntries = 10000,

        -- What to log
        LogEvents = {
            Detections = true,
            CriticalDetections = true,
            SystemEvents = true,
            Errors = true,
            Notifications = false
        }
    },

    -- Discord webhooks
    Discord = {
        Enabled = false,
        WebhookURL = "",
        CriticalDetectionsURL = "",
        HighSeverityDetectionsURL = "",
        Username = "Anti-Dump System",
        AvatarURL = "",

        -- Rate limiting
        RateLimitPerMinute = 10,
        RateLimitBurst = 3,
        Timeout = 5000,

        -- Features
        EnableEmbeds = true,
        EnableMentions = false,
        MentionRoleID = "",

        -- Retry settings
        RetryAttempts = 3,
        RetryDelay = 1000
    }
}

-- Export configuration for external access
function Config.GetDetectionConfig()
    return Config.Detection
end

function Config.GetResponseConfig()
    return Config.Responses
end

function Config.GetWhitelistConfig()
    return Config.Whitelist
end

function Config.IsProcessWhitelisted(processName)
    for _, whitelisted in ipairs(Config.Whitelist.Processes) do
        if whitelisted:lower() == processName:lower() then
            return true
        end
    end
    return false
end

function Config.GetMemoryThreshold(processName)
    return Config.Whitelist.MemoryThresholds[processName]
end

function Config.GetNotificationConfig()
    return Config.Notifications
end

function Config.GetPlayerNotificationConfig()
    return Config.Notifications.PlayerNotifications
end

function Config.GetAdminNotificationConfig()
    return Config.Notifications.AdminNotifications
end

function Config.GetLoggingConfig()
    return Config.Notifications.Logging
end

function Config.GetDiscordConfig()
    return Config.Notifications.Discord
end

-- Enhanced Configuration Management Functions
function Config.GetPreventionConfig()
    return Config.Prevention
end

function Config.GetDatabaseConfig()
    return Config.Database
end

function Config.GetFrameworkConfig()
    return Config.Framework
end

function Config.GetPerformanceConfig()
    return Config.Performance
end

function Config.GetSecurityConfig()
    return Config.Security
end

function Config.GetEnvironmentConfig()
    return Config.Environment
end

-- Hot Configuration Reload System
Config._originalConfig = nil
Config._configFilePath = "server/config.lua"
Config._lastModified = nil

function Config.ReloadConfiguration()
    if not Config.AutoReload then
        return false, "Auto-reload is disabled"
    end

    local success, result = pcall(function()
        -- Backup current configuration
        Config._originalConfig = Config._deepCopy(Config)

        -- Reload configuration file
        local file = LoadResourceFile(GetCurrentResourceName(), Config._configFilePath)
        if not file then
            return false, "Failed to read configuration file"
        end

        -- Create new environment for the config
        local configEnv = setmetatable({
            Config = Config._originalConfig or {}
        }, { __index = _G })

        -- Load the configuration
        local configFunction = load(file, "config", "t", configEnv)
        if not configFunction then
            return false, "Failed to parse configuration file"
        end

        local newConfig = configFunction()
        if not newConfig then
            return false, "Configuration file returned nil"
        end

        -- Validate new configuration
        local isValid, validationErrors = Config.ValidateConfiguration(newConfig)
        if not isValid then
            return false, "Configuration validation failed: " .. table.concat(validationErrors, ", ")
        end

        -- Apply new configuration
        for key, value in pairs(newConfig) do
            Config[key] = value
        end

        Config._lastModified = os.time()
        return true, "Configuration reloaded successfully"
    end)

    if not success then
        print("[Anti-Dump] Configuration reload failed: " .. result)
        return false, result
    end

    return result
end

-- Configuration Validation System
function Config.ValidateConfiguration(config)
    local errors = {}

    -- Validate Detection configuration
    if config.Detection then
        if config.Detection.ScanInterval and (config.Detection.ScanInterval < 1000 or config.Detection.ScanInterval > 3600000) then
            table.insert(errors, "Detection.ScanInterval must be between 1000 and 3600000 milliseconds")
        end

        if config.Detection.Sensitivity and not config.Detection.SensitivityLevels[config.Detection.Sensitivity] then
            table.insert(errors, "Invalid Detection.Sensitivity value")
        end
    end

    -- Validate Database configuration
    if config.Database and config.Database.Enabled then
        if not config.Database.Host or config.Database.Host == "" then
            table.insert(errors, "Database.Host is required when database is enabled")
        end

        if not config.Database.Database or config.Database.Database == "" then
            table.insert(errors, "Database.Database is required when database is enabled")
        end
    end

    -- Validate Prevention configuration
    if config.Prevention then
        if config.Prevention.ResponseDelay and config.Prevention.ResponseDelay < 0 then
            table.insert(errors, "Prevention.ResponseDelay must be positive")
        end
    end

    return #errors == 0, errors
end

-- Deep copy utility function
function Config._deepCopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Config._deepCopy(orig_key)] = Config._deepCopy(orig_value)
        end
        setmetatable(copy, Config._deepCopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

-- Environment-based configuration override
function Config.LoadEnvironmentConfig()
    local environment = Config.Environment or "production"
    local envConfigPath = "server/config/" .. environment .. ".lua"

    if LoadResourceFile(GetCurrentResourceName(), envConfigPath) then
        local success, result = pcall(function()
            local envFile = LoadResourceFile(GetCurrentResourceName(), envConfigPath)
            local envFunction = load(envFile, "env-config", "t", { Config = Config })
            if envFunction then
                local envConfig = envFunction()
                if envConfig then
                    -- Merge environment-specific settings
                    for key, value in pairs(envConfig) do
                        if type(value) == "table" and type(Config[key]) == "table" then
                            -- Deep merge tables
                            for subKey, subValue in pairs(value) do
                                Config[key][subKey] = subValue
                            end
                        else
                            Config[key] = value
                        end
                    end
                end
            end
        end)

        if not success then
            print("[Anti-Dump] Failed to load environment configuration: " .. result)
        end
    end
end

-- Initialize enhanced configuration system
Citizen.CreateThread(function()
    -- Load environment-specific configuration
    Config.LoadEnvironmentConfig()

    -- Validate configuration
    local isValid, validationErrors = Config.ValidateConfiguration(Config)
    if not isValid then
        print("[Anti-Dump] Configuration validation failed:")
        for _, error in ipairs(validationErrors) do
            print("[Anti-Dump]  - " .. error)
        end
    end

    if Config.DebugMode then
        print("[Anti-Dump] Enhanced Configuration v" .. Config.Version .. " loaded")
        print("[Anti-Dump] Environment: " .. Config.Environment)
        if Config.Logging.LogEvents.SystemStart then
            print("[Anti-Dump] Anti-Dump system starting with debug mode enabled")
        end
    end

    -- Setup configuration monitoring for hot reload
    if Config.AutoReload then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(30000) -- Check every 30 seconds

                -- Check if configuration file has been modified
                local resourceName = GetCurrentResourceName()
                local configPath = "server/config.lua"
                local fileTime = GetResourceMetadata(resourceName, "file_modified_time_" .. configPath)

                if fileTime and (not Config._lastModified or fileTime > Config._lastModified) then
                    local success, message = Config.ReloadConfiguration()
                    if success then
                        print("[Anti-Dump] Configuration automatically reloaded: " .. message)
                    else
                        print("[Anti-Dump] Failed to auto-reload configuration: " .. message)
                    end
                end
            end
        end)
    end
end)


-- FiveM Anti-Dump Configuration
-- Enhanced configuration management system for anti-dump detection
-- Version: 2.0.0

Config = {}

-- System Information
Config.Version = "2.0.0"
Config.Author = "Anti-Dump System"
Config.Description = "Enhanced FiveM Anti-Server Dump Protection"

-- Environment configuration
Config.Environment = "production" -- development, staging, production
Config.AutoReload = true -- Enable hot configuration reload

-- Debug configuration
Config.DebugMode = false -- Set to true for development/testing
Config.DebugLevel = "INFO" -- TRACE, DEBUG, INFO, WARN, ERROR

-- Enhanced Detection engine settings
Config.Detection = {
    Enabled = true,
    ScanInterval = 5000, -- Milliseconds between full scans
    ProcessScanInterval = 3000, -- Process-specific scan interval
    NetworkScanInterval = 10000, -- Network scan interval
    MemoryScanInterval = 15000, -- Memory scan interval
    MaxConcurrentScans = 3, -- Maximum concurrent scan operations

    -- Advanced detection settings
    EnableProcessMonitor = true,
    EnableNetworkMonitor = true,
    EnableMemoryScanner = true,
    EnableSignatureScanning = true,
    EnableBehavioralAnalysis = true,
    EnableHeuristicDetection = true,

    -- Detection sensitivity levels
    SensitivityLevels = {
        Low = 30,
        Medium = 60,
        High = 90,
        Ultra = 95
    },

    -- Current sensitivity setting
    Sensitivity = "Medium", -- Low, Medium, High, Ultra

    -- Detection thresholds
    Thresholds = {
        CriticalRiskScore = 90,
        HighRiskScore = 70,
        MediumRiskScore = 50,
        LowRiskScore = 25
    },

    -- Advanced thresholds
    AdvancedThresholds = {
        ProcessCountThreshold = 100,
        MemoryUsageThreshold = 500, -- MB
        NetworkConnectionThreshold = 50,
        SuspiciousProcessThreshold = 10,
        AnomalyDetectionThreshold = 75
    },

    -- Module toggles
    Modules = {
        ProcessMonitor = true,
        NetworkMonitor = true,
        MemoryScanner = true,
        SignatureScanner = true,
        BehavioralAnalyzer = true,
        HeuristicEngine = true
    },

    -- Performance tuning
    Performance = {
        EnableAdaptiveScanning = true,
        AdaptiveScanReduction = 0.5, -- Reduce scan frequency by 50% under load
        MaxCPUTimePerScan = 100, -- Maximum CPU time per scan in milliseconds
        MemoryLimitPerScan = 50 -- Maximum memory usage per scan in MB
    }
}

-- Enhanced Prevention system configuration
Config.Prevention = {
    -- Core prevention settings
    Enabled = true,
    AutoTerminateProcesses = true,
    BlockNetworkPorts = true,
    MemoryProtection = true,
    AntiDebugging = true,
    HookPrevention = true,

    -- Response timing
    ResponseDelay = 1000, -- milliseconds before taking action
    EscalationDelay = 5000, -- milliseconds before escalating response
    CooldownPeriod = 30000, -- milliseconds between repeated actions

    -- Process management
    ProcessManagement = {
        ForceTerminate = true,
        KillProcessTree = false, -- Kill parent and child processes
        TerminationTimeout = 5000, -- milliseconds to wait for graceful termination
        MaxRetries = 3 -- Maximum termination attempts
    },

    -- Network protection
    NetworkProtection = {
        BlockSuspiciousPorts = true,
        PortBlockDuration = 300000, -- 5 minutes
        EnableIPBlocking = false,
        IPBlockDuration = 600000, -- 10 minutes
        BlockedPorts = { 80, 443, 21, 22, 23, 25, 53, 110, 143, 993, 995 },
        AllowedPorts = { 30120, 30110 } -- FiveM server ports
    },

    -- Memory protection
    MemoryProtection = {
        EnableAllocationProtection = true,
        EnableCodeInjectionPrevention = true,
        MonitorMemoryRegions = true,
        PreventDLLInjection = true,
        ScanFrequency = 10000 -- milliseconds
    },

    -- Anti-debugging measures
    AntiDebugging = {
        DetectDebuggers = true,
        DetectVirtualMachines = true,
        DetectSandboxes = true,
        PreventReverseEngineering = true,
        ObfuscationLevel = "High" -- Low, Medium, High
    },

    -- Hook prevention
    HookPrevention = {
        DetectAPIHooks = true,
        DetectInlineHooks = true,
        DetectIATHooks = true,
        RestoreHookedFunctions = false,
        HookDetectionFrequency = 15000 -- milliseconds
    }
}

-- Response actions configuration
Config.Responses = {
    -- What actions to take when detections occur
    OnDetection = {
        LogToConsole = true,
        LogToDatabase = true, -- Requires database setup
        NotifyAdmins = false, -- Requires admin notification system
        CreateServerLog = true
    },

    -- Critical detection responses
    OnCriticalDetection = {
        LogToConsole = true,
        LogToDatabase = true,
        NotifyAdmins = true,
        TakeAutomaticAction = false, -- Set to true to enable auto-bans/kicks
        AutomaticActionDelay = 5000 -- Delay before taking action (milliseconds)
    },

    -- High severity detection responses
    OnHighSeverityDetection = {
        LogToConsole = true,
        LogToDatabase = true,
        NotifyAdmins = false,
        TakeAutomaticAction = false
    }
}

-- Whitelist configuration
Config.Whitelist = {
    -- Processes that should never be flagged (be careful with this)
    Processes = {
        "explorer.exe",
        "taskmgr.exe",
        "services.exe",
        "lsass.exe",
        "winlogon.exe",
        "csrss.exe",
        "smss.exe",
        "system",
        "conhost.exe"
    },

    -- Network connections that should be ignored
    NetworkConnections = {
        -- Add IP ranges or specific connections to ignore
        -- Example: "192.168.1.0/24", "10.0.0.0/8"
    },

    -- Memory usage thresholds per process (in MB)
    MemoryThresholds = {
        -- Example: ["notepad.exe"] = 100, -- Allow up to 100MB for notepad.exe
    }
}

-- Logging configuration
Config.Logging = {
    Enabled = true,
    LogLevel = "INFO", -- DEBUG, INFO, WARN, ERROR
    LogFile = "antidump.log",
    MaxLogSize = 10 * 1024 * 1024, -- 10MB max log size
    BackupLogs = true,

    -- What to log
    LogEvents = {
        SystemStart = true,
        SystemStop = true,
        Detections = true,
        CriticalDetections = true,
        ModuleStatus = true,
        Errors = true
    }
}

-- Enhanced Database configuration for persistent storage
Config.Database = {
    Enabled = false,
    Type = "mysql", -- mysql, sqlite, postgresql
    Host = "localhost",
    Port = 3306,
    Database = "fivem_antidump",
    Username = "root",
    Password = "",

    -- Connection settings
    ConnectionTimeout = 10000, -- milliseconds
    MaxConnections = 10,
    EnableConnectionPooling = true,
    ReconnectAttempts = 3,
    ReconnectDelay = 5000, -- milliseconds

    -- Tables to create/use
    Tables = {
        Detections = "antidump_detections",
        Processes = "antidump_processes",
        NetworkActivity = "antidump_network_activity",
        Players = "antidump_players",
        Incidents = "antidump_incidents",
        Statistics = "antidump_statistics"
    },

    -- Backup settings
    Backup = {
        Enabled = false,
        Interval = 86400000, -- 24 hours in milliseconds
        RetentionDays = 30,
        CompressionEnabled = true
    },

    -- Migration settings
    Migration = {
        Enabled = true,
        Version = "2.0.0",
        AutoUpdate = true,
        BackupBeforeMigration = true
    }
}

-- Framework-specific settings
Config.Framework = {
    -- Framework detection and integration
    AutoDetect = true,
    PreferredFramework = "auto", -- auto, esx, qbcore, vrp, standalone

    -- ESX Integration
    ESX = {
        Enabled = false,
        ExportName = "esx",
        UseLegacy = false,
        Version = "1.10.0+"
    },

    -- QBCore Integration
    QBCore = {
        Enabled = false,
        ExportName = "qb-core",
        Version = "1.0.0+"
    },

    -- vRP Integration
    vRP = {
        Enabled = false,
        ExportName = "vrp",
        Version = "1.0.0+"
    },

    -- Standalone configuration
    Standalone = {
        Enabled = true,
        PlayerIdentifier = "license", -- license, steam, discord
        AdminPermission = "admin"
    }
}

-- Enhanced Performance settings and monitoring
Config.Performance = {
    -- Limits to prevent system overload
    MaxProcessesToScan = 500,
    MaxNetworkConnectionsToAnalyze = 1000,
    MaxMemoryRegionsToCheck = 10000,

    -- Timeouts
    ProcessTimeout = 5000, -- Timeout for process operations (ms)
    NetworkTimeout = 3000, -- Timeout for network operations (ms)
    MemoryTimeout = 10000, -- Timeout for memory operations (ms)

    -- Advanced performance tuning
    Advanced = {
        EnablePerformanceMonitoring = true,
        MonitorInterval = 60000, -- 1 minute
        AdaptiveLimits = true,
        ResourceThresholds = {
            CPUUsage = 70, -- Maximum CPU usage percentage
            MemoryUsage = 80, -- Maximum memory usage percentage
            DiskUsage = 85 -- Maximum disk usage percentage
        },
        AutoScaleDetection = true,
        MinScanInterval = 1000, -- Minimum scan interval in milliseconds
        MaxScanInterval = 60000 -- Maximum scan interval in milliseconds
    },

    -- Memory management
    Memory = {
        EnableGarbageCollection = true,
        GCInterval = 300000, -- 5 minutes
        MaxMemoryUsage = 512, -- MB
        EnableMemoryOptimization = true,
        MemoryOptimizationInterval = 600000 -- 10 minutes
    },

    -- Thread management
    Threads = {
        MinWorkerThreads = 2,
        MaxWorkerThreads = 8,
        QueueSize = 1000,
        ThreadTimeout = 30000 -- milliseconds
    }
}

-- Security and encryption settings
Config.Security = {
    -- Configuration encryption
    EncryptSensitiveData = false,
    EncryptionKey = "", -- Set to encrypt database passwords, webhook URLs, etc.
    ConfigEncryption = false,

    -- Access control
    AccessControl = {
        EnableIPWhitelist = false,
        AllowedIPs = {},
        EnableAPIToken = false,
        APIToken = "",
        RequireAuthentication = false
    },

    -- Audit logging
    Audit = {
        Enabled = true,
        LogConfigChanges = true,
        LogAccessAttempts = true,
        LogAdminActions = true,
        RetentionDays = 90
    },

    -- Rate limiting
    RateLimiting = {
        Enabled = true,
        MaxRequestsPerMinute = 60,
        MaxRequestsPerHour = 1000,
        EnableBurstProtection = true,
        BurstLimit = 10
    }
}

-- Advanced settings
Config.Advanced = {
    -- Cache settings
    CacheEnabled = true,
    CacheTimeout = 30000, -- 30 seconds

    -- Rate limiting
    RateLimitingEnabled = true,
    MaxDetectionsPerMinute = 100,

    -- Custom signatures file
    CustomSignaturesFile = nil, -- Set to path if using custom signatures

    -- Integration settings
    DiscordWebhooks = {
        Enabled = false,
        CriticalDetectionsURL = "",
        HighSeverityDetectionsURL = ""
    }
}

-- Notification system configuration
Config.Notifications = {
    Enabled = true,

    -- Player notifications
    PlayerNotifications = {
        Enabled = true,
        ProgressiveWarnings = true,
        MaxWarnings = 3,
        WarningCooldown = 60000, -- 1 minute

        -- Custom messages (optional)
        Messages = {
            FirstWarning = "~r~[SECURITY] Server dumping attempt detected from your system. This is your first warning.",
            FinalWarning = "~r~[SECURITY] Final warning: Server dumping activity continues to be detected. Immediate action will be taken.",
            DetectionAlert = "~r~[SECURITY] Critical: Server dumping attempt detected. You will be removed from the server.",
            CooldownMessage = "~y~[SECURITY] Please wait before performing this action again."
        }
    },

    -- Admin notifications
    AdminNotifications = {
        Enabled = true,
        ConsoleNotifications = true,
        AdminChatNotifications = true,
        PriorityAlertsOnly = false, -- Set to true to only notify for high/critical detections

        -- Admin permission integration
        PermissionLevels = {
            SuperAdmin = "antidump.superadmin",
            Admin = "antidump.admin",
            Moderator = "antidump.moderator"
        }
    },

    -- Logging system
    Logging = {
        Enabled = true,
        LogLevel = "INFO", -- DEBUG, INFO, WARN, ERROR, CRITICAL
        LogFile = "antidump.log",
        MaxLogSize = 10 * 1024 * 1024, -- 10MB
        BackupLogs = true,
        MaxLogEntries = 10000,

        -- What to log
        LogEvents = {
            Detections = true,
            CriticalDetections = true,
            SystemEvents = true,
            Errors = true,
            Notifications = false
        }
    },

    -- Discord webhooks
    Discord = {
        Enabled = false,
        WebhookURL = "",
        CriticalDetectionsURL = "",
        HighSeverityDetectionsURL = "",
        Username = "Anti-Dump System",
        AvatarURL = "",

        -- Rate limiting
        RateLimitPerMinute = 10,
        RateLimitBurst = 3,
        Timeout = 5000,

        -- Features
        EnableEmbeds = true,
        EnableMentions = false,
        MentionRoleID = "",

        -- Retry settings
        RetryAttempts = 3,
        RetryDelay = 1000
    }
}

-- Export configuration for external access
function Config.GetDetectionConfig()
    return Config.Detection
end

function Config.GetResponseConfig()
    return Config.Responses
end

function Config.GetWhitelistConfig()
    return Config.Whitelist
end

function Config.IsProcessWhitelisted(processName)
    for _, whitelisted in ipairs(Config.Whitelist.Processes) do
        if whitelisted:lower() == processName:lower() then
            return true
        end
    end
    return false
end

function Config.GetMemoryThreshold(processName)
    return Config.Whitelist.MemoryThresholds[processName]
end

function Config.GetNotificationConfig()
    return Config.Notifications
end

function Config.GetPlayerNotificationConfig()
    return Config.Notifications.PlayerNotifications
end

function Config.GetAdminNotificationConfig()
    return Config.Notifications.AdminNotifications
end

function Config.GetLoggingConfig()
    return Config.Notifications.Logging
end

function Config.GetDiscordConfig()
    return Config.Notifications.Discord
end

-- Enhanced Configuration Management Functions
function Config.GetPreventionConfig()
    return Config.Prevention
end

function Config.GetDatabaseConfig()
    return Config.Database
end

function Config.GetFrameworkConfig()
    return Config.Framework
end

function Config.GetPerformanceConfig()
    return Config.Performance
end

function Config.GetSecurityConfig()
    return Config.Security
end

function Config.GetEnvironmentConfig()
    return Config.Environment
end

-- Hot Configuration Reload System
Config._originalConfig = nil
Config._configFilePath = "server/config.lua"
Config._lastModified = nil

function Config.ReloadConfiguration()
    if not Config.AutoReload then
        return false, "Auto-reload is disabled"
    end

    local success, result = pcall(function()
        -- Backup current configuration
        Config._originalConfig = Config._deepCopy(Config)

        -- Reload configuration file
        local file = LoadResourceFile(GetCurrentResourceName(), Config._configFilePath)
        if not file then
            return false, "Failed to read configuration file"
        end

        -- Create new environment for the config
        local configEnv = setmetatable({
            Config = Config._originalConfig or {}
        }, { __index = _G })

        -- Load the configuration
        local configFunction = load(file, "config", "t", configEnv)
        if not configFunction then
            return false, "Failed to parse configuration file"
        end

        local newConfig = configFunction()
        if not newConfig then
            return false, "Configuration file returned nil"
        end

        -- Validate new configuration
        local isValid, validationErrors = Config.ValidateConfiguration(newConfig)
        if not isValid then
            return false, "Configuration validation failed: " .. table.concat(validationErrors, ", ")
        end

        -- Apply new configuration
        for key, value in pairs(newConfig) do
            Config[key] = value
        end

        Config._lastModified = os.time()
        return true, "Configuration reloaded successfully"
    end)

    if not success then
        print("[Anti-Dump] Configuration reload failed: " .. result)
        return false, result
    end

    return result
end

-- Configuration Validation System
function Config.ValidateConfiguration(config)
    local errors = {}

    -- Validate Detection configuration
    if config.Detection then
        if config.Detection.ScanInterval and (config.Detection.ScanInterval < 1000 or config.Detection.ScanInterval > 3600000) then
            table.insert(errors, "Detection.ScanInterval must be between 1000 and 3600000 milliseconds")
        end

        if config.Detection.Sensitivity and not config.Detection.SensitivityLevels[config.Detection.Sensitivity] then
            table.insert(errors, "Invalid Detection.Sensitivity value")
        end
    end

    -- Validate Database configuration
    if config.Database and config.Database.Enabled then
        if not config.Database.Host or config.Database.Host == "" then
            table.insert(errors, "Database.Host is required when database is enabled")
        end

        if not config.Database.Database or config.Database.Database == "" then
            table.insert(errors, "Database.Database is required when database is enabled")
        end
    end

    -- Validate Prevention configuration
    if config.Prevention then
        if config.Prevention.ResponseDelay and config.Prevention.ResponseDelay < 0 then
            table.insert(errors, "Prevention.ResponseDelay must be positive")
        end
    end

    return #errors == 0, errors
end

-- Deep copy utility function
function Config._deepCopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Config._deepCopy(orig_key)] = Config._deepCopy(orig_value)
        end
        setmetatable(copy, Config._deepCopy(getmetatable(orig)))
    else
        copy = orig
    end

    return copy
end

-- Environment-based configuration override
function Config.LoadEnvironmentConfig()
    local environment = Config.Environment or "production"
    local envConfigPath = "server/config/" .. environment .. ".lua"

    if LoadResourceFile(GetCurrentResourceName(), envConfigPath) then
        local success, result = pcall(function()
            local envFile = LoadResourceFile(GetCurrentResourceName(), envConfigPath)
            local envFunction = load(envFile, "env-config", "t", { Config = Config })
            if envFunction then
                local envConfig = envFunction()
                if envConfig then
                    -- Merge environment-specific settings
                    for key, value in pairs(envConfig) do
                        if type(value) == "table" and type(Config[key]) == "table" then
                            -- Deep merge tables
                            for subKey, subValue in pairs(value) do
                                Config[key][subKey] = subValue
                            end
                        else
                            Config[key] = value
                        end
                    end
                end
            end
        end)

        if not success then
            print("[Anti-Dump] Failed to load environment configuration: " .. result)
        end
    end
end

-- Initialize enhanced configuration system
Citizen.CreateThread(function()
    -- Load environment-specific configuration
    Config.LoadEnvironmentConfig()

    -- Validate configuration
    local isValid, validationErrors = Config.ValidateConfiguration(Config)
    if not isValid then
        print("[Anti-Dump] Configuration validation failed:")
        for _, error in ipairs(validationErrors) do
            print("[Anti-Dump]  - " .. error)
        end
    end

    if Config.DebugMode then
        print("[Anti-Dump] Enhanced Configuration v" .. Config.Version .. " loaded")
        print("[Anti-Dump] Environment: " .. Config.Environment)
        if Config.Logging.LogEvents.SystemStart then
            print("[Anti-Dump] Anti-Dump system starting with debug mode enabled")
        end
    end

    -- Setup configuration monitoring for hot reload
    if Config.AutoReload then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(30000) -- Check every 30 seconds

                -- Check if configuration file has been modified
                local resourceName = GetCurrentResourceName()
                local configPath = "server/config.lua"
                local fileTime = GetResourceMetadata(resourceName, "file_modified_time_" .. configPath)

                if fileTime and (not Config._lastModified or fileTime > Config._lastModified) then
                    local success, message = Config.ReloadConfiguration()
                    if success then
                        print("[Anti-Dump] Configuration automatically reloaded: " .. message)
                    else
                        print("[Anti-Dump] Failed to auto-reload configuration: " .. message)
                    end
                end
            end
        end)
    end
end)


return Config
<<<<<<< HEAD
-- FiveM Anti-Dump Development Configuration
-- Optimized settings for development and testing environments
-- Version: 2.0.0

Config = {
    -- Environment Configuration
    Environment = "development",
    DebugMode = true,
    DebugLevel = "DEBUG",
    AutoReload = true,

    -- System Information
    Version = "2.0.0",
    Author = "Anti-Dump Development Team",
    Description = "Development Environment Configuration",

    -- Detection Engine (Relaxed for development)
    Detection = {
        Enabled = true,
        ScanInterval = 10000, -- 10 seconds for development
        ProcessScanInterval = 5000, -- 5 seconds
        NetworkScanInterval = 15000, -- 15 seconds
        MemoryScanInterval = 20000, -- 20 seconds
        MaxConcurrentScans = 2, -- Reduced for development

        -- Enable all detection modules
        EnableProcessMonitor = true,
        EnableNetworkMonitor = true,
        EnableMemoryScanner = true,
        EnableSignatureScanning = true,
        EnableBehavioralAnalysis = true,
        EnableHeuristicDetection = true,

        -- Low sensitivity for development
        Sensitivity = "Low", -- Low, Medium, High, Ultra

        -- Lower thresholds for development testing
        Thresholds = {
            CriticalRiskScore = 95, -- Very high threshold
            HighRiskScore = 80,
            MediumRiskScore = 60,
            LowRiskScore = 30
        },

        -- Relaxed advanced thresholds
        AdvancedThresholds = {
            ProcessCountThreshold = 200, -- Higher limit
            MemoryUsageThreshold = 1000, -- 1GB
            NetworkConnectionThreshold = 100,
            SuspiciousProcessThreshold = 20,
            AnomalyDetectionThreshold = 90
        },

        -- All modules enabled for testing
        Modules = {
            ProcessMonitor = true,
            NetworkMonitor = true,
            MemoryScanner = true,
            SignatureScanner = true,
            BehavioralAnalyzer = true,
            HeuristicEngine = true
        },

        -- Performance settings for development
        Performance = {
            EnableAdaptiveScanning = true,
            AdaptiveScanReduction = 0.3, -- More aggressive reduction
            MaxCPUTimePerScan = 200, -- Higher limit
            MemoryLimitPerScan = 100 -- Higher limit in MB
        }
    },

    -- Prevention System (Disabled for development)
    Prevention = {
        Enabled = false, -- Disabled to prevent interference
        AutoTerminateProcesses = false,
        BlockNetworkPorts = false,
        MemoryProtection = false,
        AntiDebugging = false,
        HookPrevention = false,

        -- No response delays for development
        ResponseDelay = 100, -- Fast response
        EscalationDelay = 1000,
        CooldownPeriod = 5000, -- Short cooldown

        -- Process management disabled
        ProcessManagement = {
            ForceTerminate = false,
            KillProcessTree = false,
            TerminationTimeout = 1000,
            MaxRetries = 1
        },

        -- Network protection disabled
        NetworkProtection = {
            BlockSuspiciousPorts = false,
            PortBlockDuration = 30000, -- 30 seconds
            EnableIPBlocking = false,
            IPBlockDuration = 60000, -- 1 minute
            BlockedPorts = { 80, 443, 21, 22 },
            AllowedPorts = { 30120, 30110 }
        },

        -- Memory protection disabled
        MemoryProtection = {
            EnableAllocationProtection = false,
            EnableCodeInjectionPrevention = false,
            MonitorMemoryRegions = false,
            PreventDLLInjection = false,
            ScanFrequency = 30000 -- 30 seconds
        },

        -- Anti-debugging disabled
        AntiDebugging = {
            DetectDebuggers = false,
            DetectVirtualMachines = false,
            DetectSandboxes = false,
            PreventReverseEngineering = false,
            ObfuscationLevel = "Low"
        },

        -- Hook prevention disabled
        HookPrevention = {
            DetectAPIHooks = false,
            DetectInlineHooks = false,
            DetectIATHooks = false,
            RestoreHookedFunctions = false,
            HookDetectionFrequency = 60000 -- 1 minute
        }
    },

    -- Response Actions (Minimal for development)
    Responses = {
        OnDetection = {
            LogToConsole = true,
            LogToDatabase = false, -- Disabled for development
            NotifyAdmins = false,
            CreateServerLog = true
        },

        OnCriticalDetection = {
            LogToConsole = true,
            LogToDatabase = false,
            NotifyAdmins = false, -- No admin notifications
            TakeAutomaticAction = false, -- No auto-actions
            AutomaticActionDelay = 1000
        },

        OnHighSeverityDetection = {
            LogToConsole = true,
            LogToDatabase = false,
            NotifyAdmins = false,
            TakeAutomaticAction = false
        }
    },

    -- Expanded whitelist for development
    Whitelist = {
        Processes = {
            -- System processes
            "explorer.exe",
            "taskmgr.exe",
            "services.exe",
            "lsass.exe",
            "winlogon.exe",
            "csrss.exe",
            "smss.exe",
            "system",
            "conhost.exe",

            -- Development tools
            "code.exe", -- VS Code
            "devenv.exe", -- Visual Studio
            "notepad++.exe",
            "notepad.exe",
            "cmd.exe",
            "powershell.exe",
            "chrome.exe",
            "firefox.exe",
            "steam.exe",
            "teamspeak3.exe",
            "discord.exe",
            "teams.exe",
            "zoom.exe",
            "anydesk.exe",
            "teamviewer.exe",

            -- Gaming related
            "gta5.exe",
            "fiveM.exe",
            "fiveM_b2802.exe",
            "fiveM_b2944.exe",
            "socialclub.dll",
            "steamclient.dll",

            -- Testing tools
            "fiddler.exe",
            "wireshark.exe",
            "procmon.exe",
            "procmon64.exe"
        },

        NetworkConnections = {
            -- Development network ranges
            "127.0.0.0/8",      -- Localhost
            "10.0.0.0/8",       -- Private networks
            "172.16.0.0/12",    -- Private networks
            "192.168.0.0/16",   -- Private networks
            "localhost",
            "127.0.0.1"
        },

        MemoryThresholds = {
            -- Relaxed memory limits for development
            ["chrome.exe"] = 500,      -- 500MB for Chrome
            ["code.exe"] = 300,        -- 300MB for VS Code
            ["steam.exe"] = 200,       -- 200MB for Steam
            ["gta5.exe"] = 2048,       -- 2GB for GTA5
            ["fiveM.exe"] = 1024       -- 1GB for FiveM
        }
    },

    -- Enhanced logging for development
    Logging = {
        Enabled = true,
        LogLevel = "DEBUG",
        LogFile = "antidump_development.log",
        MaxLogSize = 5 * 1024 * 1024, -- 5MB
        BackupLogs = true,

        LogEvents = {
            SystemStart = true,
            SystemStop = true,
            Detections = true,
            CriticalDetections = true,
            ModuleStatus = true,
            Errors = true
        }
    },

    -- Database configuration for development
    Database = {
        Enabled = false, -- Disabled for development by default
        Type = "sqlite", -- SQLite for development
        Host = "localhost",
        Port = 3306,
        Database = "fivem_antidump_dev",
        Username = "root",
        Password = "",

        ConnectionTimeout = 5000,
        MaxConnections = 5,
        EnableConnectionPooling = true,
        ReconnectAttempts = 2,
        ReconnectDelay = 2000,

        Tables = {
            Detections = "antidump_detections_dev",
            Processes = "antidump_processes_dev",
            NetworkActivity = "antidump_network_activity_dev",
            Players = "antidump_players_dev",
            Incidents = "antidump_incidents_dev",
            Statistics = "antidump_statistics_dev"
        },

        Backup = {
            Enabled = false,
            Interval = 86400000,
            RetentionDays = 7,
            CompressionEnabled = true
        },

        Migration = {
            Enabled = true,
            Version = "2.0.0",
            AutoUpdate = true,
            BackupBeforeMigration = true
        }
    },

    -- Framework configuration for development
    Framework = {
        AutoDetect = true,
        PreferredFramework = "auto",

        ESX = {
            Enabled = false,
            ExportName = "esx",
            UseLegacy = false,
            Version = "1.10.0+"
        },

        QBCore = {
            Enabled = false,
            ExportName = "qb-core",
            Version = "1.0.0+"
        },

        vRP = {
            Enabled = false,
            ExportName = "vrp",
            Version = "1.0.0+"
        },

        Standalone = {
            Enabled = true, -- Default for development
            PlayerIdentifier = "license",
            AdminPermission = "admin"
        }
    },

    -- Relaxed performance settings for development
    Performance = {
        MaxProcessesToScan = 300,     -- Lower limit for testing
        MaxNetworkConnectionsToAnalyze = 500,
        MaxMemoryRegionsToCheck = 5000,

        ProcessTimeout = 3000,
        NetworkTimeout = 2000,
        MemoryTimeout = 5000,

        Advanced = {
            EnablePerformanceMonitoring = true,
            MonitorInterval = 30000, -- 30 seconds
            AdaptiveLimits = true,
            ResourceThresholds = {
                CPUUsage = 80,   -- Higher threshold
                MemoryUsage = 90, -- Higher threshold
                DiskUsage = 95    -- Higher threshold
            },
            AutoScaleDetection = true,
            MinScanInterval = 500,   -- Faster minimum
            MaxScanInterval = 30000  -- Shorter maximum
        },

        Memory = {
            EnableGarbageCollection = true,
            GCInterval = 60000,     -- 1 minute
            MaxMemoryUsage = 256,   -- 256MB limit
            EnableMemoryOptimization = true,
            MemoryOptimizationInterval = 300000 -- 5 minutes
        },

        Threads = {
            MinWorkerThreads = 1,    -- Fewer threads
            MaxWorkerThreads = 4,    -- Lower maximum
            QueueSize = 500,         -- Smaller queue
            ThreadTimeout = 10000    -- Shorter timeout
        }
    },

    -- Relaxed security for development
    Security = {
        EncryptSensitiveData = false,
        EncryptionKey = "",
        ConfigEncryption = false,

        AccessControl = {
            EnableIPWhitelist = false,
            AllowedIPs = {},
            EnableAPIToken = false,
            APIToken = "",
            RequireAuthentication = false
        },

        Audit = {
            Enabled = true,
            LogConfigChanges = true,
            LogAccessAttempts = true,
            LogAdminActions = true,
            RetentionDays = 30
        },

        RateLimiting = {
            Enabled = false, -- Disabled for development
            MaxRequestsPerMinute = 120,
            MaxRequestsPerHour = 2000,
            EnableBurstProtection = false,
            BurstLimit = 20
        }
    },

    -- Advanced development settings
    Advanced = {
        CacheEnabled = true,
        CacheTimeout = 15000, -- 15 seconds
        RateLimitingEnabled = false,
        MaxDetectionsPerMinute = 200,
        CustomSignaturesFile = nil,
        DiscordWebhooks = {
            Enabled = false,
            CriticalDetectionsURL = "",
            HighSeverityDetectionsURL = ""
        }
    },

    -- Development notification settings
    Notifications = {
        Enabled = true,

        PlayerNotifications = {
            Enabled = true,
            ProgressiveWarnings = true,
            MaxWarnings = 5, -- More warnings for development
            WarningCooldown = 30000, -- 30 seconds

            Messages = {
                FirstWarning = "~y~[DEV] Development mode: Detection logged for testing",
                FinalWarning = "~y~[DEV] Development mode: Multiple detections logged",
                DetectionAlert = "~y~[DEV] Development mode: High-risk detection logged",
                CooldownMessage = "~g~[DEV] Development mode: Please wait before testing again"
            }
        },

        AdminNotifications = {
            Enabled = true,
            ConsoleNotifications = true,
            AdminChatNotifications = false, -- Disabled for development
            PriorityAlertsOnly = false,

            PermissionLevels = {
                SuperAdmin = "antidump.dev.superadmin",
                Admin = "antidump.dev.admin",
                Moderator = "antidump.dev.moderator"
            }
        },

        Logging = {
            Enabled = true,
            LogLevel = "DEBUG",
            LogFile = "antidump_dev_notifications.log",
            MaxLogSize = 5 * 1024 * 1024,
            BackupLogs = true,
            MaxLogEntries = 5000,

            LogEvents = {
                Detections = true,
                CriticalDetections = true,
                SystemEvents = true,
                Errors = true,
                Notifications = true
            }
        },

        Discord = {
            Enabled = false, -- Disabled for development
            WebhookURL = "",
            CriticalDetectionsURL = "",
            HighSeverityDetectionsURL = "",
            Username = "Anti-Dump Dev",
            AvatarURL = "",
            RateLimitPerMinute = 5,
            RateLimitBurst = 2,
            Timeout = 3000,
            EnableEmbeds = true,
            EnableMentions = false,
            MentionRoleID = "",
            RetryAttempts = 2,
            RetryDelay = 500
        }
    }
}

-- Development-specific functions
function Config.DevelopmentMode()
    print("[Anti-Dump:DEV] Development mode configuration loaded")
    print("[Anti-Dump:DEV] Debug logging enabled")
    print("[Anti-Dump:DEV] Prevention systems disabled")
    print("[Anti-Dump:DEV] Relaxed detection thresholds active")

    -- Log development mode activation
    Citizen.CreateThread(function()
        Citizen.Wait(5000) -- Wait 5 seconds after startup
        print("[Anti-Dump:DEV] Development mode fully active")
        print("[Anti-Dump:DEV] Use 'antidump test' commands to test features")
    end)
end

-- Load development mode
Config.DevelopmentMode()

=======
-- FiveM Anti-Dump Development Configuration
-- Optimized settings for development and testing environments
-- Version: 2.0.0

Config = {
    -- Environment Configuration
    Environment = "development",
    DebugMode = true,
    DebugLevel = "DEBUG",
    AutoReload = true,

    -- System Information
    Version = "2.0.0",
    Author = "Anti-Dump Development Team",
    Description = "Development Environment Configuration",

    -- Detection Engine (Relaxed for development)
    Detection = {
        Enabled = true,
        ScanInterval = 10000, -- 10 seconds for development
        ProcessScanInterval = 5000, -- 5 seconds
        NetworkScanInterval = 15000, -- 15 seconds
        MemoryScanInterval = 20000, -- 20 seconds
        MaxConcurrentScans = 2, -- Reduced for development

        -- Enable all detection modules
        EnableProcessMonitor = true,
        EnableNetworkMonitor = true,
        EnableMemoryScanner = true,
        EnableSignatureScanning = true,
        EnableBehavioralAnalysis = true,
        EnableHeuristicDetection = true,

        -- Low sensitivity for development
        Sensitivity = "Low", -- Low, Medium, High, Ultra

        -- Lower thresholds for development testing
        Thresholds = {
            CriticalRiskScore = 95, -- Very high threshold
            HighRiskScore = 80,
            MediumRiskScore = 60,
            LowRiskScore = 30
        },

        -- Relaxed advanced thresholds
        AdvancedThresholds = {
            ProcessCountThreshold = 200, -- Higher limit
            MemoryUsageThreshold = 1000, -- 1GB
            NetworkConnectionThreshold = 100,
            SuspiciousProcessThreshold = 20,
            AnomalyDetectionThreshold = 90
        },

        -- All modules enabled for testing
        Modules = {
            ProcessMonitor = true,
            NetworkMonitor = true,
            MemoryScanner = true,
            SignatureScanner = true,
            BehavioralAnalyzer = true,
            HeuristicEngine = true
        },

        -- Performance settings for development
        Performance = {
            EnableAdaptiveScanning = true,
            AdaptiveScanReduction = 0.3, -- More aggressive reduction
            MaxCPUTimePerScan = 200, -- Higher limit
            MemoryLimitPerScan = 100 -- Higher limit in MB
        }
    },

    -- Prevention System (Disabled for development)
    Prevention = {
        Enabled = false, -- Disabled to prevent interference
        AutoTerminateProcesses = false,
        BlockNetworkPorts = false,
        MemoryProtection = false,
        AntiDebugging = false,
        HookPrevention = false,

        -- No response delays for development
        ResponseDelay = 100, -- Fast response
        EscalationDelay = 1000,
        CooldownPeriod = 5000, -- Short cooldown

        -- Process management disabled
        ProcessManagement = {
            ForceTerminate = false,
            KillProcessTree = false,
            TerminationTimeout = 1000,
            MaxRetries = 1
        },

        -- Network protection disabled
        NetworkProtection = {
            BlockSuspiciousPorts = false,
            PortBlockDuration = 30000, -- 30 seconds
            EnableIPBlocking = false,
            IPBlockDuration = 60000, -- 1 minute
            BlockedPorts = { 80, 443, 21, 22 },
            AllowedPorts = { 30120, 30110 }
        },

        -- Memory protection disabled
        MemoryProtection = {
            EnableAllocationProtection = false,
            EnableCodeInjectionPrevention = false,
            MonitorMemoryRegions = false,
            PreventDLLInjection = false,
            ScanFrequency = 30000 -- 30 seconds
        },

        -- Anti-debugging disabled
        AntiDebugging = {
            DetectDebuggers = false,
            DetectVirtualMachines = false,
            DetectSandboxes = false,
            PreventReverseEngineering = false,
            ObfuscationLevel = "Low"
        },

        -- Hook prevention disabled
        HookPrevention = {
            DetectAPIHooks = false,
            DetectInlineHooks = false,
            DetectIATHooks = false,
            RestoreHookedFunctions = false,
            HookDetectionFrequency = 60000 -- 1 minute
        }
    },

    -- Response Actions (Minimal for development)
    Responses = {
        OnDetection = {
            LogToConsole = true,
            LogToDatabase = false, -- Disabled for development
            NotifyAdmins = false,
            CreateServerLog = true
        },

        OnCriticalDetection = {
            LogToConsole = true,
            LogToDatabase = false,
            NotifyAdmins = false, -- No admin notifications
            TakeAutomaticAction = false, -- No auto-actions
            AutomaticActionDelay = 1000
        },

        OnHighSeverityDetection = {
            LogToConsole = true,
            LogToDatabase = false,
            NotifyAdmins = false,
            TakeAutomaticAction = false
        }
    },

    -- Expanded whitelist for development
    Whitelist = {
        Processes = {
            -- System processes
            "explorer.exe",
            "taskmgr.exe",
            "services.exe",
            "lsass.exe",
            "winlogon.exe",
            "csrss.exe",
            "smss.exe",
            "system",
            "conhost.exe",

            -- Development tools
            "code.exe", -- VS Code
            "devenv.exe", -- Visual Studio
            "notepad++.exe",
            "notepad.exe",
            "cmd.exe",
            "powershell.exe",
            "chrome.exe",
            "firefox.exe",
            "steam.exe",
            "teamspeak3.exe",
            "discord.exe",
            "teams.exe",
            "zoom.exe",
            "anydesk.exe",
            "teamviewer.exe",

            -- Gaming related
            "gta5.exe",
            "fiveM.exe",
            "fiveM_b2802.exe",
            "fiveM_b2944.exe",
            "socialclub.dll",
            "steamclient.dll",

            -- Testing tools
            "fiddler.exe",
            "wireshark.exe",
            "procmon.exe",
            "procmon64.exe"
        },

        NetworkConnections = {
            -- Development network ranges
            "127.0.0.0/8",      -- Localhost
            "10.0.0.0/8",       -- Private networks
            "172.16.0.0/12",    -- Private networks
            "192.168.0.0/16",   -- Private networks
            "localhost",
            "127.0.0.1"
        },

        MemoryThresholds = {
            -- Relaxed memory limits for development
            ["chrome.exe"] = 500,      -- 500MB for Chrome
            ["code.exe"] = 300,        -- 300MB for VS Code
            ["steam.exe"] = 200,       -- 200MB for Steam
            ["gta5.exe"] = 2048,       -- 2GB for GTA5
            ["fiveM.exe"] = 1024       -- 1GB for FiveM
        }
    },

    -- Enhanced logging for development
    Logging = {
        Enabled = true,
        LogLevel = "DEBUG",
        LogFile = "antidump_development.log",
        MaxLogSize = 5 * 1024 * 1024, -- 5MB
        BackupLogs = true,

        LogEvents = {
            SystemStart = true,
            SystemStop = true,
            Detections = true,
            CriticalDetections = true,
            ModuleStatus = true,
            Errors = true
        }
    },

    -- Database configuration for development
    Database = {
        Enabled = false, -- Disabled for development by default
        Type = "sqlite", -- SQLite for development
        Host = "localhost",
        Port = 3306,
        Database = "fivem_antidump_dev",
        Username = "root",
        Password = "",

        ConnectionTimeout = 5000,
        MaxConnections = 5,
        EnableConnectionPooling = true,
        ReconnectAttempts = 2,
        ReconnectDelay = 2000,

        Tables = {
            Detections = "antidump_detections_dev",
            Processes = "antidump_processes_dev",
            NetworkActivity = "antidump_network_activity_dev",
            Players = "antidump_players_dev",
            Incidents = "antidump_incidents_dev",
            Statistics = "antidump_statistics_dev"
        },

        Backup = {
            Enabled = false,
            Interval = 86400000,
            RetentionDays = 7,
            CompressionEnabled = true
        },

        Migration = {
            Enabled = true,
            Version = "2.0.0",
            AutoUpdate = true,
            BackupBeforeMigration = true
        }
    },

    -- Framework configuration for development
    Framework = {
        AutoDetect = true,
        PreferredFramework = "auto",

        ESX = {
            Enabled = false,
            ExportName = "esx",
            UseLegacy = false,
            Version = "1.10.0+"
        },

        QBCore = {
            Enabled = false,
            ExportName = "qb-core",
            Version = "1.0.0+"
        },

        vRP = {
            Enabled = false,
            ExportName = "vrp",
            Version = "1.0.0+"
        },

        Standalone = {
            Enabled = true, -- Default for development
            PlayerIdentifier = "license",
            AdminPermission = "admin"
        }
    },

    -- Relaxed performance settings for development
    Performance = {
        MaxProcessesToScan = 300,     -- Lower limit for testing
        MaxNetworkConnectionsToAnalyze = 500,
        MaxMemoryRegionsToCheck = 5000,

        ProcessTimeout = 3000,
        NetworkTimeout = 2000,
        MemoryTimeout = 5000,

        Advanced = {
            EnablePerformanceMonitoring = true,
            MonitorInterval = 30000, -- 30 seconds
            AdaptiveLimits = true,
            ResourceThresholds = {
                CPUUsage = 80,   -- Higher threshold
                MemoryUsage = 90, -- Higher threshold
                DiskUsage = 95    -- Higher threshold
            },
            AutoScaleDetection = true,
            MinScanInterval = 500,   -- Faster minimum
            MaxScanInterval = 30000  -- Shorter maximum
        },

        Memory = {
            EnableGarbageCollection = true,
            GCInterval = 60000,     -- 1 minute
            MaxMemoryUsage = 256,   -- 256MB limit
            EnableMemoryOptimization = true,
            MemoryOptimizationInterval = 300000 -- 5 minutes
        },

        Threads = {
            MinWorkerThreads = 1,    -- Fewer threads
            MaxWorkerThreads = 4,    -- Lower maximum
            QueueSize = 500,         -- Smaller queue
            ThreadTimeout = 10000    -- Shorter timeout
        }
    },

    -- Relaxed security for development
    Security = {
        EncryptSensitiveData = false,
        EncryptionKey = "",
        ConfigEncryption = false,

        AccessControl = {
            EnableIPWhitelist = false,
            AllowedIPs = {},
            EnableAPIToken = false,
            APIToken = "",
            RequireAuthentication = false
        },

        Audit = {
            Enabled = true,
            LogConfigChanges = true,
            LogAccessAttempts = true,
            LogAdminActions = true,
            RetentionDays = 30
        },

        RateLimiting = {
            Enabled = false, -- Disabled for development
            MaxRequestsPerMinute = 120,
            MaxRequestsPerHour = 2000,
            EnableBurstProtection = false,
            BurstLimit = 20
        }
    },

    -- Advanced development settings
    Advanced = {
        CacheEnabled = true,
        CacheTimeout = 15000, -- 15 seconds
        RateLimitingEnabled = false,
        MaxDetectionsPerMinute = 200,
        CustomSignaturesFile = nil,
        DiscordWebhooks = {
            Enabled = false,
            CriticalDetectionsURL = "",
            HighSeverityDetectionsURL = ""
        }
    },

    -- Development notification settings
    Notifications = {
        Enabled = true,

        PlayerNotifications = {
            Enabled = true,
            ProgressiveWarnings = true,
            MaxWarnings = 5, -- More warnings for development
            WarningCooldown = 30000, -- 30 seconds

            Messages = {
                FirstWarning = "~y~[DEV] Development mode: Detection logged for testing",
                FinalWarning = "~y~[DEV] Development mode: Multiple detections logged",
                DetectionAlert = "~y~[DEV] Development mode: High-risk detection logged",
                CooldownMessage = "~g~[DEV] Development mode: Please wait before testing again"
            }
        },

        AdminNotifications = {
            Enabled = true,
            ConsoleNotifications = true,
            AdminChatNotifications = false, -- Disabled for development
            PriorityAlertsOnly = false,

            PermissionLevels = {
                SuperAdmin = "antidump.dev.superadmin",
                Admin = "antidump.dev.admin",
                Moderator = "antidump.dev.moderator"
            }
        },

        Logging = {
            Enabled = true,
            LogLevel = "DEBUG",
            LogFile = "antidump_dev_notifications.log",
            MaxLogSize = 5 * 1024 * 1024,
            BackupLogs = true,
            MaxLogEntries = 5000,

            LogEvents = {
                Detections = true,
                CriticalDetections = true,
                SystemEvents = true,
                Errors = true,
                Notifications = true
            }
        },

        Discord = {
            Enabled = false, -- Disabled for development
            WebhookURL = "",
            CriticalDetectionsURL = "",
            HighSeverityDetectionsURL = "",
            Username = "Anti-Dump Dev",
            AvatarURL = "",
            RateLimitPerMinute = 5,
            RateLimitBurst = 2,
            Timeout = 3000,
            EnableEmbeds = true,
            EnableMentions = false,
            MentionRoleID = "",
            RetryAttempts = 2,
            RetryDelay = 500
        }
    }
}

-- Development-specific functions
function Config.DevelopmentMode()
    print("[Anti-Dump:DEV] Development mode configuration loaded")
    print("[Anti-Dump:DEV] Debug logging enabled")
    print("[Anti-Dump:DEV] Prevention systems disabled")
    print("[Anti-Dump:DEV] Relaxed detection thresholds active")

    -- Log development mode activation
    Citizen.CreateThread(function()
        Citizen.Wait(5000) -- Wait 5 seconds after startup
        print("[Anti-Dump:DEV] Development mode fully active")
        print("[Anti-Dump:DEV] Use 'antidump test' commands to test features")
    end)
end

-- Load development mode
Config.DevelopmentMode()

>>>>>>> 30c513c97c5cbc88fe8ab5df1beab9ce91fa25f3
return Config
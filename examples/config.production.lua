-- FiveM Anti-Dump Production Configuration
-- Optimized settings for production environments with strict security
-- Version: 2.0.0

Config = {
    -- Environment Configuration
    Environment = "production",
    DebugMode = false, -- Disabled for production
    DebugLevel = "WARN", -- Only warnings and errors
    AutoReload = true, -- Enable for configuration updates

    -- System Information
    Version = "2.0.0",
    Author = "Anti-Dump Production System",
    Description = "Production Environment Configuration",

    -- Detection Engine (Strict for production)
    Detection = {
        Enabled = true,
        ScanInterval = 3000, -- 3 seconds for production
        ProcessScanInterval = 2000, -- 2 seconds
        NetworkScanInterval = 5000, -- 5 seconds
        MemoryScanInterval = 8000, -- 8 seconds
        MaxConcurrentScans = 5, -- Higher for production

        -- Enable all detection modules
        EnableProcessMonitor = true,
        EnableNetworkMonitor = true,
        EnableMemoryScanner = true,
        EnableSignatureScanning = true,
        EnableBehavioralAnalysis = true,
        EnableHeuristicDetection = true,

        -- High sensitivity for production
        Sensitivity = "High", -- Low, Medium, High, Ultra

        -- Strict thresholds for production
        Thresholds = {
            CriticalRiskScore = 85, -- Lower threshold for security
            HighRiskScore = 65,
            MediumRiskScore = 45,
            LowRiskScore = 20
        },

        -- Strict advanced thresholds
        AdvancedThresholds = {
            ProcessCountThreshold = 50, -- Lower limit
            MemoryUsageThreshold = 300, -- 300MB
            NetworkConnectionThreshold = 30,
            SuspiciousProcessThreshold = 5,
            AnomalyDetectionThreshold = 70
        },

        -- All modules enabled for maximum security
        Modules = {
            ProcessMonitor = true,
            NetworkMonitor = true,
            MemoryScanner = true,
            SignatureScanner = true,
            BehavioralAnalyzer = true,
            HeuristicEngine = true
        },

        -- Performance settings optimized for production
        Performance = {
            EnableAdaptiveScanning = true,
            AdaptiveScanReduction = 0.7, -- Aggressive reduction under load
            MaxCPUTimePerScan = 50, -- Lower for performance
            MemoryLimitPerScan = 25 -- Lower memory usage
        }
    },

    -- Prevention System (Fully enabled for production)
    Prevention = {
        Enabled = true,
        AutoTerminateProcesses = true,
        BlockNetworkPorts = true,
        MemoryProtection = true,
        AntiDebugging = true,
        HookPrevention = true,

        -- Fast response times for production
        ResponseDelay = 500, -- Fast response
        EscalationDelay = 2000, -- Quick escalation
        CooldownPeriod = 60000, -- 1 minute cooldown

        -- Aggressive process management
        ProcessManagement = {
            ForceTerminate = true,
            KillProcessTree = true, -- Kill related processes
            TerminationTimeout = 3000,
            MaxRetries = 5
        },

        -- Strict network protection
        NetworkProtection = {
            BlockSuspiciousPorts = true,
            PortBlockDuration = 600000, -- 10 minutes
            EnableIPBlocking = true, -- Enable IP blocking
            IPBlockDuration = 1800000, -- 30 minutes
            BlockedPorts = {
                21, 22, 23, 25, 53, 80, 110, 143, 443, 993, 995,
                3389, 5900, 6667, 8080, 9000 -- Common suspicious ports
            },
            AllowedPorts = {
                30120, 30110 -- FiveM server ports only
            }
        },

        -- Full memory protection
        MemoryProtection = {
            EnableAllocationProtection = true,
            EnableCodeInjectionPrevention = true,
            MonitorMemoryRegions = true,
            PreventDLLInjection = true,
            ScanFrequency = 5000 -- 5 seconds
        },

        -- Maximum anti-debugging protection
        AntiDebugging = {
            DetectDebuggers = true,
            DetectVirtualMachines = true,
            DetectSandboxes = true,
            PreventReverseEngineering = true,
            ObfuscationLevel = "High"
        },

        -- Full hook prevention
        HookPrevention = {
            DetectAPIHooks = true,
            DetectInlineHooks = true,
            DetectIATHooks = true,
            RestoreHookedFunctions = true,
            HookDetectionFrequency = 5000 -- 5 seconds
        }
    },

    -- Response Actions (Aggressive for production)
    Responses = {
        OnDetection = {
            LogToConsole = true,
            LogToDatabase = true,
            NotifyAdmins = true,
            CreateServerLog = true
        },

        OnCriticalDetection = {
            LogToConsole = true,
            LogToDatabase = true,
            NotifyAdmins = true,
            TakeAutomaticAction = true, -- Enable auto-actions
            AutomaticActionDelay = 2000 -- 2 second delay
        },

        OnHighSeverityDetection = {
            LogToConsole = true,
            LogToDatabase = true,
            NotifyAdmins = true,
            TakeAutomaticAction = true
        }
    },

    -- Minimal whitelist for production security
    Whitelist = {
        Processes = {
            -- Only essential system processes
            "explorer.exe",
            "taskmgr.exe",
            "services.exe",
            "lsass.exe",
            "winlogon.exe",
            "csrss.exe",
            "smss.exe",
            "system",
            "conhost.exe",
            "svchost.exe",
            "spoolsv.exe",
            "dllhost.exe"
        },

        NetworkConnections = {
            -- Only necessary connections
            "127.0.0.1",
            "localhost"
        },

        MemoryThresholds = {
            -- Conservative memory limits
            ["steam.exe"] = 100,     -- 100MB for Steam
            ["gta5.exe"] = 512,      -- 512MB for GTA5
            ["fiveM.exe"] = 256      -- 256MB for FiveM
        }
    },

    -- Production logging (Balanced)
    Logging = {
        Enabled = true,
        LogLevel = "INFO",
        LogFile = "antidump_production.log",
        MaxLogSize = 50 * 1024 * 1024, -- 50MB
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

    -- Production database configuration
    Database = {
        Enabled = true,
        Type = "mysql",
        Host = "localhost",
        Port = 3306,
        Database = "fivem_antidump_prod",
        Username = "antidump_user",
        Password = "SECURE_PASSWORD_HERE", -- CHANGE THIS!

        ConnectionTimeout = 15000, -- Longer timeout
        MaxConnections = 20, -- Higher for production
        EnableConnectionPooling = true,
        ReconnectAttempts = 5,
        ReconnectDelay = 3000,

        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players",
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics"
        },

        Backup = {
            Enabled = true,
            Interval = 86400000, -- 24 hours
            RetentionDays = 90, -- 90 days retention
            CompressionEnabled = true
        },

        Migration = {
            Enabled = true,
            Version = "2.0.0",
            AutoUpdate = false, -- Manual updates in production
            BackupBeforeMigration = true
        }
    },

    -- Framework configuration for production
    Framework = {
        AutoDetect = true,
        PreferredFramework = "auto", -- Let system decide

        ESX = {
            Enabled = true,
            ExportName = "esx",
            UseLegacy = false,
            Version = "1.10.0+"
        },

        QBCore = {
            Enabled = true,
            ExportName = "qb-core",
            Version = "1.0.0+"
        },

        vRP = {
            Enabled = true,
            ExportName = "vrp",
            Version = "1.0.0+"
        },

        Standalone = {
            Enabled = false, -- Disable for production
            PlayerIdentifier = "license",
            AdminPermission = "admin"
        }
    },

    -- Production performance settings
    Performance = {
        MaxProcessesToScan = 1000,    -- Higher limits
        MaxNetworkConnectionsToAnalyze = 2000,
        MaxMemoryRegionsToCheck = 20000,

        ProcessTimeout = 8000,        -- Longer timeouts
        NetworkTimeout = 5000,
        MemoryTimeout = 15000,

        Advanced = {
            EnablePerformanceMonitoring = true,
            MonitorInterval = 60000, -- 1 minute
            AdaptiveLimits = true,
            ResourceThresholds = {
                CPUUsage = 60,   -- Lower threshold for performance
                MemoryUsage = 70, -- Lower threshold
                DiskUsage = 80    -- Lower threshold
            },
            AutoScaleDetection = true,
            MinScanInterval = 1000,   -- 1 second minimum
            MaxScanInterval = 10000   -- 10 second maximum
        },

        Memory = {
            EnableGarbageCollection = true,
            GCInterval = 300000,     -- 5 minutes
            MaxMemoryUsage = 1024,   -- 1GB limit
            EnableMemoryOptimization = true,
            MemoryOptimizationInterval = 600000 -- 10 minutes
        },

        Threads = {
            MinWorkerThreads = 3,    -- More threads
            MaxWorkerThreads = 12,   -- Higher maximum
            QueueSize = 2000,        -- Larger queue
            ThreadTimeout = 60000    -- Longer timeout
        }
    },

    -- Maximum security for production
    Security = {
        EncryptSensitiveData = true,
        EncryptionKey = "CHANGE_THIS_ENCRYPTION_KEY",
        ConfigEncryption = true,

        AccessControl = {
            EnableIPWhitelist = true,
            AllowedIPs = {
                "127.0.0.1",
                "localhost",
                -- Add your server IPs here
                -- "YOUR_SERVER_IP"
            },
            EnableAPIToken = true,
            APIToken = "SECURE_API_TOKEN_HERE", -- CHANGE THIS!
            RequireAuthentication = true
        },

        Audit = {
            Enabled = true,
            LogConfigChanges = true,
            LogAccessAttempts = true,
            LogAdminActions = true,
            RetentionDays = 365 -- 1 year retention
        },

        RateLimiting = {
            Enabled = true,
            MaxRequestsPerMinute = 30,  -- Strict limits
            MaxRequestsPerHour = 500,
            EnableBurstProtection = true,
            BurstLimit = 5 -- Very limited burst
        }
    },

    -- Advanced production settings
    Advanced = {
        CacheEnabled = true,
        CacheTimeout = 60000, -- 1 minute cache
        RateLimitingEnabled = true,
        MaxDetectionsPerMinute = 50, -- Lower limit
        CustomSignaturesFile = nil,

        -- Discord integration for production alerts
        DiscordWebhooks = {
            Enabled = true,
            CriticalDetectionsURL = "YOUR_CRITICAL_WEBHOOK_URL",
            HighSeverityDetectionsURL = "YOUR_HIGH_SEVERITY_WEBHOOK_URL"
        }
    },

    -- Production notification settings
    Notifications = {
        Enabled = true,

        PlayerNotifications = {
            Enabled = true,
            ProgressiveWarnings = true,
            MaxWarnings = 3, -- Strict limit
            WarningCooldown = 300000, -- 5 minutes

            Messages = {
                FirstWarning = "~r~[SECURITY] Suspicious activity detected. This is your first warning.",
                FinalWarning = "~r~[SECURITY] Final warning: Immediate action will be taken.",
                DetectionAlert = "~r~[SECURITY] Critical violation: You will be removed from the server.",
                CooldownMessage = "~y~[SECURITY] Please wait before performing this action again."
            }
        },

        AdminNotifications = {
            Enabled = true,
            ConsoleNotifications = true,
            AdminChatNotifications = true,
            PriorityAlertsOnly = false, -- All alerts in production

            PermissionLevels = {
                SuperAdmin = "antidump.superadmin",
                Admin = "antidump.admin",
                Moderator = "antidump.moderator"
            }
        },

        Logging = {
            Enabled = true,
            LogLevel = "INFO",
            LogFile = "antidump_notifications.log",
            MaxLogSize = 20 * 1024 * 1024, -- 20MB
            BackupLogs = true,
            MaxLogEntries = 20000,

            LogEvents = {
                Detections = true,
                CriticalDetections = true,
                SystemEvents = true,
                Errors = true,
                Notifications = false -- Disable notification logging
            }
        },

        Discord = {
            Enabled = true,
            WebhookURL = "YOUR_MAIN_WEBHOOK_URL",
            CriticalDetectionsURL = "YOUR_CRITICAL_WEBHOOK_URL",
            HighSeverityDetectionsURL = "YOUR_HIGH_SEVERITY_WEBHOOK_URL",
            Username = "Anti-Dump Security",
            AvatarURL = "YOUR_AVATAR_URL",
            RateLimitPerMinute = 15,
            RateLimitBurst = 3,
            Timeout = 10000, -- Longer timeout
            EnableEmbeds = true,
            EnableMentions = true,
            MentionRoleID = "YOUR_ADMIN_ROLE_ID",
            RetryAttempts = 5,
            RetryDelay = 2000
        }
    }
}

-- Production-specific functions
function Config.ProductionMode()
    print("[Anti-Dump:PROD] Production mode configuration loaded")
    print("[Anti-Dump:PROD] Maximum security settings active")
    print("[Anti-Dump:PROD] All prevention systems enabled")
    print("[Anti-Dump:PROD] Aggressive detection thresholds active")

    -- Validate production configuration
    if Config.Database.Password == "SECURE_PASSWORD_HERE" then
        print("[Anti-Dump:PROD] WARNING: Database password not changed from default!")
    end

    if Config.Security.APIToken == "SECURE_API_TOKEN_HERE" then
        print("[Anti-Dump:PROD] WARNING: API token not changed from default!")
    end

    if not Config.Notifications.Discord.Enabled then
        print("[Anti-Dump:PROD] WARNING: Discord notifications disabled")
    end

    -- Log production mode activation
    Citizen.CreateThread(function()
        Citizen.Wait(5000) -- Wait 5 seconds after startup
        print("[Anti-Dump:PROD] Production mode fully active")
        print("[Anti-Dump:PROD] Real-time monitoring enabled")
        print("[Anti-Dump:PROD] Automatic threat response active")
    end)
end

-- Load production mode
Config.ProductionMode()

return Config
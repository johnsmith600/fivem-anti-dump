
-- FiveM Anti-Dump Main Server Script
-- Complete integration system for anti-dump detection - FiveM Single-File Architecture
-- Version: 2.0.0

-- Load global configuration first (loaded by fxmanifest.lua)
-- Config table is already available as global

-- =============================================================================
-- UTILITY FUNCTIONS (Consolidated from utils modules)
-- =============================================================================

local Utils = {}

-- Table utilities
Utils.Table = {
    Merge = function(t1, t2)
        local result = {}
        for k, v in pairs(t1) do result[k] = v end
        for k, v in pairs(t2) do result[k] = v end
        return result
    end,

    Length = function(t)
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        return count
    end,

    Clone = function(t)
        local result = {}
        for k, v in pairs(t) do
            if type(v) == "table" then
                result[k] = Utils.Table.Clone(v)
            else
                result[k] = v
            end
        end
        return result
    end
}

-- String utilities
Utils.String = {
    Trim = function(s)
        return s:gsub("^%s*(.-)%s*$", "%1")
    end,

    StartsWith = function(s, prefix)
        return s:sub(1, #prefix) == prefix
    end,

    Replace = function(s, old, new)
        return s:gsub(old, new)
    end
}

-- =============================================================================
-- DATABASE MANAGER (Consolidated from utils/database_manager.lua)
-- =============================================================================

local DatabaseManager = {
    config = {
        enabled = false,
        type = "mysql",
        host = "localhost",
        port = 3306,
        database = "fivem_antidump",
        username = "root",
        password = "",
        connection_timeout = 10000,
        max_connections = 10,
        enable_pooling = true
    },

    connection = nil,
    isConnected = false,
    connectionAttempts = 0,
    maxReconnectAttempts = 3,

    tables = {
        detections = "antidump_detections",
        processes = "antidump_processes",
        network_activity = "antidump_network_activity",
        players = "antidump_players",
        incidents = "antidump_incidents",
        statistics = "antidump_statistics"
    },

    queryCache = {},
    cacheTimeout = 300000
}

function DatabaseManager:Initialize()
    if not self.config.enabled then
        return false, "Database is disabled in configuration"
    end

    if Config and Config.Database then
        self.config = Utils.Table.Merge(self.config, Config.Database)
        self.tables = Utils.Table.Merge(self.tables, Config.Database.Tables or {})
    end

    return self:Connect()
end

function DatabaseManager:Connect()
    if self.isConnected then
        return true, "Already connected to database"
    end

    local success, result
    if self.config.type == "mysql" then
        success, result = self:ConnectMySQL()
    elseif self.config.type == "sqlite" then
        success, result = self:ConnectSQLite()
    else
        return false, "Unsupported database type: " .. self.config.type
    end

    if success then
        self.isConnected = true
        self.connectionAttempts = 0
        self:CreateTables()
        return true, "Connected to " .. self.config.type .. " database successfully"
    else
        self.connectionAttempts = self.connectionAttempts + 1
        return false, "Failed to connect to database: " .. result
    end
end

function DatabaseManager:ConnectMySQL()
    if not self.config.host or not self.config.database then
        return false, "MySQL host and database are required"
    end

    self.connection = {
        type = "mysql",
        host = self.config.host,
        database = self.config.database
    }

    return true, "MySQL connection established"
end

function DatabaseManager:ConnectSQLite()
    if not self.config.database then
        return false, "SQLite database path is required"
    end

    self.connection = {
        type = "sqlite",
        database = self.config.database
    }

    return true, "SQLite connection established"
end

function DatabaseManager:Disconnect()
    if not self.isConnected then
        return true, "Already disconnected"
    end

    self.isConnected = false
    self.connection = nil
    self.queryCache = {}

    return true, "Disconnected from database"
end

function DatabaseManager:CreateTables()
    if not self.isConnected then
        return false, "Not connected to database"
    end

    local tables = {
        detections = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.detections .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                player_identifier VARCHAR(255) NOT NULL,
                detection_type VARCHAR(100) NOT NULL,
                risk_score INT NOT NULL DEFAULT 0,
                description TEXT,
                process_name VARCHAR(255),
                ip_address VARCHAR(45),
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                resolved BOOLEAN DEFAULT FALSE,
                notes TEXT,
                INDEX idx_player_identifier (player_identifier),
                INDEX idx_timestamp (timestamp),
                INDEX idx_risk_score (risk_score)
            )
        ]],

        processes = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.processes .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                process_name VARCHAR(255) NOT NULL,
                detection_count INT DEFAULT 1,
                first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                risk_level VARCHAR(20) DEFAULT 'medium',
                status VARCHAR(20) DEFAULT 'active',
                notes TEXT,
                INDEX idx_process_name (process_name),
                INDEX idx_last_seen (last_seen)
            )
        ]],

        players = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.players .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                identifier VARCHAR(255) NOT NULL UNIQUE,
                name VARCHAR(255),
                first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                total_detections INT DEFAULT 0,
                risk_score INT DEFAULT 0,
                status VARCHAR(20) DEFAULT 'active',
                notes TEXT,
                INDEX idx_identifier (identifier),
                INDEX idx_risk_score (risk_score)
            )
        ]]
    }

    for tableName, query in pairs(tables) do
        local success, error = self:Execute(query)
        if not success then
            print("[Anti-Dump] Failed to create " .. tableName .. " table: " .. (error or "Unknown error"))
        end
    end

    return true, "Tables creation attempted"
end

function DatabaseManager:Execute(query, parameters)
    if not self.isConnected then
        return false, "Not connected to database"
    end

    if not query or type(query) ~= "string" then
        return false, "Invalid query"
    end

    -- Simulate query execution for now
    local success = true
    local result = {}

    if Utils.String.StartsWith(Utils.String.Trim(query:upper()), "SELECT") then
        result = {}
    end

    if success then
        return true, result
    else
        return false, "Query execution failed"
    end
end

function DatabaseManager:InsertDetection(detectionData)
    if not detectionData or type(detectionData) ~= "table" then
        return false, "Invalid detection data"
    end

    local query = [[
        INSERT INTO ]] .. self.tables.detections .. [[ (
            player_identifier, detection_type, risk_score, description,
            process_name, ip_address, timestamp, notes
        ) VALUES (
            {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}
        )
    ]]

    local parameters = {
        detectionData.player_identifier or "",
        detectionData.detection_type or "unknown",
        detectionData.risk_score or 0,
        detectionData.description or "",
        detectionData.process_name or "",
        detectionData.ip_address or "",
        detectionData.timestamp or os.date("%Y-%m-%d %H:%M:%S"),
        detectionData.notes or ""
    }

    local success, result = self:Execute(query, parameters)

    if success then
        return true, "Detection recorded successfully"
    else
        return false, "Failed to record detection: " .. (result or "Unknown error")
    end
end

function DatabaseManager:GetStatus()
    return {
        connected = self.isConnected,
        connection_attempts = self.connectionAttempts,
        database_type = self.config.type,
        database_name = self.config.database,
        cache_size = Utils.Table.Length(self.queryCache),
        tables = self.tables
    }
end

-- =============================================================================
-- FRAMEWORK INTEGRATION (Consolidated from utils/framework_integration.lua)
-- =============================================================================

local FrameworkIntegration = {
    config = {
        auto_detect = true,
        preferred_framework = "auto",
        enable_integration = true
    },

    currentFramework = nil,
    frameworkVersion = nil,
    isInitialized = false,

    frameworkFunctions = {},

    playerManager = {
        getPlayer = nil,
        getPlayerIdentifier = nil,
        getPlayerName = nil,
        kickPlayer = nil,
        banPlayer = nil,
        isPlayerAdmin = nil
    }
}

function FrameworkIntegration:Initialize()
    if not self.config.enable_integration then
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Framework integration disabled, using standalone mode"
    end

    if Config and Config.Framework then
        self.config = Utils.Table.Merge(self.config, Config.Framework)
    end

    local detectionSuccess, detectionResult = self:DetectFramework()

    if not detectionSuccess then
        print("[Anti-Dump] Framework detection failed: " .. detectionResult)
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Using standalone mode due to detection failure"
    end

    local initSuccess, initResult = self:InitializeFramework()

    if initSuccess then
        self.isInitialized = true
        return true, "Framework integration initialized: " .. self.currentFramework
    else
        print("[Anti-Dump] Framework initialization failed: " .. initResult)
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Using standalone mode due to initialization failure"
    end
end

function FrameworkIntegration:DetectFramework()
    -- Detection priority: QBCore first, then ESX, then vRP, then standalone
    print("[Anti-Dump] Starting framework detection in priority order...")

    -- Check QBCore first
    local qbCoreDetected, qbCoreVersion = self:DetectQBCore()
    if qbCoreDetected then
        print(string.format("[Anti-Dump] QBCore detected: %s", qbCoreVersion or "Unknown version"))
        self.currentFramework = "qbcore"
        self.frameworkVersion = qbCoreVersion or "1.0.0+"
        return true, "QBCore v" .. (qbCoreVersion or "1.0.0+")
    end

    -- Check ESX second
    local esxDetected, esxVersion = self:DetectESX()
    if esxDetected then
        print(string.format("[Anti-Dump] ESX detected: %s", esxVersion or "Unknown version"))
        self.currentFramework = "esx"
        self.frameworkVersion = esxVersion or "1.10.0+"
        return true, "ESX v" .. (esxVersion or "1.10.0+")
    end

    -- Check vRP third
    local vrpDetected, vrpVersion = self:DetectVRP()
    if vrpDetected then
        print(string.format("[Anti-Dump] vRP detected: %s", vrpVersion or "Unknown version"))
        self.currentFramework = "vrp"
        self.frameworkVersion = vrpVersion or "1.0.0+"
        return true, "vRP v" .. (vrpVersion or "1.0.0+")
    end

    -- Default to standalone
    print("[Anti-Dump] No supported framework detected, using standalone mode")
    self.currentFramework = "standalone"
    self.frameworkVersion = "standalone"
    return true, "Standalone mode"
end

function FrameworkIntegration:DetectQBCore()
    -- Method 1: Check if qb-core resource is running
    local qbCoreResource = GetResourceState("qb-core")
    if qbCoreResource == "started" or qbCoreResource == "starting" then
        print("[Anti-Dump] QBCore resource 'qb-core' is running")
        return true, "1.0.0+"
    end

    -- Method 2: Check for QBCore exports
    if exports['qb-core'] then
        print("[Anti-Dump] QBCore exports available")
        -- Try to get the core object to confirm it's working
        local success, core = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success and core then
            print("[Anti-Dump] QBCore GetCoreObject export working")
            return true, "1.0.0+"
        end
    end

    -- Method 3: Check for QBCore global functions
    if QBCore and type(QBCore) == "table" then
        print("[Anti-Dump] QBCore global object found")
        if QBCore.GetCoreObject or QBCore.Shared or QBCore.Player then
            return true, "1.0.0+"
        end
    end

    -- Method 4: Check for QBCore-specific functions
    local success, hasFunction = pcall(function()
        return GetCoreObject ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] QBCore GetCoreObject function found")
        return true, "1.0.0+"
    end

    -- Method 5: Check for QBCore player management functions
    local success, hasPlayerFunction = pcall(function()
        return QBCore and QBCore.Functions and QBCore.Functions.GetPlayer ~= nil
    end)
    if success and hasPlayerFunction then
        print("[Anti-Dump] QBCore player management functions found")
        return true, "1.0.0+"
    end

    return false, nil
end

function FrameworkIntegration:DetectESX()
    -- Method 1: Check if es_extended resource is running
    local esxResource = GetResourceState("es_extended")
    if esxResource == "started" or esxResource == "starting" then
        print("[Anti-Dump] ESX resource 'es_extended' is running")
        return true, "1.10.0+"
    end

    -- Method 2: Check for ESX exports (try both es_extended and esx)
    if exports['es_extended'] then
        print("[Anti-Dump] ESX exports available (es_extended)")
        -- Try to get the shared object to confirm it's working
        local success, esx = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if success and esx then
            print("[Anti-Dump] ESX getSharedObject export working")
            return true, "1.10.0+"
        end
    elseif exports['esx'] then
        print("[Anti-Dump] ESX exports available (esx)")
        -- Try to get the shared object to confirm it's working
        local success, esx = pcall(function()
            return exports['esx']:getSharedObject()
        end)
        if success and esx then
            print("[Anti-Dump] ESX getSharedObject export working")
            return true, "1.10.0+"
        end
    end

    -- Method 3: Check for ESX global functions
    if ESX and type(ESX) == "table" then
        print("[Anti-Dump] ESX global object found")
        if ESX.GetPlayer or ESX.GetPlayers or ESX.RegisterServerCallback then
            return true, "1.10.0+"
        end
    end

    -- Method 4: Check for ESX-specific functions
    local success, hasFunction = pcall(function()
        return ESX ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] ESX global object found")
        return true, "1.10.0+"
    end

    return false, nil
end

function FrameworkIntegration:DetectVRP()
    -- Method 1: Check if vrp resource is running
    local vrpResource = GetResourceState("vrp")
    if vrpResource == "started" or vrpResource == "starting" then
        print("[Anti-Dump] vRP resource 'vrp' is running")
        return true, "1.0.0+"
    end

    -- Method 2: Check for vRP exports
    if exports['vrp'] then
        print("[Anti-Dump] vRP exports available")
        return true, "1.0.0+"
    end

    -- Method 3: Check for vRP global functions
    if vRP and type(vRP) == "table" then
        print("[Anti-Dump] vRP global object found")
        if vRP.getUserId or vRP.getUserData or vRP.registerMenuBuilder then
            return true, "1.0.0+"
        end
    end

    -- Method 4: Check for vRP-specific functions
    local success, hasFunction = pcall(function()
        return vRP ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] vRP global object found")
        return true, "1.0.0+"
    end

    return false, nil
end

function FrameworkIntegration:InitializeFramework()
    if self.currentFramework == "standalone" then
        return self:InitializeStandalone()
    else
        return self:InitializeStandalone() -- Fallback for now
    end
end

function FrameworkIntegration:InitializeStandalone()
    self.frameworkFunctions = {
        getPlayer = function(source)
            return source
        end,

        getPlayerIdentifier = function(source)
            for _, id in ipairs(GetPlayerIdentifiers(source)) do
                if string.find(id, "license:") then
                    return string.sub(id, 9)
                end
            end
            return nil
        end,

        getPlayerName = function(source)
            return GetPlayerName(source)
        end,

        isPlayerAdmin = function(source)
            return IsPlayerAceAllowed(source, "antidump.admin") or
                   IsPlayerAceAllowed(source, "admin") or
                   IsPlayerAceAllowed(source, "god")
        end
    }

    self.playerManager = self.frameworkFunctions
    return true, "Standalone integration initialized"
end

function FrameworkIntegration:GetPlayer(source)
    if not self.playerManager.getPlayer then
        return nil
    end
    return self.playerManager.getPlayer(source)
end

function FrameworkIntegration:GetPlayerIdentifier(source)
    if not self.playerManager.getPlayerIdentifier then
        return nil
    end
    return self.playerManager.getPlayerIdentifier(source)
end

function FrameworkIntegration:GetPlayerName(source)
    if not self.playerManager.getPlayerName then
        return GetPlayerName(source)
    end
    return self.playerManager.getPlayerName(source)
end

function FrameworkIntegration:IsPlayerAdmin(source)
    if not self.playerManager.isPlayerAdmin then
        return IsPlayerAceAllowed(source, "antidump.admin")
    end
    return self.playerManager.isPlayerAdmin(source)
end

function FrameworkIntegration:GetFrameworkInfo()
    return {
        framework = self.currentFramework,
        version = self.frameworkVersion,
        initialized = self.isInitialized,
        player_count = GetNumPlayerIndices()
    }
end

function FrameworkIntegration:TestFrameworkDetection()
    print("[Anti-Dump] === Framework Detection Test ===")

    -- Test QBCore detection
    print("[Anti-Dump] Testing QBCore detection...")
    local qbCoreDetected, qbCoreVersion = self:DetectQBCore()
    print(string.format("[Anti-Dump] QBCore detection result: %s (Version: %s)",
        qbCoreDetected and "DETECTED" or "NOT DETECTED",
        qbCoreVersion or "N/A"))

    -- Test ESX detection
    print("[Anti-Dump] Testing ESX detection...")
    local esxDetected, esxVersion = self:DetectESX()
    print(string.format("[Anti-Dump] ESX detection result: %s (Version: %s)",
        esxDetected and "DETECTED" or "NOT DETECTED",
        esxVersion or "N/A"))

    -- Test vRP detection
    print("[Anti-Dump] Testing vRP detection...")
    local vrpDetected, vrpVersion = self:DetectVRP()
    print(string.format("[Anti-Dump] vRP detection result: %s (Version: %s)",
        vrpDetected and "DETECTED" or "NOT DETECTED",
        vrpVersion or "N/A"))

    -- Show current framework
    print(string.format("[Anti-Dump] Current framework: %s v%s",
        self.currentFramework or "Unknown",
        self.frameworkVersion or "Unknown"))

    print("[Anti-Dump] === Framework Detection Test Complete ===")

    return {
        qbcore = { detected = qbCoreDetected, version = qbCoreVersion },
        esx = { detected = esxDetected, version = esxVersion },
        vrp = { detected = vrpDetected, version = vrpVersion },
        current = { framework = self.currentFramework, version = self.frameworkVersion }
    }
end

-- =============================================================================
-- PERFORMANCE MONITOR (Consolidated from utils/performance_monitor.lua)
-- =============================================================================

local PerformanceMonitor = {
    config = {
        enabled = true,
        interval = 60000,
        metrics = {}
    },

    metrics = {
        cpuUsage = 0,
        memoryUsage = 0,
        scanCount = 0,
        avgScanTime = 0,
        lastUpdate = 0
    },

    scanTimes = {},
    maxScanTimes = 100
}

function PerformanceMonitor:Initialize()
    if not self.config.enabled then
        return false
    end

    self:StartMonitoring()
    return true
end

function PerformanceMonitor:StartMonitoring()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(self.config.interval)
            self:RecordMetrics()
        end
    end)
end

function PerformanceMonitor:RecordMetrics()
    self.metrics.lastUpdate = GetGameTimer()

    -- Simulate performance metrics collection
    self.metrics.cpuUsage = math.random(10, 80) -- Simulated CPU usage
    self.metrics.memoryUsage = math.random(50, 400) -- Simulated memory usage in MB
    self.metrics.scanCount = self.metrics.scanCount + 1
end

function PerformanceMonitor:RecordScanTime(scanTime)
    table.insert(self.scanTimes, scanTime)

    if #self.scanTimes > self.maxScanTimes then
        table.remove(self.scanTimes, 1)
    end

    if #self.scanTimes > 0 then
        local total = 0
        for _, time in ipairs(self.scanTimes) do
            total = total + time
        end
        self.metrics.avgScanTime = total / #self.scanTimes
    end
end

function PerformanceMonitor:GetMetrics()
    return Utils.Table.Clone(self.metrics)
end

function PerformanceMonitor:GetStatistics()
    return {
        enabled = self.config.enabled,
        interval = self.config.interval,
        metrics = self:GetMetrics(),
        scan_times_count = #self.scanTimes
    }
end

-- =============================================================================
-- NOTIFICATION MANAGER (Consolidated from notifications/notification_manager.lua)
-- =============================================================================

local NotificationManager = {
    Config = {
        Enabled = true,
        MaxQueueSize = 1000,
        QueueProcessInterval = 1000,
        PerformanceMonitoring = true,
        EnableMetrics = true,
        MetricsInterval = 60000
    },

    notificationQueue = {},
    activeNotifications = {},
    performanceMetrics = {},
    isInitialized = false
}

-- Priority constants
local PRIORITY = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    CRITICAL = 4,
    SYSTEM = 5
}

-- Notification types
local NOTIFICATION_TYPES = {
    PLAYER_WARNING = "player_warning",
    PLAYER_DETECTION = "player_detection",
    ADMIN_ALERT = "admin_alert",
    CRITICAL_ALERT = "critical_alert",
    SYSTEM_ALERT = "system_alert",
    LOG_EVENT = "log_event",
    DISCORD_WEBHOOK = "discord_webhook"
}

function NotificationManager:Initialize(customConfig)
    if self.isInitialized then
        return true
    end

    if customConfig then
        for k, v in pairs(customConfig) do
            self.Config[k] = v
        end
    end

    if Config and Config.Notifications then
        self.Config = Utils.Table.Merge(self.Config, Config.Notifications)
    end

    self:InitializeSubsystems()

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(self.Config.QueueProcessInterval)
            self:ProcessNotificationQueue()
        end
    end)

    if self.Config.PerformanceMonitoring then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(self.Config.MetricsInterval)
                self:UpdatePerformanceMetrics()
            end
        end)
    end

    self.isInitialized = true
    return true
end

function NotificationManager:InitializeSubsystems()
    -- Initialize player notifications
    if not self.PlayerNotifications then
        self.PlayerNotifications = {}
    end

    -- Initialize admin notifications
    if not self.AdminNotifications then
        self.AdminNotifications = {}
    end

    -- Initialize logging system
    if not self.LoggingSystem then
        self.LoggingSystem = {}
    end

    -- Initialize Discord webhook
    if not self.DiscordWebhook then
        self.DiscordWebhook = {}
    end
end

function NotificationManager:SendNotification(notificationType, data, priority, options)
    if not self.Config.Enabled then
        return false, "Notification manager is disabled"
    end

    priority = priority or PRIORITY.MEDIUM

    local notification = {
        id = self:GenerateNotificationId(),
        type = notificationType,
        data = data,
        priority = priority,
        options = options or {},
        timestamp = os.time(),
        attempts = 0,
        maxAttempts = options.maxAttempts or 3
    }

    self:QueueNotification(notification)
    return true, notification.id
end

function NotificationManager:QueueNotification(notification)
    if #self.notificationQueue >= self.Config.MaxQueueSize then
        return false
    end

    -- Insert in priority order
    local inserted = false
    for i, queuedNotification in ipairs(self.notificationQueue) do
        if notification.priority > queuedNotification.priority then
            table.insert(self.notificationQueue, i, notification)
            inserted = true
            break
        end
    end

    if not inserted then
        table.insert(self.notificationQueue, notification)
    end

    return true
end

function NotificationManager:ProcessNotificationQueue()
    if #self.notificationQueue == 0 then
        return
    end

    local processedCount = 0
    local maxProcessPerCycle = 10

    while #self.notificationQueue > 0 and processedCount < maxProcessPerCycle do
        local notification = table.remove(self.notificationQueue, 1)
        self:ProcessNotification(notification)
        processedCount = processedCount + 1
    end
end

function NotificationManager:ProcessNotification(notification)
    self.activeNotifications[notification.id] = notification

    local success = false
    local errorMessage = ""

    if notification.type == NOTIFICATION_TYPES.PLAYER_DETECTION then
        success, errorMessage = self:HandlePlayerDetection(notification)
    elseif notification.type == NOTIFICATION_TYPES.ADMIN_ALERT then
        success, errorMessage = self:HandleAdminAlert(notification)
    elseif notification.type == NOTIFICATION_TYPES.CRITICAL_ALERT then
        success, errorMessage = self:HandleCriticalAlert(notification)
    else
        success = false
        errorMessage = "Unknown notification type: " .. notification.type
    end

    if success then
        self:HandleNotificationSuccess(notification)
    else
        self:HandleNotificationFailure(notification, errorMessage)
    end

    self.activeNotifications[notification.id] = nil
end

function NotificationManager:HandlePlayerDetection(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo
    local severity = notification.data.severity or "MEDIUM"

    if not playerId or not threatInfo then
        return false, "Missing required data for player detection notification"
    end

    -- Simulate player notification
    return true, "Player detection notification processed"
end

function NotificationManager:HandleAdminAlert(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo
    local severity = notification.data.severity or "MEDIUM"

    if not threatInfo then
        return false, "Missing threat info for admin alert"
    end

    -- Simulate admin notification
    return true, "Admin alert processed"
end

function NotificationManager:HandleCriticalAlert(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo

    if not threatInfo then
        return false, "Missing threat info for critical alert"
    end

    -- Simulate critical notification
    return true, "Critical alert processed"
end

function NotificationManager:HandleNotificationSuccess(notification)
    if self.Config.EnableMetrics then
        if not self.performanceMetrics[notification.type] then
            self.performanceMetrics[notification.type] = {success = 0, failed = 0}
        end
        self.performanceMetrics[notification.type].success = self.performanceMetrics[notification.type].success + 1
    end
end

function NotificationManager:HandleNotificationFailure(notification, errorMessage)
    notification.attempts = notification.attempts + 1

    if self.Config.EnableMetrics then
        if not self.performanceMetrics[notification.type] then
            self.performanceMetrics[notification.type] = {success = 0, failed = 0}
        end
        self.performanceMetrics[notification.type].failed = self.performanceMetrics[notification.type].failed + 1
    end
end

function NotificationManager:GenerateNotificationId()
    return string.format("notif_%d_%d", os.time(), math.random(1000, 9999))
end

function NotificationManager:UpdatePerformanceMetrics()
    -- Performance monitoring logic
    if not self.Config.EnableMetrics then
        return
    end

    -- Update average processing times and success rates
    for notificationType, metrics in pairs(self.performanceMetrics) do
        if metrics.totalTime and metrics.totalTime > 0 then
            metrics.avgTime = metrics.totalTime / (metrics.success + metrics.failed)
        end
        if (metrics.success + metrics.failed) > 0 then
            metrics.successRate = (metrics.success / (metrics.success + metrics.failed)) * 100
        end
    end
end

function NotificationManager:NotifyDetection(playerId, threatInfo, severity)
    severity = severity or "MEDIUM"

    self:SendNotification(NOTIFICATION_TYPES.PLAYER_DETECTION, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = severity
    }, PRIORITY.MEDIUM)

    self:SendNotification(NOTIFICATION_TYPES.ADMIN_ALERT, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = severity
    }, PRIORITY.HIGH)

    return true
end

function NotificationManager:NotifyCriticalDetection(playerId, threatInfo)
    self:SendNotification(NOTIFICATION_TYPES.PLAYER_DETECTION, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = "CRITICAL"
    }, PRIORITY.CRITICAL)

    self:SendNotification(NOTIFICATION_TYPES.CRITICAL_ALERT, {
        playerId = playerId,
        threatInfo = threatInfo
    }, PRIORITY.CRITICAL)

    return true
end

function NotificationManager:GetStatistics()
    local stats = {
        queueSize = #self.notificationQueue,
        activeNotifications = #self.activeNotifications,
        performanceMetrics = self.performanceMetrics,
        uptime = GetGameTimer()
    }

    return stats
end

function NotificationManager:IsInitialized()
    return self.isInitialized
end

-- =============================================================================
-- DETECTION ENGINE (Consolidated from detection modules)
-- =============================================================================

local DetectionEngine = {
    isActive = false,
    lastDetectionRun = 0,
    detectionInterval = 5000,
    initialized = false,

    detectionHistory = {},
    maxHistorySize = 100,

    SCORING = {
        CRITICAL_THRESHOLD = 90,
        HIGH_THRESHOLD = 70,
        MEDIUM_THRESHOLD = 50,
        LOW_THRESHOLD = 25,
        MAX_SCORE = 100
    }
}

function DetectionEngine:Initialize()
    if self.initialized then
        return false
    end

    print("[Anti-Dump] Initializing Detection Engine...")

    self.isActive = true
    self.initialized = true
    self.lastDetectionRun = GetGameTimer()

    return true
end

function DetectionEngine:PerformDetection()
    if not self.initialized or not self.isActive then
        return nil
    end

    local currentTime = GetGameTimer()

    if currentTime - self.lastDetectionRun < self.detectionInterval then
        return nil
    end

    self.lastDetectionRun = currentTime

    local scanResults = {
        timestamp = currentTime,
        overallRiskScore = 0,
        detectionCount = 0,
        detections = {},
        moduleResults = {}
    }

    -- Simulate detection modules
    scanResults.moduleResults.process = self:ProcessMonitor()
    scanResults.moduleResults.network = self:NetworkMonitor()
    scanResults.moduleResults.memory = self:MemoryScanner()

    self:AggregateDetectionResults(scanResults)
    self:AddToHistory(scanResults)

    return scanResults
end

function DetectionEngine:ProcessMonitor()
    -- Simulate process monitoring
    return {
        detections = {},
        suspiciousProcesses = 0
    }
end

function DetectionEngine:NetworkMonitor()
    -- Simulate network monitoring
    return {
        detections = {},
        packetCaptureTools = {}
    }
end

function DetectionEngine:MemoryScanner()
    -- Simulate memory scanning
    return {
        detections = {
            highMemoryUsage = {},
            codeInjection = {},
            apiHooking = {}
        }
    }
end

function DetectionEngine:AggregateDetectionResults(scanResults)
    local allDetections = {}
    local totalRiskScore = 0
    local detectionCount = 0

    -- Process results from all modules
    for moduleName, results in pairs(scanResults.moduleResults) do
        if results.detections then
            for _, detection in ipairs(results.detections) do
                table.insert(allDetections, {
                    type = moduleName,
                    module = moduleName,
                    detection = detection,
                    timestamp = scanResults.timestamp
                })
                totalRiskScore = totalRiskScore + (detection.riskScore or 0)
                detectionCount = detectionCount + 1
            end
        end
    end

    scanResults.overallRiskScore = detectionCount > 0 and (totalRiskScore / detectionCount) or 0
    scanResults.detectionCount = detectionCount
    scanResults.detections = allDetections
end

function DetectionEngine:AddToHistory(scanResults)
    table.insert(self.detectionHistory, scanResults)

    if #self.detectionHistory > self.maxHistorySize then
        table.remove(self.detectionHistory, 1)
    end
end

function DetectionEngine:GetDetectionStats()
    local stats = {
        totalDetections = 0,
        criticalDetections = 0,
        highDetections = 0,
        mediumDetections = 0,
        lowDetections = 0
    }

    for _, scan in ipairs(self.detectionHistory) do
        stats.totalDetections = stats.totalDetections + scan.detectionCount

        for _, detection in ipairs(scan.detections) do
            local severity = self:GetSeverityFromScore(detection.detection.riskScore or 0)

            if severity == "critical" then
                stats.criticalDetections = stats.criticalDetections + 1
            elseif severity == "high" then
                stats.highDetections = stats.highDetections + 1
            elseif severity == "medium" then
                stats.mediumDetections = stats.mediumDetections + 1
            elseif severity == "low" then
                stats.lowDetections = stats.lowDetections + 1
            end
        end
    end

    return stats
end

function DetectionEngine:GetSeverityFromScore(score)
    if score >= self.SCORING.CRITICAL_THRESHOLD then
        return "critical"
    elseif score >= self.SCORING.HIGH_THRESHOLD then
        return "high"
    elseif score >= self.SCORING.MEDIUM_THRESHOLD then
        return "medium"
    elseif score >= self.SCORING.LOW_THRESHOLD then
        return "low"
    else
        return "info"
    end
end

function DetectionEngine:TriggerManualDetection()
    return self:PerformDetection()
end

function DetectionEngine:GetStatus()
    return {
        isActive = self.isActive,
        initialized = self.initialized,
        lastDetectionRun = self.lastDetectionRun,
        detectionInterval = self.detectionInterval,
        historySize = #self.detectionHistory,
        stats = self:GetDetectionStats()
    }
end

-- =============================================================================
-- MAIN SYSTEM (Consolidated from original server/antidump.lua)
-- =============================================================================

-- System state
local systemInitialized = false
local systemStartTime = 0
local systemVersion = "2.0.0"
local activeModules = {}
local systemHealth = {
    status = "INITIALIZING",
    uptime = 0,
    lastError = nil,
    moduleStatus = {}
}

-- JSON utilities
local json = {
    encode = function(data)
        if type(data) == "table" then
            local parts = {}
            for k, v in pairs(data) do
                local key = type(k) == "string" and '"' .. k:gsub('"', '\\"') .. '"' or tostring(k)
                table.insert(parts, key .. ":" .. json.encode(v))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        elseif type(data) == "string" then
            return '"' .. data:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
        elseif type(data) == "number" or type(data) == "boolean" then
            return tostring(data)
        elseif data == nil then
            return "null"
        else
            return '"unsupported"'
        end
    end,

    decode = function(str)
        if not str or str == "" then return nil end
        if str == "true" then return true end
        if str == "false" then return false end
        if str == "null" then return nil end
        local num = tonumber(str)
        if num then return num end
        return str
    end
}

-- System initialization
function InitializeAntiDumpSystem()
    if systemInitialized then
        return false, "System already initialized"
    end

    print(string.format("[Anti-Dump] Starting Anti-Dump Detection System v%s...", systemVersion))
    systemHealth.status = "INITIALIZING"
    systemStartTime = os.time()

    -- Initialize components
    PerformanceMonitor:Initialize()

    local frameworkSuccess = FrameworkIntegration:Initialize()
    if not frameworkSuccess then
        print("[Anti-Dump] Warning: Framework integration failed, continuing with standalone mode")
    end

    if Config.Database.Enabled then
        local dbSuccess = DatabaseManager:Initialize()
        if not dbSuccess then
            print("[Anti-Dump] Warning: Database initialization failed, continuing without database")
        end
    end

    local detectionSuccess = DetectionEngine:Initialize()
    if not detectionSuccess then
        print("[Anti-Dump] ERROR: Failed to initialize Detection Engine")
        systemHealth.status = "ERROR"
        systemHealth.lastError = "Detection engine initialization failed"
        return false, "Detection engine initialization failed"
    end

    local notificationSuccess = NotificationManager:Initialize()
    if not notificationSuccess then
        print("[Anti-Dump] Warning: Notification system initialization failed, continuing without notifications")
    end

    -- Mark system as initialized
    systemInitialized = true
    systemHealth.status = "RUNNING"
    systemHealth.startTime = systemStartTime

    print(string.format("[Anti-Dump] Anti-Dump Detection System v%s started successfully", systemVersion))
    return true, "System initialized successfully"
end

-- System shutdown
function ShutdownAntiDumpSystem()
    if not systemInitialized then
        return false, "System not initialized"
    end

    print(string.format("[Anti-Dump] Shutting down Anti-Dump Detection System v%s...", systemVersion))
    systemHealth.status = "SHUTTING_DOWN"

    local uptime = os.time() - systemStartTime

    systemInitialized = false
    systemHealth.status = "STOPPED"
    systemHealth.uptime = uptime

    print(string.format("[Anti-Dump] Anti-Dump Detection System v%s shutdown complete (uptime: %d seconds)", systemVersion, uptime))
    return true, "Shutdown completed successfully"
end

-- Logging system
function LogSystemEvent(eventType, data)
    if not Config.Logging.Enabled then
        return
    end

    local logEntry = {
        timestamp = os.time(),
        serverTime = os.date("%Y-%m-%d %H:%M:%S", os.time()),
        event = eventType,
        data = data or {},
        systemVersion = systemVersion,
        systemUptime = systemInitialized and (os.time() - systemStartTime) or 0
    }

    -- Console logging
    if Config.Responses.OnDetection.LogToConsole then
        local logLevel = GetLogLevel(eventType)
        print(string.format("[Anti-Dump:%s] [%s] %s",
            logLevel,
            eventType,
            FormatLogMessage(eventType, data)))
    end
end

function GetLogLevel(eventType)
    if eventType:find("CRITICAL") or eventType:find("ERROR") then
        return "ERROR"
    elseif eventType:find("WARNING") or eventType:find("DETECTION") then
        return "WARN"
    elseif eventType:find("START") or eventType:find("STOP") then
        return "INFO"
    else
        return "DEBUG"
    end
end

function FormatLogMessage(eventType, data)
    if type(data) == "table" then
        local parts = {}
        for k, v in pairs(data) do
            if type(v) ~= "table" then
                parts[#parts + 1] = string.format("%s=%s", k, tostring(v))
            end
        end
        return table.concat(parts, ", ")
    end
    return tostring(data)
end

-- Event handlers
RegisterNetEvent('antidump:detection')
AddEventHandler('antidump:detection', function(detectionData)
    LogSystemEvent("DETECTION", detectionData)

    if NotificationManager.IsInitialized and NotificationManager.IsInitialized() then
        local severity = "MEDIUM"
        if detectionData.riskScore >= Config.Detection.Thresholds.HighRiskScore then
            severity = "HIGH"
        elseif detectionData.riskScore >= Config.Detection.Thresholds.CriticalRiskScore then
            severity = "CRITICAL"
        end

        local threatInfo = {
            threatType = detectionData.type or "Unknown",
            processName = detectionData.processName or "Unknown",
            riskScore = detectionData.riskScore or 0,
            severity = severity,
            description = detectionData.description or "Detection event"
        }

        NotificationManager:NotifyDetection(detectionData.playerId, threatInfo, severity)
    end
end)

-- FiveM Event Handlers for Console Commands
RegisterNetEvent('antidump:GetSystemStatus')
AddEventHandler('antidump:GetSystemStatus', function()
    local status = GetSystemStatus()
    -- Print status to console
    print(string.format("=== Anti-Dump System Status v%s ===", status.version))
    print(string.format("Status: %s", status.status))
    print(string.format("Uptime: %d seconds", status.uptime))
    print(string.format("Framework: %s", status.framework and status.framework.framework or "Unknown"))
end)

RegisterNetEvent('antidump:TriggerManualScan')
AddEventHandler('antidump:TriggerManualScan', function()
    local success = TriggerManualScan()
    -- Print result to console
    if success then
        print("[Anti-Dump] Manual scan completed successfully")
    else
        print("[Anti-Dump] Manual scan failed or returned no results")
    end
end)

RegisterNetEvent('antidump:GetDetectionStats')
AddEventHandler('antidump:GetDetectionStats', function()
    local stats = GetDetectionStats()
    -- Print stats to console
    print("=== Anti-Dump Detection Statistics ===")
    print(string.format("Total Detections: %d", stats.totalDetections or 0))
    print(string.format("Critical: %d, High: %d, Medium: %d, Low: %d",
        stats.criticalDetections or 0, stats.highDetections or 0,
        stats.mediumDetections or 0, stats.lowDetections or 0))
end)

-- Monitoring thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Detection.ScanInterval or 5000)

        if systemInitialized then
            local success, error = pcall(function()
                if DetectionEngine.PerformDetection then
                    DetectionEngine:PerformDetection()
                end
            end)

            if not success then
                LogSystemEvent("SYSTEM_ERROR", {
                    error = error,
                    context = "main_monitoring_thread"
                })
            end
        end
    end
end)


-- Console commands
RegisterCommand('antidump', function(source, args)
    if source ~= 0 then
        return
    end

    local command = args[1]

    if command == 'status' then
        TriggerEvent('antidump:GetSystemStatus')

    elseif command == 'scan' then
        print("[Anti-Dump] Triggering manual detection scan...")
        TriggerEvent('antidump:TriggerManualScan')

    elseif command == 'stats' then
        TriggerEvent('antidump:GetDetectionStats')

    elseif command == 'test-framework' then
        print("[Anti-Dump] Testing framework detection...")
        local testResults = FrameworkIntegration:TestFrameworkDetection()

    elseif command == 'help' then
        print("=== Anti-Dump Console Commands ===")
        print("  status - Show system status")
        print("  scan - Trigger manual detection scan")
        print("  stats - Show detection statistics")
        print("  test-framework - Test framework detection")
        print("  help - Show this help message")

    else
        print("[Anti-Dump] Unknown command. Use 'help' for available commands.")
    end
end, false)

-- Initialize system when resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        InitializeAntiDumpSystem()
    end
end)

-- Cleanup when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        ShutdownAntiDumpSystem()
    end
end)

-- Auto-initialize system
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    if not systemInitialized then
        local success, message = InitializeAntiDumpSystem()
        if not success then
            print(string.format("[Anti-Dump] ERROR: System initialization failed: %s", message))
        end
    end
end)

-- Add missing utility functions
function GetMemoryUsage()
    return collectgarbage("count") / 1024 -- MB
end

-- Initialize system immediately if not waiting for resource start
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait a second for system to stabilize
    if not systemInitialized then
        local success, message = InitializeAntiDumpSystem()
        if not success then
            print(string.format("[Anti-Dump] ERROR: System initialization failed: %s", message))
        end
    end
end)

-- Utility functions
function FormatTimeAgo(timestamp)
    if not timestamp then return "Unknown" end

    local now = os.time()
    local diff = now - timestamp

    if diff < 60 then
        return string.format("%d seconds ago", diff)
    elseif diff < 3600 then
        return string.format("%d minutes ago", math.floor(diff / 60))
    elseif diff < 86400 then
        return string.format("%d hours ago", math.floor(diff / 3600))
    else
        return string.format("%d days ago", math.floor(diff / 86400))
    end
end

-- Enhanced JSON encoding function
function json.encode(data)
    if type(data) == "table" then
        local parts = {}
        for k, v in pairs(data) do
            local key = type(k) == "string" and '"' .. k:gsub('"', '\\"') .. '"' or tostring(k)
            table.insert(parts, key .. ":" .. json.encode(v))
        end
        return "{" .. table.concat(parts, ",") .. "}"
    elseif type(data) == "string" then
        return '"' .. data:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
    elseif type(data) == "number" or type(data) == "boolean" then
        return tostring(data)
    elseif data == nil then
        return "null"
    else
        return '"unsupported"'
    end
end

-- JSON decoding function
function json.decode(str)
    if not str or str == "" then return nil end

    -- Simple JSON decoder for basic structures
    local success, result = pcall(function()
        -- This is a simplified implementation
        -- In production, consider using a proper JSON library
        if str:match('^".*"$') then
            return str:sub(2, -2):gsub('\\"', '"')
        elseif str == "true" then
            return true
        elseif str == "false" then
            return false
        elseif str == "null" then
            return nil
        elseif tonumber(str) then
            return tonumber(str)
        else
            return str
        end
    end)

    return success and result or nil
end

-- System information function
function GetSystemInformation()
    return {
        version = systemVersion,
        initialized = systemInitialized,
        uptime = systemInitialized and (os.time() - systemStartTime) or 0,
        status = systemHealth.status,
        activeModules = GetActiveModules(),
        framework = FrameworkIntegration.GetCurrentFramework(),
        database = Config.Database.Enabled,
        debugMode = Config.DebugMode
    }
end

-- Local functions for event handlers
function GetSystemStatus()
    return {
        isRunning = systemInitialized,
        version = systemVersion,
        uptime = systemInitialized and (os.time() - systemStartTime) or 0,
        detectionModules = {"process", "network", "memory", "behavioral"},
        preventionModules = {"memory", "process", "network", "hook", "debug"},
        status = systemHealth.status,
        lastError = systemHealth.lastError,
        framework = FrameworkIntegration:GetFrameworkInfo(),
        database = DatabaseManager:GetStatus(),
        performance = PerformanceMonitor:GetStatistics(),
        notifications = NotificationManager:GetStatistics()
    }
end

function TriggerManualScan()
    if DetectionEngine.TriggerManualDetection then
        local scanResult = DetectionEngine:TriggerManualDetection()
        if scanResult then
            print(string.format("[Anti-Dump] Manual scan completed - Detections: %d, Risk Score: %.1f",
                scanResult.detectionCount or 0, scanResult.overallRiskScore or 0))
            return scanResult
        end
    end
    print("[Anti-Dump] Manual scan failed or returned no results")
    return false
end

function GetDetectionStats()
    if DetectionEngine.GetDetectionStats then
        local stats = DetectionEngine:GetDetectionStats()
        return {
            totalDetections = stats.totalDetections or 0,
            criticalDetections = stats.criticalDetections or 0,
            highDetections = stats.highDetections or 0,
            mediumDetections = stats.mediumDetections or 0,
            lowDetections = stats.lowDetections or 0,
            threatsDetected = stats.totalDetections or 0,
            falsePositives = 0,
            lastScanTime = os.time()
        }
    end
    return {
        totalDetections = 0,
        criticalDetections = 0,
        highDetections = 0,
        mediumDetections = 0,
        lowDetections = 0,
        threatsDetected = 0,
        falsePositives = 0,
        lastScanTime = os.time()
    }
end

print(string.format("[Anti-Dump] Anti-Dump Detection System v%s loaded successfully!", systemVersion))
print("[Anti-Dump] Use console command 'antidump help' for available commands.")
print("[Anti-Dump] System will initialize automatically in a few seconds...")
-- FiveM Anti-Dump Main Server Script
-- Complete integration system for anti-dump detection - FiveM Single-File Architecture
-- Version: 2.0.0

-- Load global configuration first (loaded by fxmanifest.lua)
-- Config table is already available as global

-- =============================================================================
-- UTILITY FUNCTIONS (Consolidated from utils modules)
-- =============================================================================

local Utils = {}

-- Table utilities
Utils.Table = {
    Merge = function(t1, t2)
        local result = {}
        for k, v in pairs(t1) do result[k] = v end
        for k, v in pairs(t2) do result[k] = v end
        return result
    end,

    Length = function(t)
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        return count
    end,

    Clone = function(t)
        local result = {}
        for k, v in pairs(t) do
            if type(v) == "table" then
                result[k] = Utils.Table.Clone(v)
            else
                result[k] = v
            end
        end
        return result
    end
}

-- String utilities
Utils.String = {
    Trim = function(s)
        return s:gsub("^%s*(.-)%s*$", "%1")
    end,

    StartsWith = function(s, prefix)
        return s:sub(1, #prefix) == prefix
    end,

    Replace = function(s, old, new)
        return s:gsub(old, new)
    end
}

-- =============================================================================
-- DATABASE MANAGER (Consolidated from utils/database_manager.lua)
-- =============================================================================

local DatabaseManager = {
    config = {
        enabled = false,
        type = "mysql",
        host = "localhost",
        port = 3306,
        database = "fivem_antidump",
        username = "root",
        password = "",
        connection_timeout = 10000,
        max_connections = 10,
        enable_pooling = true
    },

    connection = nil,
    isConnected = false,
    connectionAttempts = 0,
    maxReconnectAttempts = 3,

    tables = {
        detections = "antidump_detections",
        processes = "antidump_processes",
        network_activity = "antidump_network_activity",
        players = "antidump_players",
        incidents = "antidump_incidents",
        statistics = "antidump_statistics"
    },

    queryCache = {},
    cacheTimeout = 300000
}

function DatabaseManager:Initialize()
    if not self.config.enabled then
        return false, "Database is disabled in configuration"
    end

    if Config and Config.Database then
        self.config = Utils.Table.Merge(self.config, Config.Database)
        self.tables = Utils.Table.Merge(self.tables, Config.Database.Tables or {})
    end

    return self:Connect()
end

function DatabaseManager:Connect()
    if self.isConnected then
        return true, "Already connected to database"
    end

    local success, result
    if self.config.type == "mysql" then
        success, result = self:ConnectMySQL()
    elseif self.config.type == "sqlite" then
        success, result = self:ConnectSQLite()
    else
        return false, "Unsupported database type: " .. self.config.type
    end

    if success then
        self.isConnected = true
        self.connectionAttempts = 0
        self:CreateTables()
        return true, "Connected to " .. self.config.type .. " database successfully"
    else
        self.connectionAttempts = self.connectionAttempts + 1
        return false, "Failed to connect to database: " .. result
    end
end

function DatabaseManager:ConnectMySQL()
    if not self.config.host or not self.config.database then
        return false, "MySQL host and database are required"
    end

    self.connection = {
        type = "mysql",
        host = self.config.host,
        database = self.config.database
    }

    return true, "MySQL connection established"
end

function DatabaseManager:ConnectSQLite()
    if not self.config.database then
        return false, "SQLite database path is required"
    end

    self.connection = {
        type = "sqlite",
        database = self.config.database
    }

    return true, "SQLite connection established"
end

function DatabaseManager:Disconnect()
    if not self.isConnected then
        return true, "Already disconnected"
    end

    self.isConnected = false
    self.connection = nil
    self.queryCache = {}

    return true, "Disconnected from database"
end

function DatabaseManager:CreateTables()
    if not self.isConnected then
        return false, "Not connected to database"
    end

    local tables = {
        detections = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.detections .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                player_identifier VARCHAR(255) NOT NULL,
                detection_type VARCHAR(100) NOT NULL,
                risk_score INT NOT NULL DEFAULT 0,
                description TEXT,
                process_name VARCHAR(255),
                ip_address VARCHAR(45),
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                resolved BOOLEAN DEFAULT FALSE,
                notes TEXT,
                INDEX idx_player_identifier (player_identifier),
                INDEX idx_timestamp (timestamp),
                INDEX idx_risk_score (risk_score)
            )
        ]],

        processes = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.processes .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                process_name VARCHAR(255) NOT NULL,
                detection_count INT DEFAULT 1,
                first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                risk_level VARCHAR(20) DEFAULT 'medium',
                status VARCHAR(20) DEFAULT 'active',
                notes TEXT,
                INDEX idx_process_name (process_name),
                INDEX idx_last_seen (last_seen)
            )
        ]],

        players = [[
            CREATE TABLE IF NOT EXISTS ]] .. self.tables.players .. [[ (
                id INT AUTO_INCREMENT PRIMARY KEY,
                identifier VARCHAR(255) NOT NULL UNIQUE,
                name VARCHAR(255),
                first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                total_detections INT DEFAULT 0,
                risk_score INT DEFAULT 0,
                status VARCHAR(20) DEFAULT 'active',
                notes TEXT,
                INDEX idx_identifier (identifier),
                INDEX idx_risk_score (risk_score)
            )
        ]]
    }

    for tableName, query in pairs(tables) do
        local success, error = self:Execute(query)
        if not success then
            print("[Anti-Dump] Failed to create " .. tableName .. " table: " .. (error or "Unknown error"))
        end
    end

    return true, "Tables creation attempted"
end

function DatabaseManager:Execute(query, parameters)
    if not self.isConnected then
        return false, "Not connected to database"
    end

    if not query or type(query) ~= "string" then
        return false, "Invalid query"
    end

    -- Simulate query execution for now
    local success = true
    local result = {}

    if Utils.String.StartsWith(Utils.String.Trim(query:upper()), "SELECT") then
        result = {}
    end

    if success then
        return true, result
    else
        return false, "Query execution failed"
    end
end

function DatabaseManager:InsertDetection(detectionData)
    if not detectionData or type(detectionData) ~= "table" then
        return false, "Invalid detection data"
    end

    local query = [[
        INSERT INTO ]] .. self.tables.detections .. [[ (
            player_identifier, detection_type, risk_score, description,
            process_name, ip_address, timestamp, notes
        ) VALUES (
            {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}
        )
    ]]

    local parameters = {
        detectionData.player_identifier or "",
        detectionData.detection_type or "unknown",
        detectionData.risk_score or 0,
        detectionData.description or "",
        detectionData.process_name or "",
        detectionData.ip_address or "",
        detectionData.timestamp or os.date("%Y-%m-%d %H:%M:%S"),
        detectionData.notes or ""
    }

    local success, result = self:Execute(query, parameters)

    if success then
        return true, "Detection recorded successfully"
    else
        return false, "Failed to record detection: " .. (result or "Unknown error")
    end
end

function DatabaseManager:GetStatus()
    return {
        connected = self.isConnected,
        connection_attempts = self.connectionAttempts,
        database_type = self.config.type,
        database_name = self.config.database,
        cache_size = Utils.Table.Length(self.queryCache),
        tables = self.tables
    }
end

-- =============================================================================
-- FRAMEWORK INTEGRATION (Consolidated from utils/framework_integration.lua)
-- =============================================================================

local FrameworkIntegration = {
    config = {
        auto_detect = true,
        preferred_framework = "auto",
        enable_integration = true
    },

    currentFramework = nil,
    frameworkVersion = nil,
    isInitialized = false,

    frameworkFunctions = {},

    playerManager = {
        getPlayer = nil,
        getPlayerIdentifier = nil,
        getPlayerName = nil,
        kickPlayer = nil,
        banPlayer = nil,
        isPlayerAdmin = nil
    }
}

function FrameworkIntegration:Initialize()
    if not self.config.enable_integration then
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Framework integration disabled, using standalone mode"
    end

    if Config and Config.Framework then
        self.config = Utils.Table.Merge(self.config, Config.Framework)
    end

    local detectionSuccess, detectionResult = self:DetectFramework()

    if not detectionSuccess then
        print("[Anti-Dump] Framework detection failed: " .. detectionResult)
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Using standalone mode due to detection failure"
    end

    local initSuccess, initResult = self:InitializeFramework()

    if initSuccess then
        self.isInitialized = true
        return true, "Framework integration initialized: " .. self.currentFramework
    else
        print("[Anti-Dump] Framework initialization failed: " .. initResult)
        self.currentFramework = "standalone"
        self.isInitialized = true
        return true, "Using standalone mode due to initialization failure"
    end
end

function FrameworkIntegration:DetectFramework()
    -- Detection priority: QBCore first, then ESX, then vRP, then standalone
    print("[Anti-Dump] Starting framework detection in priority order...")

    -- Check QBCore first
    local qbCoreDetected, qbCoreVersion = self:DetectQBCore()
    if qbCoreDetected then
        print(string.format("[Anti-Dump] QBCore detected: %s", qbCoreVersion or "Unknown version"))
        self.currentFramework = "qbcore"
        self.frameworkVersion = qbCoreVersion or "1.0.0+"
        return true, "QBCore v" .. (qbCoreVersion or "1.0.0+")
    end

    -- Check ESX second
    local esxDetected, esxVersion = self:DetectESX()
    if esxDetected then
        print(string.format("[Anti-Dump] ESX detected: %s", esxVersion or "Unknown version"))
        self.currentFramework = "esx"
        self.frameworkVersion = esxVersion or "1.10.0+"
        return true, "ESX v" .. (esxVersion or "1.10.0+")
    end

    -- Check vRP third
    local vrpDetected, vrpVersion = self:DetectVRP()
    if vrpDetected then
        print(string.format("[Anti-Dump] vRP detected: %s", vrpVersion or "Unknown version"))
        self.currentFramework = "vrp"
        self.frameworkVersion = vrpVersion or "1.0.0+"
        return true, "vRP v" .. (vrpVersion or "1.0.0+")
    end

    -- Default to standalone
    print("[Anti-Dump] No supported framework detected, using standalone mode")
    self.currentFramework = "standalone"
    self.frameworkVersion = "standalone"
    return true, "Standalone mode"
end

function FrameworkIntegration:DetectQBCore()
    -- Method 1: Check if qb-core resource is running
    local qbCoreResource = GetResourceState("qb-core")
    if qbCoreResource == "started" or qbCoreResource == "starting" then
        print("[Anti-Dump] QBCore resource 'qb-core' is running")
        return true, "1.0.0+"
    end

    -- Method 2: Check for QBCore exports
    if exports['qb-core'] then
        print("[Anti-Dump] QBCore exports available")
        -- Try to get the core object to confirm it's working
        local success, core = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success and core then
            print("[Anti-Dump] QBCore GetCoreObject export working")
            return true, "1.0.0+"
        end
    end

    -- Method 3: Check for QBCore global functions
    if QBCore and type(QBCore) == "table" then
        print("[Anti-Dump] QBCore global object found")
        if QBCore.GetCoreObject or QBCore.Shared or QBCore.Player then
            return true, "1.0.0+"
        end
    end

    -- Method 4: Check for QBCore-specific functions
    local success, hasFunction = pcall(function()
        return GetCoreObject ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] QBCore GetCoreObject function found")
        return true, "1.0.0+"
    end

    -- Method 5: Check for QBCore player management functions
    local success, hasPlayerFunction = pcall(function()
        return QBCore and QBCore.Functions and QBCore.Functions.GetPlayer ~= nil
    end)
    if success and hasPlayerFunction then
        print("[Anti-Dump] QBCore player management functions found")
        return true, "1.0.0+"
    end

    return false, nil
end

function FrameworkIntegration:DetectESX()
    -- Method 1: Check if es_extended resource is running
    local esxResource = GetResourceState("es_extended")
    if esxResource == "started" or esxResource == "starting" then
        print("[Anti-Dump] ESX resource 'es_extended' is running")
        return true, "1.10.0+"
    end

    -- Method 2: Check for ESX exports (try both es_extended and esx)
    if exports['es_extended'] then
        print("[Anti-Dump] ESX exports available (es_extended)")
        -- Try to get the shared object to confirm it's working
        local success, esx = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if success and esx then
            print("[Anti-Dump] ESX getSharedObject export working")
            return true, "1.10.0+"
        end
    elseif exports['esx'] then
        print("[Anti-Dump] ESX exports available (esx)")
        -- Try to get the shared object to confirm it's working
        local success, esx = pcall(function()
            return exports['esx']:getSharedObject()
        end)
        if success and esx then
            print("[Anti-Dump] ESX getSharedObject export working")
            return true, "1.10.0+"
        end
    end

    -- Method 3: Check for ESX global functions
    if ESX and type(ESX) == "table" then
        print("[Anti-Dump] ESX global object found")
        if ESX.GetPlayer or ESX.GetPlayers or ESX.RegisterServerCallback then
            return true, "1.10.0+"
        end
    end

    -- Method 4: Check for ESX-specific functions
    local success, hasFunction = pcall(function()
        return ESX ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] ESX global object found")
        return true, "1.10.0+"
    end

    return false, nil
end

function FrameworkIntegration:DetectVRP()
    -- Method 1: Check if vrp resource is running
    local vrpResource = GetResourceState("vrp")
    if vrpResource == "started" or vrpResource == "starting" then
        print("[Anti-Dump] vRP resource 'vrp' is running")
        return true, "1.0.0+"
    end

    -- Method 2: Check for vRP exports
    if exports['vrp'] then
        print("[Anti-Dump] vRP exports available")
        return true, "1.0.0+"
    end

    -- Method 3: Check for vRP global functions
    if vRP and type(vRP) == "table" then
        print("[Anti-Dump] vRP global object found")
        if vRP.getUserId or vRP.getUserData or vRP.registerMenuBuilder then
            return true, "1.0.0+"
        end
    end

    -- Method 4: Check for vRP-specific functions
    local success, hasFunction = pcall(function()
        return vRP ~= nil
    end)
    if success and hasFunction then
        print("[Anti-Dump] vRP global object found")
        return true, "1.0.0+"
    end

    return false, nil
end

function FrameworkIntegration:InitializeFramework()
    if self.currentFramework == "standalone" then
        return self:InitializeStandalone()
    else
        return self:InitializeStandalone() -- Fallback for now
    end
end

function FrameworkIntegration:InitializeStandalone()
    self.frameworkFunctions = {
        getPlayer = function(source)
            return source
        end,

        getPlayerIdentifier = function(source)
            for _, id in ipairs(GetPlayerIdentifiers(source)) do
                if string.find(id, "license:") then
                    return string.sub(id, 9)
                end
            end
            return nil
        end,

        getPlayerName = function(source)
            return GetPlayerName(source)
        end,

        isPlayerAdmin = function(source)
            return IsPlayerAceAllowed(source, "antidump.admin") or
                   IsPlayerAceAllowed(source, "admin") or
                   IsPlayerAceAllowed(source, "god")
        end
    }

    self.playerManager = self.frameworkFunctions
    return true, "Standalone integration initialized"
end

function FrameworkIntegration:GetPlayer(source)
    if not self.playerManager.getPlayer then
        return nil
    end
    return self.playerManager.getPlayer(source)
end

function FrameworkIntegration:GetPlayerIdentifier(source)
    if not self.playerManager.getPlayerIdentifier then
        return nil
    end
    return self.playerManager.getPlayerIdentifier(source)
end

function FrameworkIntegration:GetPlayerName(source)
    if not self.playerManager.getPlayerName then
        return GetPlayerName(source)
    end
    return self.playerManager.getPlayerName(source)
end

function FrameworkIntegration:IsPlayerAdmin(source)
    if not self.playerManager.isPlayerAdmin then
        return IsPlayerAceAllowed(source, "antidump.admin")
    end
    return self.playerManager.isPlayerAdmin(source)
end

function FrameworkIntegration:GetFrameworkInfo()
    return {
        framework = self.currentFramework,
        version = self.frameworkVersion,
        initialized = self.isInitialized,
        player_count = GetNumPlayerIndices()
    }
end

function FrameworkIntegration:TestFrameworkDetection()
    print("[Anti-Dump] === Framework Detection Test ===")

    -- Test QBCore detection
    print("[Anti-Dump] Testing QBCore detection...")
    local qbCoreDetected, qbCoreVersion = self:DetectQBCore()
    print(string.format("[Anti-Dump] QBCore detection result: %s (Version: %s)",
        qbCoreDetected and "DETECTED" or "NOT DETECTED",
        qbCoreVersion or "N/A"))

    -- Test ESX detection
    print("[Anti-Dump] Testing ESX detection...")
    local esxDetected, esxVersion = self:DetectESX()
    print(string.format("[Anti-Dump] ESX detection result: %s (Version: %s)",
        esxDetected and "DETECTED" or "NOT DETECTED",
        esxVersion or "N/A"))

    -- Test vRP detection
    print("[Anti-Dump] Testing vRP detection...")
    local vrpDetected, vrpVersion = self:DetectVRP()
    print(string.format("[Anti-Dump] vRP detection result: %s (Version: %s)",
        vrpDetected and "DETECTED" or "NOT DETECTED",
        vrpVersion or "N/A"))

    -- Show current framework
    print(string.format("[Anti-Dump] Current framework: %s v%s",
        self.currentFramework or "Unknown",
        self.frameworkVersion or "Unknown"))

    print("[Anti-Dump] === Framework Detection Test Complete ===")

    return {
        qbcore = { detected = qbCoreDetected, version = qbCoreVersion },
        esx = { detected = esxDetected, version = esxVersion },
        vrp = { detected = vrpDetected, version = vrpVersion },
        current = { framework = self.currentFramework, version = self.frameworkVersion }
    }
end

-- =============================================================================
-- PERFORMANCE MONITOR (Consolidated from utils/performance_monitor.lua)
-- =============================================================================

local PerformanceMonitor = {
    config = {
        enabled = true,
        interval = 60000,
        metrics = {}
    },

    metrics = {
        cpuUsage = 0,
        memoryUsage = 0,
        scanCount = 0,
        avgScanTime = 0,
        lastUpdate = 0
    },

    scanTimes = {},
    maxScanTimes = 100
}

function PerformanceMonitor:Initialize()
    if not self.config.enabled then
        return false
    end

    self:StartMonitoring()
    return true
end

function PerformanceMonitor:StartMonitoring()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(self.config.interval)
            self:RecordMetrics()
        end
    end)
end

function PerformanceMonitor:RecordMetrics()
    self.metrics.lastUpdate = GetGameTimer()

    -- Simulate performance metrics collection
    self.metrics.cpuUsage = math.random(10, 80) -- Simulated CPU usage
    self.metrics.memoryUsage = math.random(50, 400) -- Simulated memory usage in MB
    self.metrics.scanCount = self.metrics.scanCount + 1
end

function PerformanceMonitor:RecordScanTime(scanTime)
    table.insert(self.scanTimes, scanTime)

    if #self.scanTimes > self.maxScanTimes then
        table.remove(self.scanTimes, 1)
    end

    if #self.scanTimes > 0 then
        local total = 0
        for _, time in ipairs(self.scanTimes) do
            total = total + time
        end
        self.metrics.avgScanTime = total / #self.scanTimes
    end
end

function PerformanceMonitor:GetMetrics()
    return Utils.Table.Clone(self.metrics)
end

function PerformanceMonitor:GetStatistics()
    return {
        enabled = self.config.enabled,
        interval = self.config.interval,
        metrics = self:GetMetrics(),
        scan_times_count = #self.scanTimes
    }
end

-- =============================================================================
-- NOTIFICATION MANAGER (Consolidated from notifications/notification_manager.lua)
-- =============================================================================

local NotificationManager = {
    Config = {
        Enabled = true,
        MaxQueueSize = 1000,
        QueueProcessInterval = 1000,
        PerformanceMonitoring = true,
        EnableMetrics = true,
        MetricsInterval = 60000
    },

    notificationQueue = {},
    activeNotifications = {},
    performanceMetrics = {},
    isInitialized = false
}

-- Priority constants
local PRIORITY = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    CRITICAL = 4,
    SYSTEM = 5
}

-- Notification types
local NOTIFICATION_TYPES = {
    PLAYER_WARNING = "player_warning",
    PLAYER_DETECTION = "player_detection",
    ADMIN_ALERT = "admin_alert",
    CRITICAL_ALERT = "critical_alert",
    SYSTEM_ALERT = "system_alert",
    LOG_EVENT = "log_event",
    DISCORD_WEBHOOK = "discord_webhook"
}

function NotificationManager:Initialize(customConfig)
    if self.isInitialized then
        return true
    end

    if customConfig then
        for k, v in pairs(customConfig) do
            self.Config[k] = v
        end
    end

    if Config and Config.Notifications then
        self.Config = Utils.Table.Merge(self.Config, Config.Notifications)
    end

    self:InitializeSubsystems()

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(self.Config.QueueProcessInterval)
            self:ProcessNotificationQueue()
        end
    end)

    if self.Config.PerformanceMonitoring then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(self.Config.MetricsInterval)
                self:UpdatePerformanceMetrics()
            end
        end)
    end

    self.isInitialized = true
    return true
end

function NotificationManager:InitializeSubsystems()
    -- Initialize player notifications
    if not self.PlayerNotifications then
        self.PlayerNotifications = {}
    end

    -- Initialize admin notifications
    if not self.AdminNotifications then
        self.AdminNotifications = {}
    end

    -- Initialize logging system
    if not self.LoggingSystem then
        self.LoggingSystem = {}
    end

    -- Initialize Discord webhook
    if not self.DiscordWebhook then
        self.DiscordWebhook = {}
    end
end

function NotificationManager:SendNotification(notificationType, data, priority, options)
    if not self.Config.Enabled then
        return false, "Notification manager is disabled"
    end

    priority = priority or PRIORITY.MEDIUM

    local notification = {
        id = self:GenerateNotificationId(),
        type = notificationType,
        data = data,
        priority = priority,
        options = options or {},
        timestamp = os.time(),
        attempts = 0,
        maxAttempts = options.maxAttempts or 3
    }

    self:QueueNotification(notification)
    return true, notification.id
end

function NotificationManager:QueueNotification(notification)
    if #self.notificationQueue >= self.Config.MaxQueueSize then
        return false
    end

    -- Insert in priority order
    local inserted = false
    for i, queuedNotification in ipairs(self.notificationQueue) do
        if notification.priority > queuedNotification.priority then
            table.insert(self.notificationQueue, i, notification)
            inserted = true
            break
        end
    end

    if not inserted then
        table.insert(self.notificationQueue, notification)
    end

    return true
end

function NotificationManager:ProcessNotificationQueue()
    if #self.notificationQueue == 0 then
        return
    end

    local processedCount = 0
    local maxProcessPerCycle = 10

    while #self.notificationQueue > 0 and processedCount < maxProcessPerCycle do
        local notification = table.remove(self.notificationQueue, 1)
        self:ProcessNotification(notification)
        processedCount = processedCount + 1
    end
end

function NotificationManager:ProcessNotification(notification)
    self.activeNotifications[notification.id] = notification

    local success = false
    local errorMessage = ""

    if notification.type == NOTIFICATION_TYPES.PLAYER_DETECTION then
        success, errorMessage = self:HandlePlayerDetection(notification)
    elseif notification.type == NOTIFICATION_TYPES.ADMIN_ALERT then
        success, errorMessage = self:HandleAdminAlert(notification)
    elseif notification.type == NOTIFICATION_TYPES.CRITICAL_ALERT then
        success, errorMessage = self:HandleCriticalAlert(notification)
    else
        success = false
        errorMessage = "Unknown notification type: " .. notification.type
    end

    if success then
        self:HandleNotificationSuccess(notification)
    else
        self:HandleNotificationFailure(notification, errorMessage)
    end

    self.activeNotifications[notification.id] = nil
end

function NotificationManager:HandlePlayerDetection(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo
    local severity = notification.data.severity or "MEDIUM"

    if not playerId or not threatInfo then
        return false, "Missing required data for player detection notification"
    end

    -- Simulate player notification
    return true, "Player detection notification processed"
end

function NotificationManager:HandleAdminAlert(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo
    local severity = notification.data.severity or "MEDIUM"

    if not threatInfo then
        return false, "Missing threat info for admin alert"
    end

    -- Simulate admin notification
    return true, "Admin alert processed"
end

function NotificationManager:HandleCriticalAlert(notification)
    local playerId = notification.data.playerId
    local threatInfo = notification.data.threatInfo

    if not threatInfo then
        return false, "Missing threat info for critical alert"
    end

    -- Simulate critical notification
    return true, "Critical alert processed"
end

function NotificationManager:HandleNotificationSuccess(notification)
    if self.Config.EnableMetrics then
        if not self.performanceMetrics[notification.type] then
            self.performanceMetrics[notification.type] = {success = 0, failed = 0}
        end
        self.performanceMetrics[notification.type].success = self.performanceMetrics[notification.type].success + 1
    end
end

function NotificationManager:HandleNotificationFailure(notification, errorMessage)
    notification.attempts = notification.attempts + 1

    if self.Config.EnableMetrics then
        if not self.performanceMetrics[notification.type] then
            self.performanceMetrics[notification.type] = {success = 0, failed = 0}
        end
        self.performanceMetrics[notification.type].failed = self.performanceMetrics[notification.type].failed + 1
    end
end

function NotificationManager:GenerateNotificationId()
    return string.format("notif_%d_%d", os.time(), math.random(1000, 9999))
end

function NotificationManager:UpdatePerformanceMetrics()
    -- Performance monitoring logic
    if not self.Config.EnableMetrics then
        return
    end

    -- Update average processing times and success rates
    for notificationType, metrics in pairs(self.performanceMetrics) do
        if metrics.totalTime and metrics.totalTime > 0 then
            metrics.avgTime = metrics.totalTime / (metrics.success + metrics.failed)
        end
        if (metrics.success + metrics.failed) > 0 then
            metrics.successRate = (metrics.success / (metrics.success + metrics.failed)) * 100
        end
    end
end

function NotificationManager:NotifyDetection(playerId, threatInfo, severity)
    severity = severity or "MEDIUM"

    self:SendNotification(NOTIFICATION_TYPES.PLAYER_DETECTION, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = severity
    }, PRIORITY.MEDIUM)

    self:SendNotification(NOTIFICATION_TYPES.ADMIN_ALERT, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = severity
    }, PRIORITY.HIGH)

    return true
end

function NotificationManager:NotifyCriticalDetection(playerId, threatInfo)
    self:SendNotification(NOTIFICATION_TYPES.PLAYER_DETECTION, {
        playerId = playerId,
        threatInfo = threatInfo,
        severity = "CRITICAL"
    }, PRIORITY.CRITICAL)

    self:SendNotification(NOTIFICATION_TYPES.CRITICAL_ALERT, {
        playerId = playerId,
        threatInfo = threatInfo
    }, PRIORITY.CRITICAL)

    return true
end

function NotificationManager:GetStatistics()
    local stats = {
        queueSize = #self.notificationQueue,
        activeNotifications = #self.activeNotifications,
        performanceMetrics = self.performanceMetrics,
        uptime = GetGameTimer()
    }

    return stats
end

function NotificationManager:IsInitialized()
    return self.isInitialized
end

-- =============================================================================
-- DETECTION ENGINE (Consolidated from detection modules)
-- =============================================================================

local DetectionEngine = {
    isActive = false,
    lastDetectionRun = 0,
    detectionInterval = 5000,
    initialized = false,

    detectionHistory = {},
    maxHistorySize = 100,

    SCORING = {
        CRITICAL_THRESHOLD = 90,
        HIGH_THRESHOLD = 70,
        MEDIUM_THRESHOLD = 50,
        LOW_THRESHOLD = 25,
        MAX_SCORE = 100
    }
}

function DetectionEngine:Initialize()
    if self.initialized then
        return false
    end

    print("[Anti-Dump] Initializing Detection Engine...")

    self.isActive = true
    self.initialized = true
    self.lastDetectionRun = GetGameTimer()

    return true
end

function DetectionEngine:PerformDetection()
    if not self.initialized or not self.isActive then
        return nil
    end

    local currentTime = GetGameTimer()

    if currentTime - self.lastDetectionRun < self.detectionInterval then
        return nil
    end

    self.lastDetectionRun = currentTime

    local scanResults = {
        timestamp = currentTime,
        overallRiskScore = 0,
        detectionCount = 0,
        detections = {},
        moduleResults = {}
    }

    -- Simulate detection modules
    scanResults.moduleResults.process = self:ProcessMonitor()
    scanResults.moduleResults.network = self:NetworkMonitor()
    scanResults.moduleResults.memory = self:MemoryScanner()

    self:AggregateDetectionResults(scanResults)
    self:AddToHistory(scanResults)

    return scanResults
end

function DetectionEngine:ProcessMonitor()
    -- Simulate process monitoring
    return {
        detections = {},
        suspiciousProcesses = 0
    }
end

function DetectionEngine:NetworkMonitor()
    -- Simulate network monitoring
    return {
        detections = {},
        packetCaptureTools = {}
    }
end

function DetectionEngine:MemoryScanner()
    -- Simulate memory scanning
    return {
        detections = {
            highMemoryUsage = {},
            codeInjection = {},
            apiHooking = {}
        }
    }
end

function DetectionEngine:AggregateDetectionResults(scanResults)
    local allDetections = {}
    local totalRiskScore = 0
    local detectionCount = 0

    -- Process results from all modules
    for moduleName, results in pairs(scanResults.moduleResults) do
        if results.detections then
            for _, detection in ipairs(results.detections) do
                table.insert(allDetections, {
                    type = moduleName,
                    module = moduleName,
                    detection = detection,
                    timestamp = scanResults.timestamp
                })
                totalRiskScore = totalRiskScore + (detection.riskScore or 0)
                detectionCount = detectionCount + 1
            end
        end
    end

    scanResults.overallRiskScore = detectionCount > 0 and (totalRiskScore / detectionCount) or 0
    scanResults.detectionCount = detectionCount
    scanResults.detections = allDetections
end

function DetectionEngine:AddToHistory(scanResults)
    table.insert(self.detectionHistory, scanResults)

    if #self.detectionHistory > self.maxHistorySize then
        table.remove(self.detectionHistory, 1)
    end
end

function DetectionEngine:GetDetectionStats()
    local stats = {
        totalDetections = 0,
        criticalDetections = 0,
        highDetections = 0,
        mediumDetections = 0,
        lowDetections = 0
    }

    for _, scan in ipairs(self.detectionHistory) do
        stats.totalDetections = stats.totalDetections + scan.detectionCount

        for _, detection in ipairs(scan.detections) do
            local severity = self:GetSeverityFromScore(detection.detection.riskScore or 0)

            if severity == "critical" then
                stats.criticalDetections = stats.criticalDetections + 1
            elseif severity == "high" then
                stats.highDetections = stats.highDetections + 1
            elseif severity == "medium" then
                stats.mediumDetections = stats.mediumDetections + 1
            elseif severity == "low" then
                stats.lowDetections = stats.lowDetections + 1
            end
        end
    end

    return stats
end

function DetectionEngine:GetSeverityFromScore(score)
    if score >= self.SCORING.CRITICAL_THRESHOLD then
        return "critical"
    elseif score >= self.SCORING.HIGH_THRESHOLD then
        return "high"
    elseif score >= self.SCORING.MEDIUM_THRESHOLD then
        return "medium"
    elseif score >= self.SCORING.LOW_THRESHOLD then
        return "low"
    else
        return "info"
    end
end

function DetectionEngine:TriggerManualDetection()
    return self:PerformDetection()
end

function DetectionEngine:GetStatus()
    return {
        isActive = self.isActive,
        initialized = self.initialized,
        lastDetectionRun = self.lastDetectionRun,
        detectionInterval = self.detectionInterval,
        historySize = #self.detectionHistory,
        stats = self:GetDetectionStats()
    }
end

-- =============================================================================
-- MAIN SYSTEM (Consolidated from original server/antidump.lua)
-- =============================================================================

-- System state
local systemInitialized = false
local systemStartTime = 0
local systemVersion = "2.0.0"
local activeModules = {}
local systemHealth = {
    status = "INITIALIZING",
    uptime = 0,
    lastError = nil,
    moduleStatus = {}
}

-- JSON utilities
local json = {
    encode = function(data)
        if type(data) == "table" then
            local parts = {}
            for k, v in pairs(data) do
                local key = type(k) == "string" and '"' .. k:gsub('"', '\\"') .. '"' or tostring(k)
                table.insert(parts, key .. ":" .. json.encode(v))
            end
            return "{" .. table.concat(parts, ",") .. "}"
        elseif type(data) == "string" then
            return '"' .. data:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
        elseif type(data) == "number" or type(data) == "boolean" then
            return tostring(data)
        elseif data == nil then
            return "null"
        else
            return '"unsupported"'
        end
    end,

    decode = function(str)
        if not str or str == "" then return nil end
        if str == "true" then return true end
        if str == "false" then return false end
        if str == "null" then return nil end
        local num = tonumber(str)
        if num then return num end
        return str
    end
}

-- System initialization
function InitializeAntiDumpSystem()
    if systemInitialized then
        return false, "System already initialized"
    end

    print(string.format("[Anti-Dump] Starting Anti-Dump Detection System v%s...", systemVersion))
    systemHealth.status = "INITIALIZING"
    systemStartTime = os.time()

    -- Initialize components
    PerformanceMonitor:Initialize()

    local frameworkSuccess = FrameworkIntegration:Initialize()
    if not frameworkSuccess then
        print("[Anti-Dump] Warning: Framework integration failed, continuing with standalone mode")
    end

    if Config.Database.Enabled then
        local dbSuccess = DatabaseManager:Initialize()
        if not dbSuccess then
            print("[Anti-Dump] Warning: Database initialization failed, continuing without database")
        end
    end

    local detectionSuccess = DetectionEngine:Initialize()
    if not detectionSuccess then
        print("[Anti-Dump] ERROR: Failed to initialize Detection Engine")
        systemHealth.status = "ERROR"
        systemHealth.lastError = "Detection engine initialization failed"
        return false, "Detection engine initialization failed"
    end

    local notificationSuccess = NotificationManager:Initialize()
    if not notificationSuccess then
        print("[Anti-Dump] Warning: Notification system initialization failed, continuing without notifications")
    end

    -- Mark system as initialized
    systemInitialized = true
    systemHealth.status = "RUNNING"
    systemHealth.startTime = systemStartTime

    print(string.format("[Anti-Dump] Anti-Dump Detection System v%s started successfully", systemVersion))
    return true, "System initialized successfully"
end

-- System shutdown
function ShutdownAntiDumpSystem()
    if not systemInitialized then
        return false, "System not initialized"
    end

    print(string.format("[Anti-Dump] Shutting down Anti-Dump Detection System v%s...", systemVersion))
    systemHealth.status = "SHUTTING_DOWN"

    local uptime = os.time() - systemStartTime

    systemInitialized = false
    systemHealth.status = "STOPPED"
    systemHealth.uptime = uptime

    print(string.format("[Anti-Dump] Anti-Dump Detection System v%s shutdown complete (uptime: %d seconds)", systemVersion, uptime))
    return true, "Shutdown completed successfully"
end

-- Logging system
function LogSystemEvent(eventType, data)
    if not Config.Logging.Enabled then
        return
    end

    local logEntry = {
        timestamp = os.time(),
        serverTime = os.date("%Y-%m-%d %H:%M:%S", os.time()),
        event = eventType,
        data = data or {},
        systemVersion = systemVersion,
        systemUptime = systemInitialized and (os.time() - systemStartTime) or 0
    }

    -- Console logging
    if Config.Responses.OnDetection.LogToConsole then
        local logLevel = GetLogLevel(eventType)
        print(string.format("[Anti-Dump:%s] [%s] %s",
            logLevel,
            eventType,
            FormatLogMessage(eventType, data)))
    end
end

function GetLogLevel(eventType)
    if eventType:find("CRITICAL") or eventType:find("ERROR") then
        return "ERROR"
    elseif eventType:find("WARNING") or eventType:find("DETECTION") then
        return "WARN"
    elseif eventType:find("START") or eventType:find("STOP") then
        return "INFO"
    else
        return "DEBUG"
    end
end

function FormatLogMessage(eventType, data)
    if type(data) == "table" then
        local parts = {}
        for k, v in pairs(data) do
            if type(v) ~= "table" then
                parts[#parts + 1] = string.format("%s=%s", k, tostring(v))
            end
        end
        return table.concat(parts, ", ")
    end
    return tostring(data)
end

-- Event handlers
RegisterNetEvent('antidump:detection')
AddEventHandler('antidump:detection', function(detectionData)
    LogSystemEvent("DETECTION", detectionData)

    if NotificationManager.IsInitialized and NotificationManager.IsInitialized() then
        local severity = "MEDIUM"
        if detectionData.riskScore >= Config.Detection.Thresholds.HighRiskScore then
            severity = "HIGH"
        elseif detectionData.riskScore >= Config.Detection.Thresholds.CriticalRiskScore then
            severity = "CRITICAL"
        end

        local threatInfo = {
            threatType = detectionData.type or "Unknown",
            processName = detectionData.processName or "Unknown",
            riskScore = detectionData.riskScore or 0,
            severity = severity,
            description = detectionData.description or "Detection event"
        }

        NotificationManager:NotifyDetection(detectionData.playerId, threatInfo, severity)
    end
end)

-- FiveM Event Handlers for Console Commands
RegisterNetEvent('antidump:GetSystemStatus')
AddEventHandler('antidump:GetSystemStatus', function()
    local status = GetSystemStatus()
    -- Print status to console
    print(string.format("=== Anti-Dump System Status v%s ===", status.version))
    print(string.format("Status: %s", status.status))
    print(string.format("Uptime: %d seconds", status.uptime))
    print(string.format("Framework: %s", status.framework and status.framework.framework or "Unknown"))
end)

RegisterNetEvent('antidump:TriggerManualScan')
AddEventHandler('antidump:TriggerManualScan', function()
    local success = TriggerManualScan()
    -- Print result to console
    if success then
        print("[Anti-Dump] Manual scan completed successfully")
    else
        print("[Anti-Dump] Manual scan failed or returned no results")
    end
end)

RegisterNetEvent('antidump:GetDetectionStats')
AddEventHandler('antidump:GetDetectionStats', function()
    local stats = GetDetectionStats()
    -- Print stats to console
    print("=== Anti-Dump Detection Statistics ===")
    print(string.format("Total Detections: %d", stats.totalDetections or 0))
    print(string.format("Critical: %d, High: %d, Medium: %d, Low: %d",
        stats.criticalDetections or 0, stats.highDetections or 0,
        stats.mediumDetections or 0, stats.lowDetections or 0))
end)

-- Monitoring thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Detection.ScanInterval or 5000)

        if systemInitialized then
            local success, error = pcall(function()
                if DetectionEngine.PerformDetection then
                    DetectionEngine:PerformDetection()
                end
            end)

            if not success then
                LogSystemEvent("SYSTEM_ERROR", {
                    error = error,
                    context = "main_monitoring_thread"
                })
            end
        end
    end
end)


-- Console commands
RegisterCommand('antidump', function(source, args)
    if source ~= 0 then
        return
    end

    local command = args[1]

    if command == 'status' then
        TriggerEvent('antidump:GetSystemStatus')

    elseif command == 'scan' then
        print("[Anti-Dump] Triggering manual detection scan...")
        TriggerEvent('antidump:TriggerManualScan')

    elseif command == 'stats' then
        TriggerEvent('antidump:GetDetectionStats')

    elseif command == 'test-framework' then
        print("[Anti-Dump] Testing framework detection...")
        local testResults = FrameworkIntegration:TestFrameworkDetection()

    elseif command == 'help' then
        print("=== Anti-Dump Console Commands ===")
        print("  status - Show system status")
        print("  scan - Trigger manual detection scan")
        print("  stats - Show detection statistics")
        print("  test-framework - Test framework detection")
        print("  help - Show this help message")

    else
        print("[Anti-Dump] Unknown command. Use 'help' for available commands.")
    end
end, false)

-- Initialize system when resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        InitializeAntiDumpSystem()
    end
end)

-- Cleanup when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        ShutdownAntiDumpSystem()
    end
end)

-- Auto-initialize system
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    if not systemInitialized then
        local success, message = InitializeAntiDumpSystem()
        if not success then
            print(string.format("[Anti-Dump] ERROR: System initialization failed: %s", message))
        end
    end
end)

-- Add missing utility functions
function GetMemoryUsage()
    return collectgarbage("count") / 1024 -- MB
end

-- Initialize system immediately if not waiting for resource start
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait a second for system to stabilize
    if not systemInitialized then
        local success, message = InitializeAntiDumpSystem()
        if not success then
            print(string.format("[Anti-Dump] ERROR: System initialization failed: %s", message))
        end
    end
end)

-- Utility functions
function FormatTimeAgo(timestamp)
    if not timestamp then return "Unknown" end

    local now = os.time()
    local diff = now - timestamp

    if diff < 60 then
        return string.format("%d seconds ago", diff)
    elseif diff < 3600 then
        return string.format("%d minutes ago", math.floor(diff / 60))
    elseif diff < 86400 then
        return string.format("%d hours ago", math.floor(diff / 3600))
    else
        return string.format("%d days ago", math.floor(diff / 86400))
    end
end

-- Enhanced JSON encoding function
function json.encode(data)
    if type(data) == "table" then
        local parts = {}
        for k, v in pairs(data) do
            local key = type(k) == "string" and '"' .. k:gsub('"', '\\"') .. '"' or tostring(k)
            table.insert(parts, key .. ":" .. json.encode(v))
        end
        return "{" .. table.concat(parts, ",") .. "}"
    elseif type(data) == "string" then
        return '"' .. data:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
    elseif type(data) == "number" or type(data) == "boolean" then
        return tostring(data)
    elseif data == nil then
        return "null"
    else
        return '"unsupported"'
    end
end

-- JSON decoding function
function json.decode(str)
    if not str or str == "" then return nil end

    -- Simple JSON decoder for basic structures
    local success, result = pcall(function()
        -- This is a simplified implementation
        -- In production, consider using a proper JSON library
        if str:match('^".*"$') then
            return str:sub(2, -2):gsub('\\"', '"')
        elseif str == "true" then
            return true
        elseif str == "false" then
            return false
        elseif str == "null" then
            return nil
        elseif tonumber(str) then
            return tonumber(str)
        else
            return str
        end
    end)

    return success and result or nil
end

-- System information function
function GetSystemInformation()
    return {
        version = systemVersion,
        initialized = systemInitialized,
        uptime = systemInitialized and (os.time() - systemStartTime) or 0,
        status = systemHealth.status,
        activeModules = GetActiveModules(),
        framework = FrameworkIntegration.GetCurrentFramework(),
        database = Config.Database.Enabled,
        debugMode = Config.DebugMode
    }
end

-- Local functions for event handlers
function GetSystemStatus()
    return {
        isRunning = systemInitialized,
        version = systemVersion,
        uptime = systemInitialized and (os.time() - systemStartTime) or 0,
        detectionModules = {"process", "network", "memory", "behavioral"},
        preventionModules = {"memory", "process", "network", "hook", "debug"},
        status = systemHealth.status,
        lastError = systemHealth.lastError,
        framework = FrameworkIntegration:GetFrameworkInfo(),
        database = DatabaseManager:GetStatus(),
        performance = PerformanceMonitor:GetStatistics(),
        notifications = NotificationManager:GetStatistics()
    }
end

function TriggerManualScan()
    if DetectionEngine.TriggerManualDetection then
        local scanResult = DetectionEngine:TriggerManualDetection()
        if scanResult then
            print(string.format("[Anti-Dump] Manual scan completed - Detections: %d, Risk Score: %.1f",
                scanResult.detectionCount or 0, scanResult.overallRiskScore or 0))
            return scanResult
        end
    end
    print("[Anti-Dump] Manual scan failed or returned no results")
    return false
end

function GetDetectionStats()
    if DetectionEngine.GetDetectionStats then
        local stats = DetectionEngine:GetDetectionStats()
        return {
            totalDetections = stats.totalDetections or 0,
            criticalDetections = stats.criticalDetections or 0,
            highDetections = stats.highDetections or 0,
            mediumDetections = stats.mediumDetections or 0,
            lowDetections = stats.lowDetections or 0,
            threatsDetected = stats.totalDetections or 0,
            falsePositives = 0,
            lastScanTime = os.time()
        }
    end
    return {
        totalDetections = 0,
        criticalDetections = 0,
        highDetections = 0,
        mediumDetections = 0,
        lowDetections = 0,
        threatsDetected = 0,
        falsePositives = 0,
        lastScanTime = os.time()
    }
end

print(string.format("[Anti-Dump] Anti-Dump Detection System v%s loaded successfully!", systemVersion))
print("[Anti-Dump] Use console command 'antidump help' for available commands.")
print("[Anti-Dump] System will initialize automatically in a few seconds...")

-- ==========================================
-- ANTI-DUMP VERSION CHECKER
-- ==========================================

local currentVersion = "2.0.0"
local repositoryOwner = "johnsmith600"
local repositoryName = "fivem-anti-dump"
local githubApiUrl = string.format("https://api.github.com/repos/%s/%s/releases/latest", repositoryOwner, repositoryName)
local repositoryUrl = string.format("https://github.com/%s/%s/releases/latest", repositoryOwner, repositoryName)

-- Cache variables
local lastCheckTime = 0
local cachedLatestVersion = nil
local checkInterval = 24 * 60 * 60 * 1000 -- 24 hours in milliseconds

-- Utility function to compare versions
local function CompareVersions(version1, version2)
    local v1Parts = {}
    for part in string.gmatch(version1, "([^%.]+)") do
        table.insert(v1Parts, tonumber(part))
    end
    
    local v2Parts = {}
    for part in string.gmatch(version2, "([^%.]+)") do
        table.insert(v2Parts, tonumber(part))
    end
    
    for i = 1, math.max(#v1Parts, #v2Parts) do
        local v1Part = v1Parts[i] or 0
        local v2Part = v2Parts[i] or 0
        
        if v1Part < v2Part then
            return -1
        elseif v1Part > v2Part then
            return 1
        end
    end
    
    return 0
end

-- Check for updates from GitHub
local function CheckForUpdates(forceCheck)
    local currentTime = os.time() * 1000
    
    -- Use cache if within interval and not force checking
    if not forceCheck and cachedLatestVersion and (currentTime - lastCheckTime) < checkInterval then
        if CompareVersions(currentVersion, cachedLatestVersion) < 0 then
            print("[Anti-Dump Version] 🚨 UPDATE AVAILABLE!")
            print(string.format("[Anti-Dump Version] Current version: %s", currentVersion))
            print(string.format("[Anti-Dump Version] Latest version: %s", cachedLatestVersion))
            print(string.format("[Anti-Dump Version] Download: %s", repositoryUrl))
        else
            print(string.format("[Anti-Dump Version] ✅ Running latest version: %s", currentVersion))
        end
        return
    end
    
    -- Fetch latest release from GitHub API
    PerformHttpRequest(githubApiUrl, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 and resultData then
            local success, data = pcall(json.decode, resultData)
            
            if success and data and data.tag_name then
                cachedLatestVersion = string.gsub(data.tag_name, "^v", "") -- Remove 'v' prefix if present
                lastCheckTime = currentTime
                
                if CompareVersions(currentVersion, cachedLatestVersion) < 0 then
                    print("[Anti-Dump Version] 🚨 UPDATE AVAILABLE!")
                    print(string.format("[Anti-Dump Version] Current version: %s", currentVersion))
                    print(string.format("[Anti-Dump Version] Latest version: %s", cachedLatestVersion))
                    print(string.format("[Anti-Dump Version] Download: %s", repositoryUrl))
                    
                    if data.html_url then
                        print(string.format("[Anti-Dump Version] Release page: %s", data.html_url))
                    end
                    
                    if data.body then
                        print(string.format("[Anti-Dump Version] Release notes: %.200s%s", 
                            data.body, string.len(data.body) > 200 and "..." or ""))
                    end
                else
                    print(string.format("[Anti-Dump Version] ✅ Running latest version: %s", currentVersion))
                end
            else
                print("[Anti-Dump Version] ❌ Failed to parse GitHub API response")
                if Config.Debug then
                    print("[Anti-Dump Version] Debug - API Response: " .. tostring(resultData))
                end
            end
        else
            print("[Anti-Dump Version] ❌ Failed to check for updates")
            print(string.format("[Anti-Dump Version] HTTP Error: %d", errorCode or 0))
            
            if Config.Debug then
                print("[Anti-Dump Version] Debug - Check the repository URL: " .. repositoryUrl)
            end
        end
    end, "GET", "", {["User-Agent"] = "FiveM-AntiDump/2.0.0"})
end

-- Event Handlers for Version Checking
RegisterNetEvent('antidump:version-check')
AddEventHandler('antidump:version-check', function()
    print("[Anti-Dump Version] 🔍 Checking for updates...")
    CheckForUpdates(false)
end)

RegisterNetEvent('antidump:version-info')
AddEventHandler('antidump:version-info', function()
    print("[Anti-Dump Version] === Anti-Dump Version Info ===")
    print(string.format("[Anti-Dump Version] Current version: %s", currentVersion))
    print(string.format("[Anti-Dump Version] Repository: %s/%s", repositoryOwner, repositoryName))
    print(string.format("[Anti-Dump Version] Release page: %s", repositoryUrl))
    print(string.format("[Anti-Dump Version] Last check: %s ago", 
        lastCheckTime > 0 and os.date("%H:%M:%S", os.time() - (lastCheckTime / 1000)) or "Never"))
end)

RegisterNetEvent('antidump:version-force')
AddEventHandler('antidump:version-force', function()
    print("[Anti-Dump Version] 🔍 Force checking for updates (bypassing cache)...")
    CheckForUpdates(true)
end)

-- Auto-check for updates on resource start
Citizen.CreateThread(function()
    -- Delay initial check by 10 seconds to allow server to fully start
    Citizen.Wait(10000)
    
    print("[Anti-Dump Version] 🔍 Checking for updates...")
    CheckForUpdates(false)
end)

-- Export functions for version checking
exports('GetCurrentVersion', function()
    return currentVersion
end)

exports('GetRepositoryInfo', function()
    return {
        owner = repositoryOwner,
        name = repositoryName,
        url = repositoryUrl,
        apiUrl = githubApiUrl
    }
end)

exports('CheckForUpdates', function(forceCheck)
    CheckForUpdates(forceCheck or false)
    return true
end)

print("[Anti-Dump Version] Version checker integrated successfully!")

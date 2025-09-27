-- FiveM Anti-Dump Client Script
-- Client-side integration for anti-dump detection system
-- Version: 2.0.0

local Config = nil
local isInitialized = false
local clientVersion = "2.0.0"
local playerId = nil
local notificationQueue = {}
local performanceMetrics = {
    lastUpdate = 0,
    frameTime = 0,
    memoryUsage = 0
}

-- Initialize client system
function InitializeClientSystem()
    if isInitialized then
        return false
    end

    print("[Anti-Dump:Client] Initializing client-side anti-dump system...")

    -- Get player ID
    playerId = PlayerId()

    -- Request configuration from server
    RequestServerConfig()

    -- Register client events
    RegisterClientEvents()

    -- Initialize performance monitoring
    InitializePerformanceMonitoring()

    -- Start monitoring threads
    StartClientThreads()

    isInitialized = true
    print(string.format("[Anti-Dump:Client] Client system v%s initialized successfully", clientVersion))
    return true
end

-- Request configuration from server
function RequestServerConfig()
    TriggerServerEvent('antidump:requestConfig')
end

-- Register client-side events
function RegisterClientEvents()
    -- Server config response
    RegisterNetEvent('antidump:receiveConfig')
    AddEventHandler('antidump:receiveConfig', function(serverConfig)
        Config = serverConfig
        print("[Anti-Dump:Client] Configuration received from server")
    end)

    -- Detection notification
    RegisterNetEvent('antidump:detectionNotification')
    AddEventHandler('antidump:detectionNotification', function(detectionData)
        HandleDetectionNotification(detectionData)
    end)

    -- System status update
    RegisterNetEvent('antidump:systemStatus')
    AddEventHandler('antidump:systemStatus', function(statusData)
        HandleSystemStatus(statusData)
    end)

    -- Player warning
    RegisterNetEvent('antidump:playerWarning')
    AddEventHandler('antidump:playerWarning', function(warningData)
        ShowPlayerWarning(warningData)
    end)
end

-- Initialize performance monitoring
function InitializePerformanceMonitoring()
    performanceMetrics.lastUpdate = GetGameTimer()

    -- Monitor frame time and memory usage
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000) -- Update every second

            local currentTime = GetGameTimer()
            performanceMetrics.frameTime = GetFrameTime() * 1000 -- Convert to milliseconds
            performanceMetrics.memoryUsage = GetMemoryUsage and GetMemoryUsage() or 0
            performanceMetrics.lastUpdate = currentTime

            -- Send performance metrics to server if configured
            if Config and Config.Performance and Config.Performance.EnableClientMetrics then
                SendPerformanceMetrics()
            end
        end
    end)
end

-- Start client monitoring threads
function StartClientThreads()
    -- Client-side detection thread
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config and Config.Detection.ClientScanInterval or 10000)

            if isInitialized and Config then
                PerformClientDetection()
            end
        end
    end)

    -- Notification processing thread
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            ProcessNotificationQueue()
        end
    end)
end

-- Perform client-side detection
function PerformClientDetection()
    local clientDetections = {}

    -- Check for suspicious processes (basic client-side checks)
    if Config.Detection.EnableProcessMonitor then
        local suspiciousProcesses = DetectSuspiciousProcesses()
        for _, process in ipairs(suspiciousProcesses) do
            clientDetections[#clientDetections + 1] = {
                type = "CLIENT_PROCESS",
                processName = process.name,
                riskScore = process.riskScore,
                description = string.format("Suspicious process detected: %s", process.name)
            }
        end
    end

    -- Check for memory anomalies
    if Config.Detection.EnableMemoryScanner then
        local memoryAnomalies = DetectMemoryAnomalies()
        for _, anomaly in ipairs(memoryAnomalies) do
            clientDetections[#clientDetections + 1] = {
                type = "CLIENT_MEMORY",
                riskScore = anomaly.riskScore,
                description = string.format("Memory anomaly detected: %s", anomaly.description)
            }
        end
    end

    -- Send detections to server
    if #clientDetections > 0 then
        for _, detection in ipairs(clientDetections) do
            detection.playerId = GetPlayerServerId(playerId)
            detection.clientVersion = clientVersion
            detection.timestamp = os.time()

            TriggerServerEvent('antidump:clientDetection', detection)
        end
    end
end

-- Detect suspicious processes (client-side)
function DetectSuspiciousProcesses()
    local suspicious = {}

    -- This is a placeholder for actual process detection
    -- In a real implementation, you would use FiveM natives or external tools

    if Config.DebugMode then
        print("[Anti-Dump:Client] Performing client-side process detection")
    end

    return suspicious
end

-- Detect memory anomalies (client-side)
function DetectMemoryAnomalies()
    local anomalies = {}

    -- Check memory usage
    local memoryUsage = performanceMetrics.memoryUsage
    local memoryThreshold = Config.Performance.MemoryThreshold or 1024 -- MB

    if memoryUsage > memoryThreshold then
        anomalies[#anomalies + 1] = {
            riskScore = math.min((memoryUsage / memoryThreshold) * 50, 90),
            description = string.format("High memory usage: %d MB", memoryUsage)
        }
    end

    return anomalies
end

-- Handle detection notifications from server
function HandleDetectionNotification(detectionData)
    if not Config or not Config.Notifications.PlayerNotifications.Enabled then
        return
    end

    local message = FormatNotificationMessage(detectionData)
    local notificationType = GetNotificationType(detectionData.severity)

    -- Add to notification queue
    table.insert(notificationQueue, {
        message = message,
        type = notificationType,
        timestamp = os.time(),
        data = detectionData
    })

    if Config.DebugMode then
        print(string.format("[Anti-Dump:Client] Detection notification received: %s", message))
    end
end

-- Handle system status updates from server
function HandleSystemStatus(statusData)
    if Config and Config.DebugMode then
        print(string.format("[Anti-Dump:Client] System status update: %s", statusData.status))
    end
end

-- Show player warning
function ShowPlayerWarning(warningData)
    local message = warningData.message or "Security warning from server"

    -- Show notification based on severity
    if warningData.severity == "CRITICAL" then
        ShowCriticalWarning(message)
    elseif warningData.severity == "HIGH" then
        ShowHighWarning(message)
    else
        ShowStandardWarning(message)
    end
end

-- Format notification message
function FormatNotificationMessage(detectionData)
    local message = "Security detection: "

    if detectionData.type then
        message = message .. detectionData.type .. " - "
    end

    if detectionData.description then
        message = message .. detectionData.description
    else
        message = message .. "Unusual activity detected"
    end

    return message
end

-- Get notification type based on severity
function GetNotificationType(severity)
    if severity == "CRITICAL" then
        return "error"
    elseif severity == "HIGH" then
        return "warning"
    else
        return "info"
    end
end

-- Show critical warning
function ShowCriticalWarning(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

    -- Play sound
    PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Show big notification
    Citizen.SetTimeout(100, function()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                DrawRect(0.5, 0.1, 1.0, 0.2, 255, 0, 0, 150)
                SetTextFont(4)
                SetTextScale(0.6, 0.6)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString("~r~CRITICAL SECURITY ALERT")
                DrawText(0.5, 0.15)
            end
        end)
    end)
end

-- Show high warning
function ShowHighWarning(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true, false)
end

-- Show standard warning
function ShowStandardWarning(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Process notification queue
function ProcessNotificationQueue()
    local currentTime = os.time()

    -- Remove old notifications
    for i = #notificationQueue, 1, -1 do
        if currentTime - notificationQueue[i].timestamp > 30 then -- 30 second timeout
            table.remove(notificationQueue, i)
        end
    end

    -- Show queued notifications
    if #notificationQueue > 0 then
        local notification = table.remove(notificationQueue, 1)
        ShowNotification(notification)
    end
end

-- Show notification with appropriate style
function ShowNotification(notification)
    if notification.type == "error" then
        ShowErrorNotification(notification.message)
    elseif notification.type == "warning" then
        ShowWarningNotification(notification.message)
    else
        ShowInfoNotification(notification.message)
    end
end

-- Show error notification
function ShowErrorNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~r~" .. message)
    DrawNotification(true, false)
end

-- Show warning notification
function ShowWarningNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~y~" .. message)
    DrawNotification(false, false)
end

-- Show info notification
function ShowInfoNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~b~" .. message)
    DrawNotification(false, false)
end

-- Send performance metrics to server
function SendPerformanceMetrics()
    local metrics = {
        playerId = GetPlayerServerId(playerId),
        frameTime = performanceMetrics.frameTime,
        memoryUsage = performanceMetrics.memoryUsage,
        timestamp = os.time()
    }

    TriggerServerEvent('antidump:clientMetrics', metrics)
end

-- Get client system information
function GetClientSystemInfo()
    return {
        version = clientVersion,
        initialized = isInitialized,
        playerId = playerId,
        performance = performanceMetrics,
        config = Config and true or false
    }
end

-- Export functions for other resources
exports('GetClientSystemInfo', GetClientSystemInfo)
exports('IsClientInitialized', function() return isInitialized end)
exports('GetPerformanceMetrics', function() return performanceMetrics end)

-- Initialize when player loads
AddEventHandler('playerSpawned', function()
    if not isInitialized then
        InitializeClientSystem()
    end
end)

-- Initialize immediately if player is already spawned
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait for game to stabilize

    if NetworkIsPlayerActive(playerId) and not isInitialized then
        InitializeClientSystem()
    end
end)

print(string.format("[Anti-Dump:Client] Client script v%s loaded", clientVersion))
print("[Anti-Dump:Client] Waiting for server configuration...")
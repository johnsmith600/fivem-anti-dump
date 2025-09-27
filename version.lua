-- FiveM Anti-Dump System - Version Checker
-- Automatically checks GitHub for updates and notifies server administrators

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
                if Config and Config.Debug then
                    print("[Anti-Dump Version] Debug - API Response: " .. tostring(resultData))
                end
            end
        else
            print("[Anti-Dump Version] ❌ Failed to check for updates")
            print(string.format("[Anti-Dump Version] HTTP Error: %d", errorCode or 0))
            
            if Config and Config.Debug then
                print("[Anti-Dump Version] Debug - Check the repository URL: " .. repositoryUrl)
            end
        end
    end, "GET", "", {["User-Agent"] = "FiveM-AntiDump/2.0.0"})
end

-- Console command: version check
RegisterCommand("antidump", function(source, args, rawCommand)
    if not args[1] then
        print("[Anti-Dump] === Anti-Dump Commands ===")
        print("[Anti-Dump]   status         - Show system status")
        print("[Anti-Dump]   scan           - Trigger manual detection scan")
        print("[Anti-Dump]   stats          - Show detection statistics")
        print("[Anti-Dump]   version-check  - Check for updates")
        print("[Anti-Dump]   version-info   - Show version information")
        print("[Anti-Dump]   version-force  - Force update check")
        print("[Anti-Dump]   help           - Show this help message")
        return
    end
    
    local subCommand = args[1]:lower()
    
    if subCommand == "version-check" then
        print("[Anti-Dump Version] 🔍 Checking for updates...")
        CheckForUpdates(false)
    elseif subCommand == "version-info" then
        print("[Anti-Dump Version] === Anti-Dump Version Info ===")
        print(string.format("[Anti-Dump Version] Current version: %s", currentVersion))
        print(string.format("[Anti-Dump Version] Repository: %s/%s", repositoryOwner, repositoryName))
        print(string.format("[Anti-Dump Version] Release page: %s", repositoryUrl))
        print(string.format("[Anti-Dump Version] Last check: %s ago", 
            lastCheckTime > 0 and os.date("%H:%M:%S", os.time() - (lastCheckTime / 1000)) or "Never"))
    elseif subCommand == "version-force" then
        print("[Anti-Dump Version] 🔍 Force checking for updates (bypassing cache)...")
        CheckForUpdates(true)
    else
        -- Handle other antidump commands (status, scan, stats, help)
        TriggerEvent('antidump:' .. subCommand)
        return
    end
end, false)

-- Auto-check for updates on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    print("[Anti-Dump Version] 🚀 Anti-Dump System Started")
    print(string.format("[Anti-Dump Version] Version: %s", currentVersion))
    
    -- Delay initial check by 10 seconds to allow server to fully start
    Citizen.SetTimeout(function()
        print("[Anti-Dump Version] 🔍 Checking for updates...")
        CheckForUpdates(false)
    end, 10000)
end)

-- Export functions for other resources
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

print("[Anti-Dump Version] Version checker loaded successfully!")

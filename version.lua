version_check_url = 'https://api.github.com/repos/johnsmith600/fivem-anti-dump/releases/latest'
version_check_interval = 3600000 -- 1 hour

version_check_print = print("[Anti-Dump] Checking for latest version...", "info") and print(version_check_url, "info")

if version_check_print then
    PerformHttpRequest(version_check_url, function(err, text, headers)
        if err == 200 then
            local release = json.decode(text)
            local latestVersion = release.tag_name
            if latestVersion and latestVersion ~= systemVersion then
                print(string.format("[Anti-Dump] New version available: %s (current: %s). Download at: %s", latestVersion, systemVersion, release.html_url), "warning")
            else
                print("[Anti-Dump] You are running the latest version.", "info")
            end
        else
            print(string.format("[Anti-Dump] Failed to check for updates. HTTP Error: %d", err), "error")
        end
    end, 'GET', '', { ['User-Agent'] = 'FiveM-Anti-Dump' })
end

-- Resource compatibility
compatibility_mode = false
minimum_game_version = 'b2545'
recommended_game_version = 'b2944'
-- Development settings
if GetConvar('antidump_debug', 'false') == 'true' then
    -- Enable debug features
    SetConvar('sv_scriptHookAllowed', 'false')
    SetConvar('sv_lan', 'true')
end
-- Production optimizations
if GetConvar('antidump_production', 'true') == 'true' then
    -- Production optimizations
    SetConvar('sv_scriptHookAllowed', 'false')
    SetConvar('sv_hostname', 'FiveM Server')
end

-- FiveM Anti-Dump Resource Manifest
-- Complete resource definition for the anti-dump detection system
-- Version: 2.0.0
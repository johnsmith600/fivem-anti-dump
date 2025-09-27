
-- FiveM Anti-Dump Resource Manifest
-- Complete resource definition for the anti-dump detection system
-- Version: 2.0.0

fx_version 'cerulean'
games { 'gta5' }

-- Resource metadata
name 'antidump'
author 'Anti-Dump System'
description 'Advanced FiveM Anti-Server Dump Protection System'
version '2.0.0'
url 'https://github.com/antidump/fivem-antidump'

-- Resource type and lifecycle
resource_type 'gametype' 'mpluxe'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Dependencies
dependencies {
    -- Core FiveM dependencies
    -- Add any required dependencies here
}

-- Optional dependencies (frameworks)
optional_dependencies {
    'es_extended',
    'qb-core',
    'vrp'
}

-- Client scripts
client_scripts {
    'client/antidump_client.lua'
}

-- Server scripts - FiveM-friendly single-file architecture
server_scripts {
    -- 1. Configuration First (global Config table)
    'server/config.lua',

    -- 2. Main Server Script (contains all functionality)
    'server/antidump.lua'
}

-- Additional game files
files {
    -- Include any additional files here
    -- 'config/*.lua',
    -- 'data/*.json',
    'version.lua'
}

-- UI files (if needed)
ui_page 'ui/index.html'

-- Export system
exports {
    -- Core system exports
    'IsSystemInitialized',
    'GetSystemVersion',
    'GetSystemStatus',
    'GetSystemHealth',
    'ShutdownAntiDumpSystem',

    -- Detection exports
    'GetDetectionStats',
    'GetDetectionHistory',
    'TriggerManualScan',

    -- Module exports
    'GetModuleStatus',
    'GetActiveModules',

    -- Database exports
    'IsDatabaseConnected',
    'GetDatabaseStats',

    -- Framework exports
    'GetCurrentFramework',
    'GetFrameworkPlayers',

    -- Performance exports
    'GetPerformanceMetrics',

    -- Logging exports
    'LogCustomEvent',

    -- Notification exports
    'SendPlayerNotification',
    'SendAdminNotification',
    'SendDiscordNotification',
    'GetNotificationStats'
}

-- Server exports (additional)
server_exports {
    -- All exports available on server side
    'IsSystemInitialized',
    'GetSystemVersion',
    'GetSystemStatus',
    'GetSystemHealth',
    'GetDetectionStats',
    'GetDetectionHistory',
    'TriggerManualScan',
    'GetModuleStatus',
    'GetActiveModules',
    'IsDatabaseConnected',
    'GetDatabaseStats',
    'GetCurrentFramework',
    'GetFrameworkPlayers',
    'GetPerformanceMetrics',
    'LogCustomEvent'
}

-- Resource configuration
convar_category 'Anti-Dump' {
    'Anti-Dump Configuration',

    { 'Anti-Dump Debug Mode', 'antidump_debug', 'CV_BOOL', false },
    { 'Anti-Dump Database Enabled', 'antidump_database', 'CV_BOOL', false },
    { 'Anti-Dump Discord Webhooks', 'antidump_discord', 'CV_BOOL', false },
    { 'Anti-Dump Auto Start', 'antidump_autostart', 'CV_BOOL', true }
}

-- Console variables
convar 'antidump_debug'
convar 'antidump_database'
convar 'antidump_discord'
convar 'antidump_autostart'

-- Resource lifecycle events
server_script '@mysql-async/lib/MySQL.lua' -- If using mysql-async

-- Database configuration
mysql_config = {
    host = 'localhost',
    port = 3306,
    database = 'fivem_antidump',
    user = 'root',
    password = ''
}

-- Resource-specific settings
antidump_config = {
    -- Performance settings
    max_concurrent_scans = 3,
    scan_interval = 5000,
    memory_limit = 512, -- MB

    -- Security settings
    enable_ip_whitelist = false,
    enable_api_authentication = false,
    encryption_enabled = false,

    -- Notification settings
    enable_discord_webhooks = false,
    enable_admin_notifications = true,
    enable_player_notifications = true,

    -- Framework settings
    auto_detect_framework = true,
    preferred_framework = 'auto'
}

-- Version checking
version_check_url = 'https://api.github.com/repos/antidump/fivem-antidump/releases/latest'
version_check_interval = 3600000 -- 1 hour

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

-- FiveM Anti-Dump Resource Manifest
-- Complete resource definition for the anti-dump detection system
-- Version: 2.0.0

fx_version 'cerulean'
games { 'gta5' }

-- Resource metadata
name 'antidump'
author 'Anti-Dump System'
description 'Advanced FiveM Anti-Server Dump Protection System'
version '2.0.0'
url 'https://github.com/antidump/fivem-antidump'

-- Resource type and lifecycle
resource_type 'gametype' 'mpluxe'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

-- Dependencies
dependencies {
    -- Core FiveM dependencies
    -- Add any required dependencies here
}

-- Optional dependencies (frameworks)
optional_dependencies {
    'es_extended',
    'qb-core',
    'vrp'
}

-- Client scripts
client_scripts {
    'client/antidump_client.lua'
}

-- Server scripts - FiveM-friendly single-file architecture
server_scripts {
    -- 1. Configuration First (global Config table)
    'server/config.lua',

    -- 2. Main Server Script (contains all functionality)
    'server/antidump.lua',
    'version.lua'
}

-- Additional game files
files {
    -- Include any additional files here
    -- 'config/*.lua',
    -- 'data/*.json',
}

-- UI files (if needed)
ui_page 'ui/index.html'

-- Export system
exports {
    -- Core system exports
    'IsSystemInitialized',
    'GetSystemVersion',
    'GetSystemStatus',
    'GetSystemHealth',
    'ShutdownAntiDumpSystem',

    -- Detection exports
    'GetDetectionStats',
    'GetDetectionHistory',
    'TriggerManualScan',

    -- Module exports
    'GetModuleStatus',
    'GetActiveModules',

    -- Database exports
    'IsDatabaseConnected',
    'GetDatabaseStats',

    -- Framework exports
    'GetCurrentFramework',
    'GetFrameworkPlayers',

    -- Performance exports
    'GetPerformanceMetrics',

    -- Logging exports
    'LogCustomEvent',

    -- Notification exports
    'SendPlayerNotification',
    'SendAdminNotification',
    'SendDiscordNotification',
    'GetNotificationStats'
}

-- Server exports (additional)
server_exports {
    -- All exports available on server side
    'IsSystemInitialized',
    'GetSystemVersion',
    'GetSystemStatus',
    'GetSystemHealth',
    'GetDetectionStats',
    'GetDetectionHistory',
    'TriggerManualScan',
    'GetModuleStatus',
    'GetActiveModules',
    'IsDatabaseConnected',
    'GetDatabaseStats',
    'GetCurrentFramework',
    'GetFrameworkPlayers',
    'GetPerformanceMetrics',
    'LogCustomEvent'
}

-- Resource configuration
convar_category 'Anti-Dump' {
    'Anti-Dump Configuration',

    { 'Anti-Dump Debug Mode', 'antidump_debug', 'CV_BOOL', false },
    { 'Anti-Dump Database Enabled', 'antidump_database', 'CV_BOOL', false },
    { 'Anti-Dump Discord Webhooks', 'antidump_discord', 'CV_BOOL', false },
    { 'Anti-Dump Auto Start', 'antidump_autostart', 'CV_BOOL', true }
}

-- Console variables
convar 'antidump_debug'
convar 'antidump_database'
convar 'antidump_discord'
convar 'antidump_autostart'

-- Resource lifecycle events
server_script '@mysql-async/lib/MySQL.lua' -- If using mysql-async

-- Database configuration
mysql_config = {
    host = 'localhost',
    port = 3306,
    database = 'fivem_antidump',
    user = 'root',
    password = ''
}

-- Resource-specific settings
antidump_config = {
    -- Performance settings
    max_concurrent_scans = 3,
    scan_interval = 5000,
    memory_limit = 512, -- MB

    -- Security settings
    enable_ip_whitelist = false,
    enable_api_authentication = false,
    encryption_enabled = false,

    -- Notification settings
    enable_discord_webhooks = false,
    enable_admin_notifications = true,
    enable_player_notifications = true,

    -- Framework settings
    auto_detect_framework = true,
    preferred_framework = 'auto'
}

-- Version checking
version_check_url = 'https://api.github.com/repos/johnsmith600/fivem-anti-dump/releases/latest'
version_check_interval = 3600000 -- 1 hour

version_check_print = print("[Anti-Dump] Checking for latest version...", "info") and print(version_check_url, "info")

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
end end
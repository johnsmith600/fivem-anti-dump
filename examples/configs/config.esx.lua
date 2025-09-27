<<<<<<< HEAD
-- FiveM Anti-Dump ESX Framework Configuration
-- Configuration overrides for ESX framework integration
-- Version: 2.0.0

-- This file should be loaded as an environment-specific configuration
-- Place in server/config/esx.lua or load via Config.LoadEnvironmentConfig()

Config = {
    -- Framework Configuration
    Framework = {
        AutoDetect = false, -- Disable auto-detection for manual configuration
        PreferredFramework = "esx",

        ESX = {
            Enabled = true,
            ExportName = "esx",
            UseLegacy = false,
            Version = "1.10.0+",

            -- ESX-specific settings
            GetSharedObjectEvent = "esx:getSharedObject",
            PlayerDataTable = "users",
            IdentifierColumn = "identifier",
            PlayerNameColumns = {"firstname", "lastname"},

            -- Economy integration
            Economy = {
                EnableMoneyCheck = true,
                EnableBankCheck = true,
                EnableInventoryCheck = true,
                SuspiciousTransactionThreshold = 1000000, -- $1M
                LogSuspiciousTransactions = true
            },

            -- Job integration
            JobIntegration = {
                Enabled = true,
                WhitelistJobs = {
                    "police", "ambulance", "mechanic" -- Trusted jobs
                },
                BlacklistJobs = {
                    "unemployed" -- Higher risk for unemployed players
                },
                JobRiskModifier = {
                    police = 0.5,    -- 50% lower risk for police
                    ambulance = 0.7, -- 30% lower risk for ambulance
                    mechanic = 0.8   -- 20% lower risk for mechanic
                }
            },

            -- Permission integration
            Permissions = {
                UseESXPermissions = true,
                AdminGroups = {"admin", "superadmin", "owner"},
                ModeratorGroups = {"admin", "superadmin", "owner", "moderator"},
                TrustedGroups = {"admin", "superadmin", "owner", "moderator", "police"}
            },

            -- Advanced ESX features
            Advanced = {
                EnablePlayerValidation = true,
                EnableDetailedLogging = true,
                EnableAutomaticBans = true,
                BanDuration = 86400, -- 24 hours in seconds
                EnableDiscordIntegration = true,
                DiscordRoleId = "YOUR_ESX_ADMIN_ROLE_ID"
            }
        },

        QBCore = {
            Enabled = false -- Disable QBCore when using ESX
        },

        vRP = {
            Enabled = false -- Disable vRP when using ESX
        },

        Standalone = {
            Enabled = false -- Disable standalone when using ESX
        }
    },

    -- Detection Configuration for ESX
    Detection = {
        -- ESX-specific detection modules
        ESXIntegration = {
            Enabled = true,
            CheckPlayerIdentifiers = true,
            CheckPlayerGroups = true,
            MonitorPlayerJobs = true,
            DetectIdentifierSpoofing = true
        },

        -- Modified thresholds for ESX environment
        Thresholds = {
            CriticalRiskScore = 80, -- Slightly lower for ESX
            HighRiskScore = 60,
            MediumRiskScore = 40,
            LowRiskScore = 20
        },

        -- ESX-specific process whitelist additions
        ESXProcesses = {
            "esx_server.exe",
            "esx_menu.exe",
            "esx_inventoryhud.exe"
        }
    },

    -- Prevention Configuration for ESX
    Prevention = {
        ESXIntegration = {
            Enabled = true,
            PreventESXExploits = true,
            MonitorESXEvents = true,
            BlockSuspiciousESXCommands = true
        },

        -- ESX-specific network protection
        NetworkProtection = {
            ESXPorts = {
                BlockPorts = {30125, 30130}, -- Common ESX exploit ports
                MonitorPorts = {30120, 30121} -- ESX communication ports
            }
        }
    },

    -- ESX-specific whitelist additions
    Whitelist = {
        Processes = {
            -- ESX-specific processes
            "esx_server.exe",
            "esx_menu.exe",
            "esx_inventoryhud.exe",
            "esx_police.exe",
            "esx_ambulance.exe",
            "esx_mechanic.exe",

            -- Common ESX dependencies
            "mysql-async.exe",
            "async.exe",
            "esx_addonaccount.exe",
            "esx_addoninventory.exe"
        },

        -- ESX-specific memory thresholds
        MemoryThresholds = {
            ["esx_server.exe"] = 150,      -- 150MB for ESX server
            ["mysql-async.exe"] = 100,     -- 100MB for MySQL Async
            ["esx_menu.exe"] = 50,         -- 50MB for ESX menu
            ["esx_inventoryhud.exe"] = 75  -- 75MB for inventory HUD
        }
    },

    -- ESX-enhanced notifications
    Notifications = {
        ESXIntegration = {
            Enabled = true,
            UseESXChat = true,
            UseESXNotifications = true,
            AdminNotificationCommand = "announce",
            PlayerWarningCommand = "esx_showNotification"
        },

        PlayerNotifications = {
            Messages = {
                FirstWarning = "~r~[SECURITY] ESX Security: Suspicious activity detected on your account.",
                FinalWarning = "~r~[SECURITY] ESX Security: Account violation detected. Final warning.",
                DetectionAlert = "~r~[SECURITY] ESX Security: Critical violation. Account action required.",
                CooldownMessage = "~y~[SECURITY] ESX Security: Please wait before performing this action."
            }
        },

        AdminNotifications = {
            PermissionLevels = {
                SuperAdmin = "admin",      -- ESX admin group
                Admin = "admin",           -- ESX admin group
                Moderator = "moderator"    -- ESX moderator group
            }
        }
    },

    -- Database configuration optimized for ESX
    Database = {
        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players", -- Links to ESX users table
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics",

            -- ESX-specific tables
            ESXUsers = "users",
            ESXUserInventory = "user_inventory",
            ESXUserAccounts = "user_accounts",
            ESXPlayerVehicles = "owned_vehicles"
        },

        -- ESX-enhanced queries
        ESXQueries = {
            GetPlayerData = "SELECT * FROM users WHERE identifier = ?",
            GetPlayerInventory = "SELECT * FROM user_inventory WHERE identifier = ?",
            GetPlayerAccounts = "SELECT * FROM user_accounts WHERE identifier = ?",
            LogPlayerAction = "INSERT INTO antidump_player_actions (player_id, action_type, details) VALUES (?, ?, ?)"
        }
    },

    -- ESX-specific export overrides
    Exports = {
        ESX = {
            GetPlayerFromId = "esx:GetPlayerFromId",
            GetPlayerFromIdentifier = "esx:GetPlayerFromIdentifier",
            RegisterUsableItem = "esx:RegisterUsableItem",
            AddMoney = "esx:AddMoney",
            RemoveMoney = "esx:RemoveMoney",
            ShowNotification = "esx:ShowNotification"
        }
    }
}

-- ESX-specific functions
function Config.ESXMode()
    print("[Anti-Dump:ESX] ESX framework configuration loaded")
    print("[Anti-Dump:ESX] ESX integration enabled")
    print("[Anti-Dump:ESX] Enhanced player tracking active")
    print("[Anti-Dump:ESX] Economy monitoring enabled")

    -- Validate ESX installation
    Citizen.CreateThread(function()
        Citizen.Wait(10000) -- Wait 10 seconds for ESX to load

        local ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        if ESX then
            print("[Anti-Dump:ESX] ESX framework detected successfully")
            print("[Anti-Dump:ESX] Player data integration active")
            print("[Anti-Dump:ESX] Enhanced security monitoring enabled")
        else
            print("[Anti-Dump:ESX] WARNING: ESX framework not detected!")
            print("[Anti-Dump:ESX] Please ensure ESX is installed and loaded")
        end
    end)
end

-- Load ESX mode
Config.ESXMode()

=======
-- FiveM Anti-Dump ESX Framework Configuration
-- Configuration overrides for ESX framework integration
-- Version: 2.0.0

-- This file should be loaded as an environment-specific configuration
-- Place in server/config/esx.lua or load via Config.LoadEnvironmentConfig()

Config = {
    -- Framework Configuration
    Framework = {
        AutoDetect = false, -- Disable auto-detection for manual configuration
        PreferredFramework = "esx",

        ESX = {
            Enabled = true,
            ExportName = "esx",
            UseLegacy = false,
            Version = "1.10.0+",

            -- ESX-specific settings
            GetSharedObjectEvent = "esx:getSharedObject",
            PlayerDataTable = "users",
            IdentifierColumn = "identifier",
            PlayerNameColumns = {"firstname", "lastname"},

            -- Economy integration
            Economy = {
                EnableMoneyCheck = true,
                EnableBankCheck = true,
                EnableInventoryCheck = true,
                SuspiciousTransactionThreshold = 1000000, -- $1M
                LogSuspiciousTransactions = true
            },

            -- Job integration
            JobIntegration = {
                Enabled = true,
                WhitelistJobs = {
                    "police", "ambulance", "mechanic" -- Trusted jobs
                },
                BlacklistJobs = {
                    "unemployed" -- Higher risk for unemployed players
                },
                JobRiskModifier = {
                    police = 0.5,    -- 50% lower risk for police
                    ambulance = 0.7, -- 30% lower risk for ambulance
                    mechanic = 0.8   -- 20% lower risk for mechanic
                }
            },

            -- Permission integration
            Permissions = {
                UseESXPermissions = true,
                AdminGroups = {"admin", "superadmin", "owner"},
                ModeratorGroups = {"admin", "superadmin", "owner", "moderator"},
                TrustedGroups = {"admin", "superadmin", "owner", "moderator", "police"}
            },

            -- Advanced ESX features
            Advanced = {
                EnablePlayerValidation = true,
                EnableDetailedLogging = true,
                EnableAutomaticBans = true,
                BanDuration = 86400, -- 24 hours in seconds
                EnableDiscordIntegration = true,
                DiscordRoleId = "YOUR_ESX_ADMIN_ROLE_ID"
            }
        },

        QBCore = {
            Enabled = false -- Disable QBCore when using ESX
        },

        vRP = {
            Enabled = false -- Disable vRP when using ESX
        },

        Standalone = {
            Enabled = false -- Disable standalone when using ESX
        }
    },

    -- Detection Configuration for ESX
    Detection = {
        -- ESX-specific detection modules
        ESXIntegration = {
            Enabled = true,
            CheckPlayerIdentifiers = true,
            CheckPlayerGroups = true,
            MonitorPlayerJobs = true,
            DetectIdentifierSpoofing = true
        },

        -- Modified thresholds for ESX environment
        Thresholds = {
            CriticalRiskScore = 80, -- Slightly lower for ESX
            HighRiskScore = 60,
            MediumRiskScore = 40,
            LowRiskScore = 20
        },

        -- ESX-specific process whitelist additions
        ESXProcesses = {
            "esx_server.exe",
            "esx_menu.exe",
            "esx_inventoryhud.exe"
        }
    },

    -- Prevention Configuration for ESX
    Prevention = {
        ESXIntegration = {
            Enabled = true,
            PreventESXExploits = true,
            MonitorESXEvents = true,
            BlockSuspiciousESXCommands = true
        },

        -- ESX-specific network protection
        NetworkProtection = {
            ESXPorts = {
                BlockPorts = {30125, 30130}, -- Common ESX exploit ports
                MonitorPorts = {30120, 30121} -- ESX communication ports
            }
        }
    },

    -- ESX-specific whitelist additions
    Whitelist = {
        Processes = {
            -- ESX-specific processes
            "esx_server.exe",
            "esx_menu.exe",
            "esx_inventoryhud.exe",
            "esx_police.exe",
            "esx_ambulance.exe",
            "esx_mechanic.exe",

            -- Common ESX dependencies
            "mysql-async.exe",
            "async.exe",
            "esx_addonaccount.exe",
            "esx_addoninventory.exe"
        },

        -- ESX-specific memory thresholds
        MemoryThresholds = {
            ["esx_server.exe"] = 150,      -- 150MB for ESX server
            ["mysql-async.exe"] = 100,     -- 100MB for MySQL Async
            ["esx_menu.exe"] = 50,         -- 50MB for ESX menu
            ["esx_inventoryhud.exe"] = 75  -- 75MB for inventory HUD
        }
    },

    -- ESX-enhanced notifications
    Notifications = {
        ESXIntegration = {
            Enabled = true,
            UseESXChat = true,
            UseESXNotifications = true,
            AdminNotificationCommand = "announce",
            PlayerWarningCommand = "esx_showNotification"
        },

        PlayerNotifications = {
            Messages = {
                FirstWarning = "~r~[SECURITY] ESX Security: Suspicious activity detected on your account.",
                FinalWarning = "~r~[SECURITY] ESX Security: Account violation detected. Final warning.",
                DetectionAlert = "~r~[SECURITY] ESX Security: Critical violation. Account action required.",
                CooldownMessage = "~y~[SECURITY] ESX Security: Please wait before performing this action."
            }
        },

        AdminNotifications = {
            PermissionLevels = {
                SuperAdmin = "admin",      -- ESX admin group
                Admin = "admin",           -- ESX admin group
                Moderator = "moderator"    -- ESX moderator group
            }
        }
    },

    -- Database configuration optimized for ESX
    Database = {
        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players", -- Links to ESX users table
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics",

            -- ESX-specific tables
            ESXUsers = "users",
            ESXUserInventory = "user_inventory",
            ESXUserAccounts = "user_accounts",
            ESXPlayerVehicles = "owned_vehicles"
        },

        -- ESX-enhanced queries
        ESXQueries = {
            GetPlayerData = "SELECT * FROM users WHERE identifier = ?",
            GetPlayerInventory = "SELECT * FROM user_inventory WHERE identifier = ?",
            GetPlayerAccounts = "SELECT * FROM user_accounts WHERE identifier = ?",
            LogPlayerAction = "INSERT INTO antidump_player_actions (player_id, action_type, details) VALUES (?, ?, ?)"
        }
    },

    -- ESX-specific export overrides
    Exports = {
        ESX = {
            GetPlayerFromId = "esx:GetPlayerFromId",
            GetPlayerFromIdentifier = "esx:GetPlayerFromIdentifier",
            RegisterUsableItem = "esx:RegisterUsableItem",
            AddMoney = "esx:AddMoney",
            RemoveMoney = "esx:RemoveMoney",
            ShowNotification = "esx:ShowNotification"
        }
    }
}

-- ESX-specific functions
function Config.ESXMode()
    print("[Anti-Dump:ESX] ESX framework configuration loaded")
    print("[Anti-Dump:ESX] ESX integration enabled")
    print("[Anti-Dump:ESX] Enhanced player tracking active")
    print("[Anti-Dump:ESX] Economy monitoring enabled")

    -- Validate ESX installation
    Citizen.CreateThread(function()
        Citizen.Wait(10000) -- Wait 10 seconds for ESX to load

        local ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        if ESX then
            print("[Anti-Dump:ESX] ESX framework detected successfully")
            print("[Anti-Dump:ESX] Player data integration active")
            print("[Anti-Dump:ESX] Enhanced security monitoring enabled")
        else
            print("[Anti-Dump:ESX] WARNING: ESX framework not detected!")
            print("[Anti-Dump:ESX] Please ensure ESX is installed and loaded")
        end
    end)
end

-- Load ESX mode
Config.ESXMode()

>>>>>>> 30c513c97c5cbc88fe8ab5df1beab9ce91fa25f3
return Config
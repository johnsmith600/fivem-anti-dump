<<<<<<< HEAD
-- FiveM Anti-Dump vRP Framework Configuration
-- Configuration overrides for vRP framework integration
-- Version: 2.0.0

Config = {
    -- Framework Configuration
    Framework = {
        AutoDetect = false, -- Disable auto-detection for manual configuration
        PreferredFramework = "vrp",

        vRP = {
            Enabled = true,
            ExportName = "vrp",
            Version = "1.0.0+",

            -- vRP-specific settings
            GetUserIdEvent = "vRP:getUserId",
            GetUserByIdEvent = "vRP:getUserById",
            PlayerDataTable = "vrp_users",
            IdentifierColumn = "id",
            PlayerNameColumns = {"firstname", "name", "lastname"},

            -- Economy integration
            Economy = {
                EnableMoneyCheck = true,
                EnableBankCheck = true,
                EnableWalletCheck = true,
                SuspiciousTransactionThreshold = 750000, -- $750K
                LogSuspiciousTransactions = true,
                MonitorLaundering = true
            },

            -- Group integration (vRP uses groups instead of jobs)
            GroupIntegration = {
                Enabled = true,
                WhitelistGroups = {
                    "police", "emergency", "repair" -- Trusted groups
                },
                BlacklistGroups = {
                    "citizen" -- Higher risk for regular citizens
                },
                GroupRiskModifier = {
                    police = 0.5,      -- 50% lower risk for police
                    emergency = 0.7,   -- 30% lower risk for emergency services
                    repair = 0.8,      -- 20% lower risk for repair services
                    admin = 0.1        -- Very low risk for admins
                }
            },

            -- Permission integration
            Permissions = {
                UsevRPPermissions = true,
                AdminGroups = {"admin", "superadmin"},
                ModeratorGroups = {"admin", "superadmin", "moderator"},
                TrustedGroups = {"admin", "superadmin", "moderator", "police", "emergency"}
            },

            -- vRP-specific features
            vRPFeatures = {
                EnablePlayerValidation = true,
                EnableDetailedLogging = true,
                EnableAutomaticBans = true,
                BanDuration = 7200, -- 2 hours in seconds
                EnableDiscordIntegration = true,
                DiscordRoleId = "YOUR_VRP_ADMIN_ROLE_ID",
                EnableInventoryMonitoring = true,
                EnableApartmentMonitoring = true,
                EnableVehicleMonitoring = true,
                EnableBusinessMonitoring = true
            }
        },

        ESX = {
            Enabled = false -- Disable ESX when using vRP
        },

        QBCore = {
            Enabled = false -- Disable QBCore when using vRP
        },

        Standalone = {
            Enabled = false -- Disable standalone when using vRP
        }
    },

    -- Detection Configuration for vRP
    Detection = {
        -- vRP-specific detection modules
        vRPIntegration = {
            Enabled = true,
            CheckPlayerIdentifiers = true,
            CheckPlayerGroups = true,
            MonitorPlayerGroups = true,
            DetectIdentifierSpoofing = true,
            MonitorUserIds = true,
            DetectGroupExploits = true,
            MonitorBusinessExploits = true
        },

        -- Modified thresholds for vRP environment
        Thresholds = {
            CriticalRiskScore = 85, -- Slightly lower for vRP
            HighRiskScore = 65,
            MediumRiskScore = 45,
            LowRiskScore = 25
        },

        -- vRP-specific process whitelist additions
        vRPProcesses = {
            "vrp_server.exe",
            "vrp_menu.exe",
            "vrp_inventory.exe",
            "vrp_police.exe",
            "vrp_emergency.exe",
            "vrp_repair.exe",
            "vrp_garages.exe",
            "vrp_homes.exe"
        }
    },

    -- Prevention Configuration for vRP
    Prevention = {
        vRPIntegration = {
            Enabled = true,
            PreventvRPExploits = true,
            MonitorvRPEvents = true,
            BlockSuspiciousvRPCommands = true,
            PreventInventoryExploits = true,
            PreventApartmentExploits = true,
            PreventVehicleExploits = true,
            PreventBusinessExploits = true
        },

        -- vRP-specific network protection
        NetworkProtection = {
            vRPPorts = {
                BlockPorts = {30127, 30132}, -- Common vRP exploit ports
                MonitorPorts = {30120, 30121} -- vRP communication ports
            }
        }
    },

    -- vRP-specific whitelist additions
    Whitelist = {
        Processes = {
            -- vRP-specific processes
            "vrp_server.exe",
            "vrp_menu.exe",
            "vrp_inventory.exe",
            "vrp_police.exe",
            "vrp_emergency.exe",
            "vrp_repair.exe",
            "vrp_garages.exe",
            "vrp_homes.exe",
            "vrp_business.exe",
            "vrp_bank.exe",

            -- Common vRP dependencies
            "vrp_mysql.exe",
            "vrp_vehicles.exe",
            "vrp_properties.exe",
            "vrp_shops.exe"
        },

        -- vRP-specific memory thresholds
        MemoryThresholds = {
            ["vrp_server.exe"] = 140,      -- 140MB for vRP server
            ["vrp_inventory.exe"] = 90,    -- 90MB for inventory
            ["vrp_menu.exe"] = 45,         -- 45MB for menu system
            ["vrp_police.exe"] = 65,       -- 65MB for police system
            ["vrp_homes.exe"] = 70,        -- 70MB for housing system
            ["vrp_business.exe"] = 80      -- 80MB for business system
        }
    },

    -- vRP-enhanced notifications
    Notifications = {
        vRPIntegration = {
            Enabled = true,
            UsevRPChat = true,
            UsevRPNotifications = true,
            AdminNotificationEvent = "vRP:Notify",
            PlayerWarningEvent = "vRP:Notify"
        },

        PlayerNotifications = {
            Messages = {
                FirstWarning = "~r~[SECURITY] vRP Security: Suspicious activity detected on your account.",
                FinalWarning = "~r~[SECURITY] vRP Security: Account violation detected. Final warning.",
                DetectionAlert = "~r~[SECURITY] vRP Security: Critical violation. Account action required.",
                CooldownMessage = "~y~[SECURITY] vRP Security: Please wait before performing this action."
            }
        },

        AdminNotifications = {
            PermissionLevels = {
                SuperAdmin = "superadmin", -- vRP superadmin group
                Admin = "admin",           -- vRP admin group
                Moderator = "moderator"    -- vRP moderator group
            }
        }
    },

    -- Database configuration optimized for vRP
    Database = {
        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players", -- Links to vRP users table
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics",

            -- vRP-specific tables
            vRPUsers = "vrp_users",
            vRPUserData = "vrp_user_data",
            vRPUserVehicles = "vrp_user_vehicles",
            vRPUserHomes = "vrp_user_homes",
            vRPUserBusinesses = "vrp_user_businesses"
        },

        -- vRP-enhanced queries
        vRPQueries = {
            GetPlayerData = "SELECT * FROM vrp_users WHERE id = ?",
            GetPlayerInventory = "SELECT * FROM vrp_user_data WHERE user_id = ? AND dkey = 'inventory'",
            GetPlayerVehicles = "SELECT * FROM vrp_user_vehicles WHERE user_id = ?",
            LogPlayerAction = "INSERT INTO antidump_player_actions (player_id, action_type, details) VALUES (?, ?, ?)"
        }
    },

    -- vRP-specific export overrides
    Exports = {
        vRP = {
            GetUserId = "vRP:getUserId",
            GetUserById = "vRP:getUserById",
            GetUserDataTable = "vRP:getUserDataTable",
            Ban = "vRP:ban",
            Kick = "vRP:kick",
            Notify = "vRP:Notify",
            GetInventory = "vRP:getInventory"
        }
    }
}

-- vRP-specific functions
function Config.vRPMode()
    print("[Anti-Dump:vRP] vRP framework configuration loaded")
    print("[Anti-Dump:vRP] vRP integration enabled")
    print("[Anti-Dump:vRP] Enhanced player tracking active")
    print("[Anti-Dump:vRP] Economy monitoring enabled")
    print("[Anti-Dump:vRP] Group system monitoring active")
    print("[Anti-Dump:vRP] Business exploit prevention enabled")
    print("[Anti-Dump:vRP] Property monitoring enabled")

    -- Validate vRP installation
    Citizen.CreateThread(function()
        Citizen.Wait(10000) -- Wait 10 seconds for vRP to load

        local vRP = nil
        if exports['vrp'] then
            -- vRP is typically available through tunnel or direct exports
            print("[Anti-Dump:vRP] vRP framework detected successfully")
            print("[Anti-Dump:vRP] Player data integration active")
            print("[Anti-Dump:vRP] Group system integration enabled")
            print("[Anti-Dump:vRP] Business monitoring active")
            print("[Anti-Dump:vRP] Property protection enabled")
            print("[Anti-Dump:vRP] Vehicle monitoring enabled")
        else
            print("[Anti-Dump:vRP] WARNING: vRP framework not detected!")
            print("[Anti-Dump:vRP] Please ensure vRP is installed and loaded")
            print("[Anti-Dump:vRP] Check that vRP exports are available")
        end
    end)
end

-- Load vRP mode
Config.vRPMode()

=======
-- FiveM Anti-Dump vRP Framework Configuration
-- Configuration overrides for vRP framework integration
-- Version: 2.0.0

Config = {
    -- Framework Configuration
    Framework = {
        AutoDetect = false, -- Disable auto-detection for manual configuration
        PreferredFramework = "vrp",

        vRP = {
            Enabled = true,
            ExportName = "vrp",
            Version = "1.0.0+",

            -- vRP-specific settings
            GetUserIdEvent = "vRP:getUserId",
            GetUserByIdEvent = "vRP:getUserById",
            PlayerDataTable = "vrp_users",
            IdentifierColumn = "id",
            PlayerNameColumns = {"firstname", "name", "lastname"},

            -- Economy integration
            Economy = {
                EnableMoneyCheck = true,
                EnableBankCheck = true,
                EnableWalletCheck = true,
                SuspiciousTransactionThreshold = 750000, -- $750K
                LogSuspiciousTransactions = true,
                MonitorLaundering = true
            },

            -- Group integration (vRP uses groups instead of jobs)
            GroupIntegration = {
                Enabled = true,
                WhitelistGroups = {
                    "police", "emergency", "repair" -- Trusted groups
                },
                BlacklistGroups = {
                    "citizen" -- Higher risk for regular citizens
                },
                GroupRiskModifier = {
                    police = 0.5,      -- 50% lower risk for police
                    emergency = 0.7,   -- 30% lower risk for emergency services
                    repair = 0.8,      -- 20% lower risk for repair services
                    admin = 0.1        -- Very low risk for admins
                }
            },

            -- Permission integration
            Permissions = {
                UsevRPPermissions = true,
                AdminGroups = {"admin", "superadmin"},
                ModeratorGroups = {"admin", "superadmin", "moderator"},
                TrustedGroups = {"admin", "superadmin", "moderator", "police", "emergency"}
            },

            -- vRP-specific features
            vRPFeatures = {
                EnablePlayerValidation = true,
                EnableDetailedLogging = true,
                EnableAutomaticBans = true,
                BanDuration = 7200, -- 2 hours in seconds
                EnableDiscordIntegration = true,
                DiscordRoleId = "YOUR_VRP_ADMIN_ROLE_ID",
                EnableInventoryMonitoring = true,
                EnableApartmentMonitoring = true,
                EnableVehicleMonitoring = true,
                EnableBusinessMonitoring = true
            }
        },

        ESX = {
            Enabled = false -- Disable ESX when using vRP
        },

        QBCore = {
            Enabled = false -- Disable QBCore when using vRP
        },

        Standalone = {
            Enabled = false -- Disable standalone when using vRP
        }
    },

    -- Detection Configuration for vRP
    Detection = {
        -- vRP-specific detection modules
        vRPIntegration = {
            Enabled = true,
            CheckPlayerIdentifiers = true,
            CheckPlayerGroups = true,
            MonitorPlayerGroups = true,
            DetectIdentifierSpoofing = true,
            MonitorUserIds = true,
            DetectGroupExploits = true,
            MonitorBusinessExploits = true
        },

        -- Modified thresholds for vRP environment
        Thresholds = {
            CriticalRiskScore = 85, -- Slightly lower for vRP
            HighRiskScore = 65,
            MediumRiskScore = 45,
            LowRiskScore = 25
        },

        -- vRP-specific process whitelist additions
        vRPProcesses = {
            "vrp_server.exe",
            "vrp_menu.exe",
            "vrp_inventory.exe",
            "vrp_police.exe",
            "vrp_emergency.exe",
            "vrp_repair.exe",
            "vrp_garages.exe",
            "vrp_homes.exe"
        }
    },

    -- Prevention Configuration for vRP
    Prevention = {
        vRPIntegration = {
            Enabled = true,
            PreventvRPExploits = true,
            MonitorvRPEvents = true,
            BlockSuspiciousvRPCommands = true,
            PreventInventoryExploits = true,
            PreventApartmentExploits = true,
            PreventVehicleExploits = true,
            PreventBusinessExploits = true
        },

        -- vRP-specific network protection
        NetworkProtection = {
            vRPPorts = {
                BlockPorts = {30127, 30132}, -- Common vRP exploit ports
                MonitorPorts = {30120, 30121} -- vRP communication ports
            }
        }
    },

    -- vRP-specific whitelist additions
    Whitelist = {
        Processes = {
            -- vRP-specific processes
            "vrp_server.exe",
            "vrp_menu.exe",
            "vrp_inventory.exe",
            "vrp_police.exe",
            "vrp_emergency.exe",
            "vrp_repair.exe",
            "vrp_garages.exe",
            "vrp_homes.exe",
            "vrp_business.exe",
            "vrp_bank.exe",

            -- Common vRP dependencies
            "vrp_mysql.exe",
            "vrp_vehicles.exe",
            "vrp_properties.exe",
            "vrp_shops.exe"
        },

        -- vRP-specific memory thresholds
        MemoryThresholds = {
            ["vrp_server.exe"] = 140,      -- 140MB for vRP server
            ["vrp_inventory.exe"] = 90,    -- 90MB for inventory
            ["vrp_menu.exe"] = 45,         -- 45MB for menu system
            ["vrp_police.exe"] = 65,       -- 65MB for police system
            ["vrp_homes.exe"] = 70,        -- 70MB for housing system
            ["vrp_business.exe"] = 80      -- 80MB for business system
        }
    },

    -- vRP-enhanced notifications
    Notifications = {
        vRPIntegration = {
            Enabled = true,
            UsevRPChat = true,
            UsevRPNotifications = true,
            AdminNotificationEvent = "vRP:Notify",
            PlayerWarningEvent = "vRP:Notify"
        },

        PlayerNotifications = {
            Messages = {
                FirstWarning = "~r~[SECURITY] vRP Security: Suspicious activity detected on your account.",
                FinalWarning = "~r~[SECURITY] vRP Security: Account violation detected. Final warning.",
                DetectionAlert = "~r~[SECURITY] vRP Security: Critical violation. Account action required.",
                CooldownMessage = "~y~[SECURITY] vRP Security: Please wait before performing this action."
            }
        },

        AdminNotifications = {
            PermissionLevels = {
                SuperAdmin = "superadmin", -- vRP superadmin group
                Admin = "admin",           -- vRP admin group
                Moderator = "moderator"    -- vRP moderator group
            }
        }
    },

    -- Database configuration optimized for vRP
    Database = {
        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players", -- Links to vRP users table
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics",

            -- vRP-specific tables
            vRPUsers = "vrp_users",
            vRPUserData = "vrp_user_data",
            vRPUserVehicles = "vrp_user_vehicles",
            vRPUserHomes = "vrp_user_homes",
            vRPUserBusinesses = "vrp_user_businesses"
        },

        -- vRP-enhanced queries
        vRPQueries = {
            GetPlayerData = "SELECT * FROM vrp_users WHERE id = ?",
            GetPlayerInventory = "SELECT * FROM vrp_user_data WHERE user_id = ? AND dkey = 'inventory'",
            GetPlayerVehicles = "SELECT * FROM vrp_user_vehicles WHERE user_id = ?",
            LogPlayerAction = "INSERT INTO antidump_player_actions (player_id, action_type, details) VALUES (?, ?, ?)"
        }
    },

    -- vRP-specific export overrides
    Exports = {
        vRP = {
            GetUserId = "vRP:getUserId",
            GetUserById = "vRP:getUserById",
            GetUserDataTable = "vRP:getUserDataTable",
            Ban = "vRP:ban",
            Kick = "vRP:kick",
            Notify = "vRP:Notify",
            GetInventory = "vRP:getInventory"
        }
    }
}

-- vRP-specific functions
function Config.vRPMode()
    print("[Anti-Dump:vRP] vRP framework configuration loaded")
    print("[Anti-Dump:vRP] vRP integration enabled")
    print("[Anti-Dump:vRP] Enhanced player tracking active")
    print("[Anti-Dump:vRP] Economy monitoring enabled")
    print("[Anti-Dump:vRP] Group system monitoring active")
    print("[Anti-Dump:vRP] Business exploit prevention enabled")
    print("[Anti-Dump:vRP] Property monitoring enabled")

    -- Validate vRP installation
    Citizen.CreateThread(function()
        Citizen.Wait(10000) -- Wait 10 seconds for vRP to load

        local vRP = nil
        if exports['vrp'] then
            -- vRP is typically available through tunnel or direct exports
            print("[Anti-Dump:vRP] vRP framework detected successfully")
            print("[Anti-Dump:vRP] Player data integration active")
            print("[Anti-Dump:vRP] Group system integration enabled")
            print("[Anti-Dump:vRP] Business monitoring active")
            print("[Anti-Dump:vRP] Property protection enabled")
            print("[Anti-Dump:vRP] Vehicle monitoring enabled")
        else
            print("[Anti-Dump:vRP] WARNING: vRP framework not detected!")
            print("[Anti-Dump:vRP] Please ensure vRP is installed and loaded")
            print("[Anti-Dump:vRP] Check that vRP exports are available")
        end
    end)
end

-- Load vRP mode
Config.vRPMode()

>>>>>>> 30c513c97c5cbc88fe8ab5df1beab9ce91fa25f3
return Config
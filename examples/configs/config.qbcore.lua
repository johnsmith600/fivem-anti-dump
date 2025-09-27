-- FiveM Anti-Dump QBCore Framework Configuration
-- Configuration overrides for QBCore framework integration
-- Version: 2.0.0

Config = {
    -- Framework Configuration
    Framework = {
        AutoDetect = false, -- Disable auto-detection for manual configuration
        PreferredFramework = "qbcore",

        QBCore = {
            Enabled = true,
            ExportName = "qb-core",
            Version = "1.0.0+",

            -- QBCore-specific settings
            GetCoreObjectEvent = "QBCore:GetObject",
            PlayerDataTable = "players",
            IdentifierColumn = "citizenid",
            PlayerNameColumns = {"charinfo.firstname", "charinfo.lastname"},

            -- Economy integration
            Economy = {
                EnableMoneyCheck = true,
                EnableBankCheck = true,
                EnableCryptoCheck = true,
                SuspiciousTransactionThreshold = 500000, -- $500K
                LogSuspiciousTransactions = true,
                MonitorDirtyMoney = true
            },

            -- Job integration
            JobIntegration = {
                Enabled = true,
                WhitelistJobs = {
                    "police", "ambulance", "mechanic", "realestate"
                },
                BlacklistJobs = {
                    "unemployed"
                },
                JobRiskModifier = {
                    police = 0.5,      -- 50% lower risk for police
                    ambulance = 0.7,   -- 30% lower risk for ambulance
                    mechanic = 0.8,    -- 20% lower risk for mechanic
                    realestate = 0.9   -- 10% lower risk for real estate
                },
                GangRiskModifier = {
                    -- Gangs have higher risk
                    default = 1.5 -- 50% higher risk for gang members
                }
            },

            -- Permission integration
            Permissions = {
                UseQBCorePermissions = true,
                AdminGroups = {"admin", "god"},
                ModeratorGroups = {"admin", "god", "moderator"},
                TrustedGroups = {"admin", "god", "moderator", "police"}
            },

            -- QBCore-specific features
            QBCoreFeatures = {
                EnablePlayerValidation = true,
                EnableDetailedLogging = true,
                EnableAutomaticBans = true,
                BanDuration = 43200, -- 12 hours in seconds
                EnableDiscordIntegration = true,
                DiscordRoleId = "YOUR_QBCORE_ADMIN_ROLE_ID",
                EnableInventoryMonitoring = true,
                EnableVehicleMonitoring = true
            }
        },

        ESX = {
            Enabled = false -- Disable ESX when using QBCore
        },

        vRP = {
            Enabled = false -- Disable vRP when using QBCore
        },

        Standalone = {
            Enabled = false -- Disable standalone when using QBCore
        }
    },

    -- Detection Configuration for QBCore
    Detection = {
        -- QBCore-specific detection modules
        QBCoreIntegration = {
            Enabled = true,
            CheckPlayerIdentifiers = true,
            CheckPlayerGroups = true,
            MonitorPlayerJobs = true,
            DetectIdentifierSpoofing = true,
            MonitorCitizenIDs = true,
            DetectGangExploits = true
        },

        -- Modified thresholds for QBCore environment
        Thresholds = {
            CriticalRiskScore = 82, -- Slightly lower for QBCore
            HighRiskScore = 62,
            MediumRiskScore = 42,
            LowRiskScore = 22
        },

        -- QBCore-specific process whitelist additions
        QBCoreProcesses = {
            "qb-core.exe",
            "qb-menu.exe",
            "qb-inventory.exe",
            "qb-police.exe",
            "qb-ambulance.exe",
            "qb-mechanic.exe",
            "qb-gangs.exe"
        }
    },

    -- Prevention Configuration for QBCore
    Prevention = {
        QBCoreIntegration = {
            Enabled = true,
            PreventQBCoreExploits = true,
            MonitorQBCoreEvents = true,
            BlockSuspiciousQBCoreCommands = true,
            PreventInventoryExploits = true,
            PreventVehicleExploits = true
        },

        -- QBCore-specific network protection
        NetworkProtection = {
            QBCorePorts = {
                BlockPorts = {30126, 30131}, -- Common QBCore exploit ports
                MonitorPorts = {30120, 30121} -- QBCore communication ports
            }
        }
    },

    -- QBCore-specific whitelist additions
    Whitelist = {
        Processes = {
            -- QBCore-specific processes
            "qb-core.exe",
            "qb-menu.exe",
            "qb-inventory.exe",
            "qb-police.exe",
            "qb-ambulance.exe",
            "qb-mechanic.exe",
            "qb-gangs.exe",
            "qb-houses.exe",
            "qb-garages.exe",

            -- Common QBCore dependencies
            "qb-weapons.exe",
            "qb-shops.exe",
            "qb-banking.exe",
            "qb-phone.exe",
            "qb-crypto.exe"
        },

        -- QBCore-specific memory thresholds
        MemoryThresholds = {
            ["qb-core.exe"] = 120,       -- 120MB for QBCore core
            ["qb-inventory.exe"] = 80,   -- 80MB for inventory
            ["qb-menu.exe"] = 40,        -- 40MB for menu system
            ["qb-police.exe"] = 60,      -- 60MB for police system
            ["qb-banking.exe"] = 50      -- 50MB for banking
        }
    },

    -- QBCore-enhanced notifications
    Notifications = {
        QBCoreIntegration = {
            Enabled = true,
            UseQBCoreChat = true,
            UseQBCoreNotifications = true,
            AdminNotificationEvent = "QBCore:Notify",
            PlayerWarningEvent = "QBCore:Notify"
        },

        PlayerNotifications = {
            Messages = {
                FirstWarning = "~r~[SECURITY] QBCore Security: Suspicious activity detected on your account.",
                FinalWarning = "~r~[SECURITY] QBCore Security: Account violation detected. Final warning.",
                DetectionAlert = "~r~[SECURITY] QBCore Security: Critical violation. Account action required.",
                CooldownMessage = "~y~[SECURITY] QBCore Security: Please wait before performing this action."
            }
        },

        AdminNotifications = {
            PermissionLevels = {
                SuperAdmin = "god",        -- QBCore god group
                Admin = "admin",           -- QBCore admin group
                Moderator = "moderator"    -- QBCore moderator group
            }
        }
    },

    -- Database configuration optimized for QBCore
    Database = {
        Tables = {
            Detections = "antidump_detections",
            Processes = "antidump_processes",
            NetworkActivity = "antidump_network_activity",
            Players = "antidump_players", -- Links to QBCore players table
            Incidents = "antidump_incidents",
            Statistics = "antidump_statistics",

            -- QBCore-specific tables
            QBCorePlayers = "players",
            QBCorePlayerItems = "player_items",
            QBCorePlayerMoney = "player_moneys",
            QBCorePlayerVehicles = "player_vehicles",
            QBCorePlayerHouses = "player_houses"
        },

        -- QBCore-enhanced queries
        QBCoreQueries = {
            GetPlayerData = "SELECT * FROM players WHERE citizenid = ?",
            GetPlayerInventory = "SELECT * FROM player_items WHERE citizenid = ?",
            GetPlayerMoney = "SELECT * FROM player_moneys WHERE citizenid = ?",
            LogPlayerAction = "INSERT INTO antidump_player_actions (player_id, action_type, details) VALUES (?, ?, ?)"
        }
    },

    -- QBCore-specific export overrides
    Exports = {
        QBCore = {
            GetPlayer = "QBCore:Functions:GetPlayer",
            GetPlayers = "QBCore:Functions:GetPlayers",
            AddMoney = "QBCore:Functions:AddMoney",
            RemoveMoney = "QBCore:Functions:RemoveMoney",
            Notify = "QBCore:Notify",
            GetIdentifier = "QBCore:Functions:GetIdentifier"
        }
    }
}

-- QBCore-specific functions
function Config.QBCoreMode()
    print("[Anti-Dump:QBCore] QBCore framework configuration loaded")
    print("[Anti-Dump:QBCore] QBCore integration enabled")
    print("[Anti-Dump:QBCore] Enhanced player tracking active")
    print("[Anti-Dump:QBCore] Economy monitoring enabled")
    print("[Anti-Dump:QBCore] Gang system monitoring active")
    print("[Anti-Dump:QBCore] Inventory exploit prevention enabled")

    -- Validate QBCore installation
    Citizen.CreateThread(function()
        Citizen.Wait(10000) -- Wait 10 seconds for QBCore to load

        local QBCore = nil
        if exports['qb-core'] then
            QBCore = exports['qb-core']:GetCoreObject()
        end

        if QBCore then
            print("[Anti-Dump:QBCore] QBCore framework detected successfully")
            print("[Anti-Dump:QBCore] Player data integration active")
            print("[Anti-Dump:QBCore] Job system integration enabled")
            print("[Anti-Dump:QBCore] Gang monitoring active")
            print("[Anti-Dump:QBCore] Inventory protection enabled")
            print("[Anti-Dump:QBCore] Vehicle monitoring enabled")
        else
            print("[Anti-Dump:QBCore] WARNING: QBCore framework not detected!")
            print("[Anti-Dump:QBCore] Please ensure QBCore is installed and loaded")
        end
    end)
end

-- Load QBCore mode
Config.QBCoreMode()

return Config
<<<<<<< HEAD
-- FiveM Anti-Dump Database Schema
-- Complete database setup for anti-dump detection system
-- Version: 2.0.0
-- Compatible with MySQL/MariaDB

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS fivem_antidump;
USE fivem_antidump;

-- Set SQL mode
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- Detections table - Main detection events
CREATE TABLE IF NOT EXISTS `antidump_detections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `server_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `detection_type` varchar(50) NOT NULL,
  `detection_subtype` varchar(100) DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `severity` enum('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'MEDIUM',
  `process_name` varchar(255) DEFAULT NULL,
  `process_id` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `raw_data` longtext DEFAULT NULL,
  `action_taken` varchar(100) DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT '0',
  `resolution_notes` text DEFAULT NULL,
  `false_positive` tinyint(1) NOT NULL DEFAULT '0',
  `system_version` varchar(20) NOT NULL DEFAULT '2.0.0',
  `server_id` varchar(100) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_detection_type` (`detection_type`),
  KEY `idx_severity` (`severity`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_resolved` (`resolved`),
  KEY `idx_false_positive` (`false_positive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Processes table - Process monitoring data
CREATE TABLE IF NOT EXISTS `antidump_processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `process_name` varchar(255) NOT NULL,
  `process_id` varchar(50) DEFAULT NULL,
  `process_path` text DEFAULT NULL,
  `memory_usage` bigint(20) DEFAULT NULL,
  `cpu_usage` decimal(5,2) DEFAULT NULL,
  `network_connections` int(11) DEFAULT '0',
  `suspicious_behavior` text DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `scan_duration` int(11) DEFAULT NULL,
  `detection_count` int(11) NOT NULL DEFAULT '0',
  `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_process` (`player_id`, `process_name`, `process_id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_process_name` (`process_name`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_whitelisted` (`whitelisted`),
  KEY `idx_last_seen` (`last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Network activity table - Network monitoring data
CREATE TABLE IF NOT EXISTS `antidump_network_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `connection_type` enum('INBOUND','OUTBOUND','BOTH') NOT NULL,
  `local_port` int(11) DEFAULT NULL,
  `remote_ip` varchar(45) DEFAULT NULL,
  `remote_port` int(11) DEFAULT NULL,
  `protocol` varchar(20) DEFAULT NULL,
  `bytes_sent` bigint(20) DEFAULT '0',
  `bytes_received` bigint(20) DEFAULT '0',
  `connection_count` int(11) DEFAULT '1',
  `suspicious_ports` text DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  `block_reason` text DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_player_ip` (`player_ip`),
  KEY `idx_remote_ip` (`remote_ip`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_blocked` (`blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Players table - Player information and statistics
CREATE TABLE IF NOT EXISTS `antidump_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `steam_id` varchar(50) DEFAULT NULL,
  `discord_id` varchar(50) DEFAULT NULL,
  `first_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total_detections` int(11) NOT NULL DEFAULT '0',
  `critical_detections` int(11) NOT NULL DEFAULT '0',
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `reputation_score` decimal(5,2) NOT NULL DEFAULT '100.00',
  `warnings_issued` int(11) NOT NULL DEFAULT '0',
  `kicked_count` int(11) NOT NULL DEFAULT '0',
  `banned_count` int(11) NOT NULL DEFAULT '0',
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text DEFAULT NULL,
  `framework_id` varchar(100) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_player_id` (`player_id`),
  KEY `idx_player_name` (`player_name`),
  KEY `idx_player_ip` (`player_ip`),
  KEY `idx_license` (`license`),
  KEY `idx_first_seen` (`first_seen`),
  KEY `idx_last_seen` (`last_seen`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_whitelisted` (`whitelisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Incidents table - Major security incidents
CREATE TABLE IF NOT EXISTS `antidump_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `incident_type` varchar(50) NOT NULL,
  `severity` enum('HIGH','CRITICAL','EMERGENCY') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `affected_players` json DEFAULT NULL,
  `detection_ids` json DEFAULT NULL,
  `actions_taken` json DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT '0',
  `resolved_by` varchar(100) DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `investigation_required` tinyint(1) NOT NULL DEFAULT '0',
  `assigned_to` varchar(100) DEFAULT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') NOT NULL DEFAULT 'MEDIUM',
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_incident_type` (`incident_type`),
  KEY `idx_severity` (`severity`),
  KEY `idx_resolved` (`resolved`),
  KEY `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Statistics table - System statistics and metrics
CREATE TABLE IF NOT EXISTS `antidump_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `total_scans` int(11) NOT NULL DEFAULT '0',
  `total_detections` int(11) NOT NULL DEFAULT '0',
  `critical_detections` int(11) NOT NULL DEFAULT '0',
  `high_detections` int(11) NOT NULL DEFAULT '0',
  `medium_detections` int(11) NOT NULL DEFAULT '0',
  `low_detections` int(11) NOT NULL DEFAULT '0',
  `false_positives` int(11) NOT NULL DEFAULT '0',
  `players_scanned` int(11) NOT NULL DEFAULT '0',
  `unique_players` int(11) NOT NULL DEFAULT '0',
  `processes_monitored` int(11) NOT NULL DEFAULT '0',
  `network_connections` int(11) NOT NULL DEFAULT '0',
  `memory_scanned_mb` bigint(20) NOT NULL DEFAULT '0',
  `avg_scan_time` decimal(8,3) DEFAULT NULL,
  `avg_risk_score` decimal(5,2) DEFAULT NULL,
  `system_uptime` int(11) NOT NULL DEFAULT '0',
  `notifications_sent` int(11) NOT NULL DEFAULT '0',
  `discord_notifications` int(11) NOT NULL DEFAULT '0',
  `admin_notifications` int(11) NOT NULL DEFAULT '0',
  `actions_taken` int(11) NOT NULL DEFAULT '0',
  `players_warned` int(11) NOT NULL DEFAULT '0',
  `players_kicked` int(11) NOT NULL DEFAULT '0',
  `players_banned` int(11) NOT NULL DEFAULT '0',
  `error_count` int(11) NOT NULL DEFAULT '0',
  `performance_score` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_date` (`date`),
  KEY `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- System events table - System events and logs
CREATE TABLE IF NOT EXISTS `antidump_system_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `event_type` varchar(50) NOT NULL,
  `event_level` enum('DEBUG','INFO','WARN','ERROR','CRITICAL') NOT NULL DEFAULT 'INFO',
  `message` text NOT NULL,
  `data` json DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `error_code` varchar(20) DEFAULT NULL,
  `stack_trace` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_event_level` (`event_level`),
  KEY `idx_source` (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Configuration table - System configuration history
CREATE TABLE IF NOT EXISTS `antidump_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `config_version` varchar(20) NOT NULL,
  `config_type` enum('FULL','PARTIAL','MODULE') NOT NULL DEFAULT 'FULL',
  `config_data` longtext NOT NULL,
  `changed_by` varchar(100) DEFAULT NULL,
  `change_reason` text DEFAULT NULL,
  `applied` tinyint(1) NOT NULL DEFAULT '0',
  `rollback_version` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_config_version` (`config_version`),
  KEY `idx_applied` (`applied`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Whitelist table - Whitelisted processes and IPs
CREATE TABLE IF NOT EXISTS `antidump_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('PROCESS','IP','PLAYER','MEMORY') NOT NULL,
  `value` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `added_by` varchar(100) DEFAULT NULL,
  `added_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `usage_count` int(11) NOT NULL DEFAULT '0',
  `last_used` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_whitelist` (`type`, `value`),
  KEY `idx_type` (`type`),
  KEY `idx_active` (`active`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Performance metrics table - Detailed performance data
CREATE TABLE IF NOT EXISTS `antidump_performance_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metric_type` varchar(50) NOT NULL,
  `metric_name` varchar(100) NOT NULL,
  `metric_value` decimal(15,6) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `context` json DEFAULT NULL,
  `player_id` varchar(50) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `additional_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_metric_type` (`metric_type`),
  KEY `idx_metric_name` (`metric_name`),
  KEY `idx_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS `idx_detections_timestamp_severity` ON `antidump_detections` (`timestamp`, `severity`);
CREATE INDEX IF NOT EXISTS `idx_detections_player_risk` ON `antidump_detections` (`player_id`, `risk_score`);
CREATE INDEX IF NOT EXISTS `idx_processes_player_timestamp` ON `antidump_processes` (`player_id`, `timestamp`);
CREATE INDEX IF NOT EXISTS `idx_network_player_timestamp` ON `antidump_network_activity` (`player_id`, `timestamp`);
CREATE INDEX IF NOT EXISTS `idx_players_risk_score` ON `antidump_players` (`risk_score`, `last_seen`);
CREATE INDEX IF NOT EXISTS `idx_statistics_date` ON `antidump_statistics` (`date`);
CREATE INDEX IF NOT EXISTS `idx_events_timestamp_level` ON `antidump_system_events` (`timestamp`, `event_level`);

-- Create views for common queries
CREATE OR REPLACE VIEW `antidump_detection_summary` AS
SELECT
    DATE(timestamp) as detection_date,
    detection_type,
    severity,
    COUNT(*) as detection_count,
    AVG(risk_score) as avg_risk_score,
    MIN(risk_score) as min_risk_score,
    MAX(risk_score) as max_risk_score,
    COUNT(DISTINCT player_id) as affected_players
FROM antidump_detections
WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(timestamp), detection_type, severity;

CREATE OR REPLACE VIEW `antidump_player_risk_summary` AS
SELECT
    p.player_id,
    p.player_name,
    p.first_seen,
    p.last_seen,
    p.total_detections,
    p.critical_detections,
    p.risk_score,
    p.reputation_score,
    COUNT(DISTINCT d.id) as recent_detections_24h
FROM antidump_players p
LEFT JOIN antidump_detections d ON p.player_id = d.player_id
    AND d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY p.player_id, p.player_name, p.first_seen, p.last_seen,
         p.total_detections, p.critical_detections, p.risk_score, p.reputation_score;

-- Insert default configuration version
INSERT IGNORE INTO `antidump_configuration` (
    `config_version`,
    `config_type`,
    `config_data`,
    `applied`,
    `notes`
) VALUES (
    '2.0.0',
    'FULL',
    '{"version": "2.0.0", "description": "Initial configuration", "timestamp": "' || NOW() || '"}',
    1,
    'Initial database setup - Anti-Dump System v2.0.0'
);

-- Create stored procedures for common operations
DELIMITER //

CREATE PROCEDURE `GetDetectionStatsByDate`(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT
        DATE(timestamp) as date,
        COUNT(*) as total_detections,
        COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical_count,
        COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high_count,
        COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium_count,
        COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low_count,
        AVG(risk_score) as avg_risk_score
    FROM antidump_detections
    WHERE DATE(timestamp) BETWEEN start_date AND end_date
    GROUP BY DATE(timestamp)
    ORDER BY date DESC;
END //

CREATE PROCEDURE `GetPlayerRiskAssessment`(
    IN target_player_id VARCHAR(50)
)
BEGIN
    SELECT
        p.*,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN 1 END) as detections_1h,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) THEN 1 END) as detections_24h,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 1 END) as detections_7d,
        AVG(d.risk_score) as avg_risk_24h
    FROM antidump_players p
    LEFT JOIN antidump_detections d ON p.player_id = d.player_id
        AND d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    WHERE p.player_id = target_player_id
    GROUP BY p.player_id;
END //

CREATE PROCEDURE `UpdatePlayerReputation`(
    IN target_player_id VARCHAR(50),
    IN detection_severity VARCHAR(20),
    IN risk_score DECIMAL(5,2)
)
BEGIN
    DECLARE current_reputation DECIMAL(5,2) DEFAULT 100.00;
    DECLARE reputation_change DECIMAL(5,2) DEFAULT 0.00;

    -- Get current reputation
    SELECT reputation_score INTO current_reputation
    FROM antidump_players
    WHERE player_id = target_player_id;

    -- Calculate reputation change based on severity and risk
    CASE detection_severity
        WHEN 'CRITICAL' THEN SET reputation_change = -risk_score * 0.5;
        WHEN 'HIGH' THEN SET reputation_change = -risk_score * 0.3;
        WHEN 'MEDIUM' THEN SET reputation_change = -risk_score * 0.2;
        WHEN 'LOW' THEN SET reputation_change = -risk_score * 0.1;
        ELSE SET reputation_change = 0;
    END CASE;

    -- Update reputation (minimum 0, maximum 100)
    SET current_reputation = GREATEST(0, LEAST(100, current_reputation + reputation_change));

    -- Update player record
    UPDATE antidump_players
    SET
        reputation_score = current_reputation,
        risk_score = risk_score,
        last_seen = NOW()
    WHERE player_id = target_player_id;

    SELECT current_reputation as new_reputation;
END //

DELIMITER ;

-- Insert sample data for testing (optional)
-- Uncomment the following lines if you want to insert sample data

-- INSERT INTO `antidump_whitelist` (`type`, `value`, `description`, `added_by`) VALUES
-- ('PROCESS', 'explorer.exe', 'Windows Explorer - System process', 'system'),
-- ('PROCESS', 'taskmgr.exe', 'Task Manager - Administrative tool', 'system'),
-- ('IP', '127.0.0.1', 'Localhost - Development testing', 'system');

-- Create database maintenance events
-- Clean up old logs and statistics (runs daily)
CREATE EVENT IF NOT EXISTS `cleanup_old_logs`
ON SCHEDULE EVERY 1 DAY
DO
    -- Delete system events older than 30 days
    DELETE FROM antidump_system_events
    WHERE timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY);

    -- Delete performance metrics older than 7 days
    DELETE FROM antidump_performance_metrics
    WHERE timestamp < DATE_SUB(NOW(), INTERVAL 7 DAY);

    -- Archive old statistics (keep last 90 days)
    DELETE FROM antidump_statistics
    WHERE date < DATE_SUB(CURDATE(), INTERVAL 90 DAY);

    -- Deactivate expired whitelist entries
    UPDATE antidump_whitelist
    SET active = 0
    WHERE expires_at IS NOT NULL
    AND expires_at < NOW()
    AND active = 1;

-- Generate daily statistics (runs hourly)
CREATE EVENT IF NOT EXISTS `generate_hourly_stats`
ON SCHEDULE EVERY 1 HOUR
DO
    INSERT INTO antidump_statistics (
        date,
        total_scans,
        total_detections,
        critical_detections,
        high_detections,
        medium_detections,
        low_detections,
        unique_players
    )
    SELECT
        CURDATE(),
        COUNT(*) as scans,
        COUNT(CASE WHEN severity IN ('CRITICAL', 'HIGH', 'MEDIUM', 'LOW') THEN 1 END) as detections,
        COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical,
        COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high,
        COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium,
        COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low,
        COUNT(DISTINCT player_id) as players
    FROM antidump_detections
    WHERE DATE(timestamp) = CURDATE()
    ON DUPLICATE KEY UPDATE
        total_scans = VALUES(total_scans),
        total_detections = VALUES(total_detections),
        critical_detections = VALUES(critical_detections),
        high_detections = VALUES(high_detections),
        medium_detections = VALUES(medium_detections),
        low_detections = VALUES(low_detections),
        unique_players = VALUES(unique_players);

-- Success message
=======
-- FiveM Anti-Dump Database Schema
-- Complete database setup for anti-dump detection system
-- Version: 2.0.0
-- Compatible with MySQL/MariaDB

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS fivem_antidump;
USE fivem_antidump;

-- Set SQL mode
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- Detections table - Main detection events
CREATE TABLE IF NOT EXISTS `antidump_detections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `server_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `detection_type` varchar(50) NOT NULL,
  `detection_subtype` varchar(100) DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `severity` enum('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'MEDIUM',
  `process_name` varchar(255) DEFAULT NULL,
  `process_id` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `raw_data` longtext DEFAULT NULL,
  `action_taken` varchar(100) DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT '0',
  `resolution_notes` text DEFAULT NULL,
  `false_positive` tinyint(1) NOT NULL DEFAULT '0',
  `system_version` varchar(20) NOT NULL DEFAULT '2.0.0',
  `server_id` varchar(100) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_detection_type` (`detection_type`),
  KEY `idx_severity` (`severity`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_resolved` (`resolved`),
  KEY `idx_false_positive` (`false_positive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Processes table - Process monitoring data
CREATE TABLE IF NOT EXISTS `antidump_processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `process_name` varchar(255) NOT NULL,
  `process_id` varchar(50) DEFAULT NULL,
  `process_path` text DEFAULT NULL,
  `memory_usage` bigint(20) DEFAULT NULL,
  `cpu_usage` decimal(5,2) DEFAULT NULL,
  `network_connections` int(11) DEFAULT '0',
  `suspicious_behavior` text DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `scan_duration` int(11) DEFAULT NULL,
  `detection_count` int(11) NOT NULL DEFAULT '0',
  `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_process` (`player_id`, `process_name`, `process_id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_process_name` (`process_name`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_whitelisted` (`whitelisted`),
  KEY `idx_last_seen` (`last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Network activity table - Network monitoring data
CREATE TABLE IF NOT EXISTS `antidump_network_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `player_id` varchar(50) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `connection_type` enum('INBOUND','OUTBOUND','BOTH') NOT NULL,
  `local_port` int(11) DEFAULT NULL,
  `remote_ip` varchar(45) DEFAULT NULL,
  `remote_port` int(11) DEFAULT NULL,
  `protocol` varchar(20) DEFAULT NULL,
  `bytes_sent` bigint(20) DEFAULT '0',
  `bytes_received` bigint(20) DEFAULT '0',
  `connection_count` int(11) DEFAULT '1',
  `suspicious_ports` text DEFAULT NULL,
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  `block_reason` text DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_player_id` (`player_id`),
  KEY `idx_player_ip` (`player_ip`),
  KEY `idx_remote_ip` (`remote_ip`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_blocked` (`blocked`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Players table - Player information and statistics
CREATE TABLE IF NOT EXISTS `antidump_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` varchar(50) NOT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `player_ip` varchar(45) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `steam_id` varchar(50) DEFAULT NULL,
  `discord_id` varchar(50) DEFAULT NULL,
  `first_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total_detections` int(11) NOT NULL DEFAULT '0',
  `critical_detections` int(11) NOT NULL DEFAULT '0',
  `risk_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `reputation_score` decimal(5,2) NOT NULL DEFAULT '100.00',
  `warnings_issued` int(11) NOT NULL DEFAULT '0',
  `kicked_count` int(11) NOT NULL DEFAULT '0',
  `banned_count` int(11) NOT NULL DEFAULT '0',
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0',
  `notes` text DEFAULT NULL,
  `framework_id` varchar(100) DEFAULT NULL,
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_player_id` (`player_id`),
  KEY `idx_player_name` (`player_name`),
  KEY `idx_player_ip` (`player_ip`),
  KEY `idx_license` (`license`),
  KEY `idx_first_seen` (`first_seen`),
  KEY `idx_last_seen` (`last_seen`),
  KEY `idx_risk_score` (`risk_score`),
  KEY `idx_whitelisted` (`whitelisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Incidents table - Major security incidents
CREATE TABLE IF NOT EXISTS `antidump_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `incident_type` varchar(50) NOT NULL,
  `severity` enum('HIGH','CRITICAL','EMERGENCY') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `affected_players` json DEFAULT NULL,
  `detection_ids` json DEFAULT NULL,
  `actions_taken` json DEFAULT NULL,
  `response_time` int(11) DEFAULT NULL,
  `resolved` tinyint(1) NOT NULL DEFAULT '0',
  `resolved_by` varchar(100) DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  `investigation_required` tinyint(1) NOT NULL DEFAULT '0',
  `assigned_to` varchar(100) DEFAULT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') NOT NULL DEFAULT 'MEDIUM',
  `additional_info` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_incident_type` (`incident_type`),
  KEY `idx_severity` (`severity`),
  KEY `idx_resolved` (`resolved`),
  KEY `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Statistics table - System statistics and metrics
CREATE TABLE IF NOT EXISTS `antidump_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `total_scans` int(11) NOT NULL DEFAULT '0',
  `total_detections` int(11) NOT NULL DEFAULT '0',
  `critical_detections` int(11) NOT NULL DEFAULT '0',
  `high_detections` int(11) NOT NULL DEFAULT '0',
  `medium_detections` int(11) NOT NULL DEFAULT '0',
  `low_detections` int(11) NOT NULL DEFAULT '0',
  `false_positives` int(11) NOT NULL DEFAULT '0',
  `players_scanned` int(11) NOT NULL DEFAULT '0',
  `unique_players` int(11) NOT NULL DEFAULT '0',
  `processes_monitored` int(11) NOT NULL DEFAULT '0',
  `network_connections` int(11) NOT NULL DEFAULT '0',
  `memory_scanned_mb` bigint(20) NOT NULL DEFAULT '0',
  `avg_scan_time` decimal(8,3) DEFAULT NULL,
  `avg_risk_score` decimal(5,2) DEFAULT NULL,
  `system_uptime` int(11) NOT NULL DEFAULT '0',
  `notifications_sent` int(11) NOT NULL DEFAULT '0',
  `discord_notifications` int(11) NOT NULL DEFAULT '0',
  `admin_notifications` int(11) NOT NULL DEFAULT '0',
  `actions_taken` int(11) NOT NULL DEFAULT '0',
  `players_warned` int(11) NOT NULL DEFAULT '0',
  `players_kicked` int(11) NOT NULL DEFAULT '0',
  `players_banned` int(11) NOT NULL DEFAULT '0',
  `error_count` int(11) NOT NULL DEFAULT '0',
  `performance_score` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_date` (`date`),
  KEY `idx_date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- System events table - System events and logs
CREATE TABLE IF NOT EXISTS `antidump_system_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `event_type` varchar(50) NOT NULL,
  `event_level` enum('DEBUG','INFO','WARN','ERROR','CRITICAL') NOT NULL DEFAULT 'INFO',
  `message` text NOT NULL,
  `data` json DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `error_code` varchar(20) DEFAULT NULL,
  `stack_trace` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_event_level` (`event_level`),
  KEY `idx_source` (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Configuration table - System configuration history
CREATE TABLE IF NOT EXISTS `antidump_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `config_version` varchar(20) NOT NULL,
  `config_type` enum('FULL','PARTIAL','MODULE') NOT NULL DEFAULT 'FULL',
  `config_data` longtext NOT NULL,
  `changed_by` varchar(100) DEFAULT NULL,
  `change_reason` text DEFAULT NULL,
  `applied` tinyint(1) NOT NULL DEFAULT '0',
  `rollback_version` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_config_version` (`config_version`),
  KEY `idx_applied` (`applied`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Whitelist table - Whitelisted processes and IPs
CREATE TABLE IF NOT EXISTS `antidump_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('PROCESS','IP','PLAYER','MEMORY') NOT NULL,
  `value` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `added_by` varchar(100) DEFAULT NULL,
  `added_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `usage_count` int(11) NOT NULL DEFAULT '0',
  `last_used` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_whitelist` (`type`, `value`),
  KEY `idx_type` (`type`),
  KEY `idx_active` (`active`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Performance metrics table - Detailed performance data
CREATE TABLE IF NOT EXISTS `antidump_performance_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metric_type` varchar(50) NOT NULL,
  `metric_name` varchar(100) NOT NULL,
  `metric_value` decimal(15,6) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `context` json DEFAULT NULL,
  `player_id` varchar(50) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `additional_data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_timestamp` (`timestamp`),
  KEY `idx_metric_type` (`metric_type`),
  KEY `idx_metric_name` (`metric_name`),
  KEY `idx_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS `idx_detections_timestamp_severity` ON `antidump_detections` (`timestamp`, `severity`);
CREATE INDEX IF NOT EXISTS `idx_detections_player_risk` ON `antidump_detections` (`player_id`, `risk_score`);
CREATE INDEX IF NOT EXISTS `idx_processes_player_timestamp` ON `antidump_processes` (`player_id`, `timestamp`);
CREATE INDEX IF NOT EXISTS `idx_network_player_timestamp` ON `antidump_network_activity` (`player_id`, `timestamp`);
CREATE INDEX IF NOT EXISTS `idx_players_risk_score` ON `antidump_players` (`risk_score`, `last_seen`);
CREATE INDEX IF NOT EXISTS `idx_statistics_date` ON `antidump_statistics` (`date`);
CREATE INDEX IF NOT EXISTS `idx_events_timestamp_level` ON `antidump_system_events` (`timestamp`, `event_level`);

-- Create views for common queries
CREATE OR REPLACE VIEW `antidump_detection_summary` AS
SELECT
    DATE(timestamp) as detection_date,
    detection_type,
    severity,
    COUNT(*) as detection_count,
    AVG(risk_score) as avg_risk_score,
    MIN(risk_score) as min_risk_score,
    MAX(risk_score) as max_risk_score,
    COUNT(DISTINCT player_id) as affected_players
FROM antidump_detections
WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(timestamp), detection_type, severity;

CREATE OR REPLACE VIEW `antidump_player_risk_summary` AS
SELECT
    p.player_id,
    p.player_name,
    p.first_seen,
    p.last_seen,
    p.total_detections,
    p.critical_detections,
    p.risk_score,
    p.reputation_score,
    COUNT(DISTINCT d.id) as recent_detections_24h
FROM antidump_players p
LEFT JOIN antidump_detections d ON p.player_id = d.player_id
    AND d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
GROUP BY p.player_id, p.player_name, p.first_seen, p.last_seen,
         p.total_detections, p.critical_detections, p.risk_score, p.reputation_score;

-- Insert default configuration version
INSERT IGNORE INTO `antidump_configuration` (
    `config_version`,
    `config_type`,
    `config_data`,
    `applied`,
    `notes`
) VALUES (
    '2.0.0',
    'FULL',
    '{"version": "2.0.0", "description": "Initial configuration", "timestamp": "' || NOW() || '"}',
    1,
    'Initial database setup - Anti-Dump System v2.0.0'
);

-- Create stored procedures for common operations
DELIMITER //

CREATE PROCEDURE `GetDetectionStatsByDate`(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT
        DATE(timestamp) as date,
        COUNT(*) as total_detections,
        COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical_count,
        COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high_count,
        COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium_count,
        COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low_count,
        AVG(risk_score) as avg_risk_score
    FROM antidump_detections
    WHERE DATE(timestamp) BETWEEN start_date AND end_date
    GROUP BY DATE(timestamp)
    ORDER BY date DESC;
END //

CREATE PROCEDURE `GetPlayerRiskAssessment`(
    IN target_player_id VARCHAR(50)
)
BEGIN
    SELECT
        p.*,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN 1 END) as detections_1h,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) THEN 1 END) as detections_24h,
        COUNT(CASE WHEN d.timestamp >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 1 END) as detections_7d,
        AVG(d.risk_score) as avg_risk_24h
    FROM antidump_players p
    LEFT JOIN antidump_detections d ON p.player_id = d.player_id
        AND d.timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    WHERE p.player_id = target_player_id
    GROUP BY p.player_id;
END //

CREATE PROCEDURE `UpdatePlayerReputation`(
    IN target_player_id VARCHAR(50),
    IN detection_severity VARCHAR(20),
    IN risk_score DECIMAL(5,2)
)
BEGIN
    DECLARE current_reputation DECIMAL(5,2) DEFAULT 100.00;
    DECLARE reputation_change DECIMAL(5,2) DEFAULT 0.00;

    -- Get current reputation
    SELECT reputation_score INTO current_reputation
    FROM antidump_players
    WHERE player_id = target_player_id;

    -- Calculate reputation change based on severity and risk
    CASE detection_severity
        WHEN 'CRITICAL' THEN SET reputation_change = -risk_score * 0.5;
        WHEN 'HIGH' THEN SET reputation_change = -risk_score * 0.3;
        WHEN 'MEDIUM' THEN SET reputation_change = -risk_score * 0.2;
        WHEN 'LOW' THEN SET reputation_change = -risk_score * 0.1;
        ELSE SET reputation_change = 0;
    END CASE;

    -- Update reputation (minimum 0, maximum 100)
    SET current_reputation = GREATEST(0, LEAST(100, current_reputation + reputation_change));

    -- Update player record
    UPDATE antidump_players
    SET
        reputation_score = current_reputation,
        risk_score = risk_score,
        last_seen = NOW()
    WHERE player_id = target_player_id;

    SELECT current_reputation as new_reputation;
END //

DELIMITER ;

-- Insert sample data for testing (optional)
-- Uncomment the following lines if you want to insert sample data

-- INSERT INTO `antidump_whitelist` (`type`, `value`, `description`, `added_by`) VALUES
-- ('PROCESS', 'explorer.exe', 'Windows Explorer - System process', 'system'),
-- ('PROCESS', 'taskmgr.exe', 'Task Manager - Administrative tool', 'system'),
-- ('IP', '127.0.0.1', 'Localhost - Development testing', 'system');

-- Create database maintenance events
-- Clean up old logs and statistics (runs daily)
CREATE EVENT IF NOT EXISTS `cleanup_old_logs`
ON SCHEDULE EVERY 1 DAY
DO
    -- Delete system events older than 30 days
    DELETE FROM antidump_system_events
    WHERE timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY);

    -- Delete performance metrics older than 7 days
    DELETE FROM antidump_performance_metrics
    WHERE timestamp < DATE_SUB(NOW(), INTERVAL 7 DAY);

    -- Archive old statistics (keep last 90 days)
    DELETE FROM antidump_statistics
    WHERE date < DATE_SUB(CURDATE(), INTERVAL 90 DAY);

    -- Deactivate expired whitelist entries
    UPDATE antidump_whitelist
    SET active = 0
    WHERE expires_at IS NOT NULL
    AND expires_at < NOW()
    AND active = 1;

-- Generate daily statistics (runs hourly)
CREATE EVENT IF NOT EXISTS `generate_hourly_stats`
ON SCHEDULE EVERY 1 HOUR
DO
    INSERT INTO antidump_statistics (
        date,
        total_scans,
        total_detections,
        critical_detections,
        high_detections,
        medium_detections,
        low_detections,
        unique_players
    )
    SELECT
        CURDATE(),
        COUNT(*) as scans,
        COUNT(CASE WHEN severity IN ('CRITICAL', 'HIGH', 'MEDIUM', 'LOW') THEN 1 END) as detections,
        COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical,
        COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high,
        COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium,
        COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low,
        COUNT(DISTINCT player_id) as players
    FROM antidump_detections
    WHERE DATE(timestamp) = CURDATE()
    ON DUPLICATE KEY UPDATE
        total_scans = VALUES(total_scans),
        total_detections = VALUES(total_detections),
        critical_detections = VALUES(critical_detections),
        high_detections = VALUES(high_detections),
        medium_detections = VALUES(medium_detections),
        low_detections = VALUES(low_detections),
        unique_players = VALUES(unique_players);

-- Success message
>>>>>>> 30c513c97c5cbc88fe8ab5df1beab9ce91fa25f3
SELECT 'Anti-Dump database schema installed successfully!' as status;
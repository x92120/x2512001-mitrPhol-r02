-- Table: production_plan_history
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `production_plan_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_db_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `changed_by` varchar(50) NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `plan_db_id` (`plan_db_id`),
  CONSTRAINT `production_plan_history_ibfk_1` FOREIGN KEY (`plan_db_id`) REFERENCES `production_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

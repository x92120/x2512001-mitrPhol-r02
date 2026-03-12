-- Table: ingredient_intake_history
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `ingredient_intake_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `intake_list_id` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `changed_by` varchar(50) NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `intake_list_id` (`intake_list_id`),
  KEY `ix_ingredient_intake_history_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

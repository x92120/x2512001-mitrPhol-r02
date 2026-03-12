-- Table: plants
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `plants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plant_id` varchar(50) NOT NULL,
  `plant_name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `plant_capacity` float DEFAULT '0',
  `plant_description` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plant_code` (`plant_id`),
  UNIQUE KEY `idx_plant_id` (`plant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

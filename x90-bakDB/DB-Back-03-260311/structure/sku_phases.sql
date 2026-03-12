-- Table: sku_phases
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `sku_phases` (
  `phase_id` int NOT NULL,
  `phase_code` varchar(50) DEFAULT NULL,
  `phase_description` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`phase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

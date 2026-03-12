-- Table: sku_histories
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `sku_histories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_db_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `update_by` varchar(50) NOT NULL,
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sku_db_id` (`sku_db_id`),
  KEY `ix_sku_histories_id` (`id`),
  CONSTRAINT `sku_histories_ibfk_1` FOREIGN KEY (`sku_db_id`) REFERENCES `sku_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

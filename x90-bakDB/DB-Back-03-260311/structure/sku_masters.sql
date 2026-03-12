-- Table: sku_masters
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `sku_masters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(50) NOT NULL,
  `sku_name` varchar(200) NOT NULL,
  `std_batch_size` float DEFAULT '1000',
  `uom` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `creat_by` varchar(50) NOT NULL,
  `update_by` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sku_group` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_skus_sku_id` (`sku_id`),
  KEY `ix_skus_id` (`id`),
  KEY `fk_sku_group` (`sku_group`),
  CONSTRAINT `fk_sku_group` FOREIGN KEY (`sku_group`) REFERENCES `sku_groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

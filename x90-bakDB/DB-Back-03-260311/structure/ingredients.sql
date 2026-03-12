-- Table: ingredients
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `blind_code` varchar(50) DEFAULT NULL,
  `mat_sap_code` varchar(50) NOT NULL,
  `ingredient_id` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `Group` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creat_by` varchar(50) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `re_code` varchar(50) DEFAULT NULL,
  `std_package_size` float DEFAULT '25',
  `std_prebatch_batch_size` float DEFAULT '0',
  `warehouse` varchar(50) DEFAULT '',
  `container_type_id` int DEFAULT NULL,
  `package_container_type` varchar(50) DEFAULT 'Bag',
  `package_container_size` float DEFAULT '25',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mat_sap_code` (`mat_sap_code`),
  KEY `idx_ingredients_blind_code` (`blind_code`),
  KEY `ix_ingredients_mat_sap_code` (`mat_sap_code`)
) ENGINE=InnoDB AUTO_INCREMENT=522 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

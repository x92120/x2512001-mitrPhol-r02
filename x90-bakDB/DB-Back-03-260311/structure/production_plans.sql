-- Table: production_plans
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `production_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(50) NOT NULL,
  `sku_name` varchar(200) DEFAULT NULL,
  `plant` varchar(50) DEFAULT NULL,
  `total_volume` float DEFAULT NULL,
  `batch_size` float DEFAULT NULL,
  `num_batches` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `flavour_house` tinyint(1) DEFAULT '0',
  `spp` tinyint(1) DEFAULT '0',
  `batch_prepare` tinyint(1) DEFAULT '0',
  `ready_to_product` tinyint(1) DEFAULT '0',
  `production` tinyint(1) DEFAULT '0',
  `done` tinyint(1) DEFAULT '0',
  `plan_id` varchar(50) DEFAULT NULL,
  `total_plan_volume` float DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_production_plans_id` (`id`),
  KEY `ix_production_plans_plan_id` (`plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

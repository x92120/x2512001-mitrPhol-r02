-- Table: package_container_sizes
-- Exported: 2026-03-11T18:36:01.522938

CREATE TABLE `package_container_sizes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `size` float NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `container_type` varchar(50) DEFAULT 'Bag',
  PRIMARY KEY (`id`),
  KEY `ix_package_container_sizes_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

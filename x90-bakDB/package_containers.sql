-- Table: package_containers
-- Exported: 2026-03-11T18:36:01.649883

CREATE TABLE `package_containers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `container_type` varchar(50) NOT NULL,
  `container_size` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_package_containers_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

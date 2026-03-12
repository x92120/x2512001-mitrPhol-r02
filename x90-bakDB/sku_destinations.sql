-- Table: sku_destinations
-- Exported: 2026-03-11T18:36:02.558858

CREATE TABLE `sku_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_code` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_sku_destinations_destination_code` (`destination_code`),
  KEY `ix_sku_destinations_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

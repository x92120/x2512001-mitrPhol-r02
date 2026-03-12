-- Table: packing_records
-- Exported: 2026-03-11T18:36:01.713066

CREATE TABLE `packing_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `batch_id` int NOT NULL,
  `pack_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `package_type` varchar(50) DEFAULT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit` varchar(10) DEFAULT 'pcs',
  PRIMARY KEY (`id`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `packing_records_ibfk_1` FOREIGN KEY (`batch_id`) REFERENCES `batches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

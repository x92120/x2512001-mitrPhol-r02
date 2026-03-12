-- Table: batches
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `batch_number` varchar(50) NOT NULL,
  `production_order_id` int NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('pending','mixing','completed','failed') DEFAULT 'pending',
  `actual_quantity` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `batch_number` (`batch_number`),
  KEY `production_order_id` (`production_order_id`),
  CONSTRAINT `batches_ibfk_1` FOREIGN KEY (`production_order_id`) REFERENCES `production_orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

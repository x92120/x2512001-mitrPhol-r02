-- Table: production_orders
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `production_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) NOT NULL,
  `plant_id` int NOT NULL,
  `recipe_id` int NOT NULL,
  `target_quantity` decimal(10,2) NOT NULL,
  `start_date` date DEFAULT NULL,
  `status` enum('planned','released','in_progress','completed','cancelled') DEFAULT 'planned',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `plant_id` (`plant_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `production_orders_ibfk_1` FOREIGN KEY (`plant_id`) REFERENCES `plants` (`id`),
  CONSTRAINT `production_orders_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

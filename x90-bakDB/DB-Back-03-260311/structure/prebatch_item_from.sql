-- Table: prebatch_item_from
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `prebatch_item_from` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prebatch_item_id` int NOT NULL,
  `intake_lot_id` varchar(50) NOT NULL,
  `mat_sap_code` varchar(50) DEFAULT NULL,
  `take_volume` float NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_prebatch_item_from_intake_lot_id` (`intake_lot_id`),
  KEY `ix_prebatch_item_from_mat_sap_code` (`mat_sap_code`),
  KEY `ix_prebatch_item_from_id` (`id`),
  KEY `ix_prebatch_item_from_prebatch_item_id` (`prebatch_item_id`),
  CONSTRAINT `prebatch_item_from_ibfk_1` FOREIGN KEY (`prebatch_item_id`) REFERENCES `prebatch_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

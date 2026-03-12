-- Table: prebatch_rec_from
-- Exported: 2026-03-11T18:36:01.967335

CREATE TABLE `prebatch_rec_from` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prebatch_rec_id` int NOT NULL,
  `intake_lot_id` varchar(50) NOT NULL,
  `mat_sap_code` varchar(50) DEFAULT NULL,
  `take_volume` float NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_prebatch_rec_from_id` (`id`),
  KEY `ix_prebatch_rec_from_intake_lot_id` (`intake_lot_id`),
  KEY `ix_prebatch_rec_from_prebatch_rec_id` (`prebatch_rec_id`),
  KEY `ix_prebatch_rec_from_mat_sap_code` (`mat_sap_code`),
  CONSTRAINT `prebatch_rec_from_ibfk_1` FOREIGN KEY (`prebatch_rec_id`) REFERENCES `prebatch_recs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: prebatch_reqs
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `prebatch_reqs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `batch_db_id` int NOT NULL,
  `plan_id` varchar(50) DEFAULT NULL,
  `batch_id` varchar(100) DEFAULT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `ingredient_name` varchar(200) DEFAULT NULL,
  `required_volume` float DEFAULT NULL,
  `wh` varchar(50) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `prebatch_ingredient_req_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `batch_db_id` (`batch_db_id`),
  KEY `ix_prebatch_reqs_id` (`id`),
  KEY `ix_prebatch_reqs_plan_id` (`plan_id`),
  KEY `ix_prebatch_reqs_re_code` (`re_code`),
  KEY `ix_prebatch_reqs_batch_id` (`batch_id`),
  CONSTRAINT `prebatch_reqs_ibfk_1` FOREIGN KEY (`batch_db_id`) REFERENCES `production_batches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

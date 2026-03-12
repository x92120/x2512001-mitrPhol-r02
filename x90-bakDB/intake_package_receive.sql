-- Table: intake_package_receive
-- Exported: 2026-03-11T18:36:01.463851

CREATE TABLE `intake_package_receive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `intake_list_id` varchar(50) NOT NULL,
  `package_no` int NOT NULL,
  `weight` float NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `intake_list_id` (`intake_list_id`),
  KEY `ix_intake_package_receive_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=677 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

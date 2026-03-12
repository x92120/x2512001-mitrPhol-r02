-- Table: stock_adjustments
-- Backup: 2026-03-11T18:43:46.935866

CREATE TABLE `stock_adjustments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `intake_lot_id` varchar(50) NOT NULL,
  `mat_sap_code` varchar(50) DEFAULT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `material_description` varchar(200) DEFAULT NULL,
  `adjust_type` varchar(20) NOT NULL,
  `adjust_reason` varchar(50) NOT NULL,
  `adjust_qty` float NOT NULL,
  `prev_remain_vol` float NOT NULL,
  `new_remain_vol` float NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `adjusted_by` varchar(50) NOT NULL,
  `adjusted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_stock_adjustments_mat_sap_code` (`mat_sap_code`),
  KEY `ix_stock_adjustments_re_code` (`re_code`),
  KEY `ix_stock_adjustments_intake_lot_id` (`intake_lot_id`),
  KEY `ix_stock_adjustments_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: sku_actions
-- Exported: 2026-03-11T18:36:02.502376

CREATE TABLE `sku_actions` (
  `action_code` varchar(50) NOT NULL,
  `action_description` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `component_filter` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`action_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

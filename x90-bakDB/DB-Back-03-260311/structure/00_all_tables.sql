-- ============================================
-- xMixing Database Backup
-- Day: 3 (Wednesday)
-- Date: 2026-03-11T18:43:46.935866
-- Tables: 31
-- ============================================

-- Table: batches
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


-- Table: ingredient_intake_from
CREATE TABLE `ingredient_intake_from` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_ingredient_intake_from_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: ingredient_intake_history
CREATE TABLE `ingredient_intake_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `intake_list_id` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `changed_by` varchar(50) NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `intake_list_id` (`intake_list_id`),
  KEY `ix_ingredient_intake_history_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: ingredient_intake_lists
CREATE TABLE `ingredient_intake_lists` (
  `intake_lot_id` varchar(50) NOT NULL,
  `lot_id` varchar(50) NOT NULL,
  `intake_from` varchar(50) DEFAULT NULL,
  `blind_code` varchar(50) DEFAULT NULL,
  `mat_sap_code` varchar(50) NOT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `material_description` varchar(200) DEFAULT NULL,
  `uom` varchar(20) DEFAULT NULL,
  `intake_vol` float NOT NULL,
  `remain_vol` float NOT NULL,
  `intake_package_vol` float DEFAULT NULL,
  `package_intake` int DEFAULT NULL,
  `expire_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `intake_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `intake_by` varchar(50) NOT NULL,
  `edit_by` varchar(50) DEFAULT NULL,
  `edit_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `po_number` varchar(50) DEFAULT NULL,
  `manufacturing_date` datetime DEFAULT NULL,
  `batch_prepare_vol` float DEFAULT NULL,
  `std_package_size` float DEFAULT NULL,
  `intake_to` varchar(50) DEFAULT NULL,
  `ext_date` datetime DEFAULT NULL,
  `reserv_no` varchar(50) DEFAULT NULL,
  `stock_zone` varchar(50) DEFAULT NULL,
  `material_type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`intake_lot_id`),
  KEY `ix_ingredient_intake_lists_intake_lot_id` (`intake_lot_id`),
  KEY `ix_ingredient_intake_lists_mat_sap_code` (`mat_sap_code`),
  KEY `ix_ingredient_intake_lists_blind_code` (`blind_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: ingredients
CREATE TABLE `ingredients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `blind_code` varchar(50) DEFAULT NULL,
  `mat_sap_code` varchar(50) NOT NULL,
  `ingredient_id` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `Group` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creat_by` varchar(50) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `re_code` varchar(50) DEFAULT NULL,
  `std_package_size` float DEFAULT '25',
  `std_prebatch_batch_size` float DEFAULT '0',
  `warehouse` varchar(50) DEFAULT '',
  `container_type_id` int DEFAULT NULL,
  `package_container_type` varchar(50) DEFAULT 'Bag',
  `package_container_size` float DEFAULT '25',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mat_sap_code` (`mat_sap_code`),
  KEY `idx_ingredients_blind_code` (`blind_code`),
  KEY `ix_ingredients_mat_sap_code` (`mat_sap_code`)
) ENGINE=InnoDB AUTO_INCREMENT=522 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: intake_package_receive
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


-- Table: package_container_sizes
CREATE TABLE `package_container_sizes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `size` float NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `container_type` varchar(50) DEFAULT 'Bag',
  PRIMARY KEY (`id`),
  KEY `ix_package_container_sizes_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: package_container_types
CREATE TABLE `package_container_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `ix_package_container_types_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: package_containers
CREATE TABLE `package_containers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `container_type` varchar(50) NOT NULL,
  `container_size` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `ix_package_containers_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: packing_records
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


-- Table: plants
CREATE TABLE `plants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plant_id` varchar(50) NOT NULL,
  `plant_name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `plant_capacity` float DEFAULT '0',
  `plant_description` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plant_code` (`plant_id`),
  UNIQUE KEY `idx_plant_id` (`plant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: prebatch_item_from
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


-- Table: prebatch_items
CREATE TABLE `prebatch_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `batch_db_id` int NOT NULL,
  `plan_id` varchar(50) DEFAULT NULL,
  `batch_id` varchar(100) DEFAULT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `ingredient_name` varchar(200) DEFAULT NULL,
  `required_volume` float DEFAULT NULL,
  `wh` varchar(50) DEFAULT 'Mix',
  `status` int DEFAULT '0',
  `batch_record_id` varchar(100) DEFAULT NULL,
  `net_volume` float DEFAULT NULL,
  `package_no` int DEFAULT '1',
  `total_packages` int DEFAULT '1',
  `intake_lot_id` varchar(50) DEFAULT NULL,
  `mat_sap_code` varchar(50) DEFAULT NULL,
  `prebatch_id` varchar(100) DEFAULT NULL,
  `recode_batch_id` varchar(50) DEFAULT NULL,
  `total_volume` float DEFAULT NULL,
  `total_request_volume` float DEFAULT NULL,
  `recheck_status` int DEFAULT '0',
  `recheck_at` datetime DEFAULT NULL,
  `recheck_by` varchar(100) DEFAULT NULL,
  `packing_status` int DEFAULT '0',
  `packed_at` timestamp NULL DEFAULT NULL,
  `packed_by` varchar(50) DEFAULT NULL,
  `weighed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pi_plan` (`plan_id`),
  KEY `idx_pi_batch` (`batch_id`),
  KEY `idx_pi_recode` (`re_code`),
  KEY `idx_pi_batchdb` (`batch_db_id`),
  KEY `idx_pi_status` (`status`),
  KEY `idx_pi_packing` (`packing_status`),
  KEY `idx_pi_lot` (`intake_lot_id`),
  KEY `idx_pi_sap` (`mat_sap_code`),
  KEY `idx_pi_brid` (`batch_record_id`),
  CONSTRAINT `prebatch_items_ibfk_1` FOREIGN KEY (`batch_db_id`) REFERENCES `production_batches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1482 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: prebatch_rec_from
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


-- Table: prebatch_recs
CREATE TABLE `prebatch_recs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `req_id` int DEFAULT NULL,
  `batch_record_id` varchar(100) NOT NULL,
  `plan_id` varchar(50) DEFAULT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `package_no` int DEFAULT NULL,
  `total_packages` int DEFAULT NULL,
  `net_volume` float DEFAULT NULL,
  `total_volume` float DEFAULT NULL,
  `total_request_volume` float DEFAULT NULL,
  `intake_lot_id` varchar(50) DEFAULT NULL,
  `mat_sap_code` varchar(50) DEFAULT NULL,
  `prebatch_id` varchar(100) DEFAULT NULL,
  `recode_batch_id` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `recheck_status` int DEFAULT '0',
  `recheck_at` datetime DEFAULT NULL,
  `recheck_by` varchar(100) DEFAULT NULL,
  `packing_status` int DEFAULT '0',
  `packed_at` timestamp NULL DEFAULT NULL,
  `packed_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_prebatch_recs_batch_record_id` (`batch_record_id`),
  KEY `req_id` (`req_id`),
  KEY `ix_prebatch_recs_intake_lot_id` (`intake_lot_id`),
  KEY `ix_prebatch_recs_id` (`id`),
  KEY `ix_prebatch_recs_re_code` (`re_code`),
  KEY `ix_prebatch_recs_plan_id` (`plan_id`),
  KEY `ix_prebatch_recs_mat_sap_code` (`mat_sap_code`),
  KEY `ix_prebatch_recs_prebatch_id` (`prebatch_id`),
  KEY `ix_prebatch_recs_recode_batch_id` (`recode_batch_id`),
  KEY `idx_prebatch_recs_packing_status` (`packing_status`),
  CONSTRAINT `prebatch_recs_ibfk_1` FOREIGN KEY (`req_id`) REFERENCES `prebatch_reqs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: prebatch_reqs
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


-- Table: production_batches
CREATE TABLE `production_batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_id` int NOT NULL,
  `batch_id` varchar(100) NOT NULL,
  `sku_id` varchar(50) NOT NULL,
  `plant` varchar(50) DEFAULT NULL,
  `batch_size` float DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `flavour_house` tinyint(1) DEFAULT '0',
  `spp` tinyint(1) DEFAULT '0',
  `batch_prepare` tinyint(1) DEFAULT '0',
  `ready_to_product` tinyint(1) DEFAULT '0',
  `production` tinyint(1) DEFAULT '0',
  `done` tinyint(1) DEFAULT '0',
  `fh_boxed_at` timestamp NULL DEFAULT NULL,
  `spp_boxed_at` timestamp NULL DEFAULT NULL,
  `fh_delivered_at` timestamp NULL DEFAULT NULL,
  `fh_delivered_by` varchar(50) DEFAULT NULL,
  `spp_delivered_at` timestamp NULL DEFAULT NULL,
  `spp_delivered_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_production_batches_batch_id` (`batch_id`),
  KEY `plan_id` (`plan_id`),
  KEY `ix_production_batches_id` (`id`),
  KEY `idx_prod_batch_fh_boxed` (`fh_boxed_at`),
  KEY `idx_prod_batch_spp_boxed` (`spp_boxed_at`),
  KEY `idx_prod_batch_fh_delivered` (`fh_delivered_at`),
  KEY `idx_prod_batch_spp_delivered` (`spp_delivered_at`),
  CONSTRAINT `production_batches_ibfk_1` FOREIGN KEY (`plan_id`) REFERENCES `production_plans` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: production_orders
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


-- Table: production_plan_history
CREATE TABLE `production_plan_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plan_db_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `changed_by` varchar(50) NOT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `plan_db_id` (`plan_db_id`),
  CONSTRAINT `production_plan_history_ibfk_1` FOREIGN KEY (`plan_db_id`) REFERENCES `production_plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: production_plans
CREATE TABLE `production_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(50) NOT NULL,
  `sku_name` varchar(200) DEFAULT NULL,
  `plant` varchar(50) DEFAULT NULL,
  `total_volume` float DEFAULT NULL,
  `batch_size` float DEFAULT NULL,
  `num_batches` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `flavour_house` tinyint(1) DEFAULT '0',
  `spp` tinyint(1) DEFAULT '0',
  `batch_prepare` tinyint(1) DEFAULT '0',
  `ready_to_product` tinyint(1) DEFAULT '0',
  `production` tinyint(1) DEFAULT '0',
  `done` tinyint(1) DEFAULT '0',
  `plan_id` varchar(50) DEFAULT NULL,
  `total_plan_volume` float DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `updated_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_production_plans_id` (`id`),
  KEY `ix_production_plans_plan_id` (`plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: products
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `unit_of_measure` varchar(10) DEFAULT 'kg',
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_code` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_actions
CREATE TABLE `sku_actions` (
  `action_code` varchar(50) NOT NULL,
  `action_description` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `component_filter` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`action_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_destinations
CREATE TABLE `sku_destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_code` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_sku_destinations_destination_code` (`destination_code`),
  KEY `ix_sku_destinations_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_groups
CREATE TABLE `sku_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_code` varchar(50) NOT NULL,
  `group_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_sku_groups_group_code` (`group_code`),
  KEY `ix_sku_groups_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_histories
CREATE TABLE `sku_histories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_db_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `update_by` varchar(50) NOT NULL,
  `update_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sku_db_id` (`sku_db_id`),
  KEY `ix_sku_histories_id` (`id`),
  CONSTRAINT `sku_histories_ibfk_1` FOREIGN KEY (`sku_db_id`) REFERENCES `sku_masters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_masters
CREATE TABLE `sku_masters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(50) NOT NULL,
  `sku_name` varchar(200) NOT NULL,
  `std_batch_size` float DEFAULT '1000',
  `uom` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `creat_by` varchar(50) NOT NULL,
  `update_by` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sku_group` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_skus_sku_id` (`sku_id`),
  KEY `ix_skus_id` (`id`),
  KEY `fk_sku_group` (`sku_group`),
  CONSTRAINT `fk_sku_group` FOREIGN KEY (`sku_group`) REFERENCES `sku_groups` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_phases
CREATE TABLE `sku_phases` (
  `phase_id` int NOT NULL,
  `phase_code` varchar(50) DEFAULT NULL,
  `phase_description` varchar(200) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`phase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: sku_steps
CREATE TABLE `sku_steps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sku_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phase_number` varchar(20) DEFAULT NULL,
  `phase_id` varchar(50) DEFAULT NULL,
  `master_step` int NOT NULL,
  `sub_step` int NOT NULL,
  `destination` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `re_code` varchar(50) DEFAULT NULL,
  `action_code` varchar(50) DEFAULT NULL,
  `action_description` varchar(100) NOT NULL,
  `setup_step` varchar(100) DEFAULT NULL,
  `require` float DEFAULT NULL,
  `low_tol` float DEFAULT '0.001',
  `high_tol` float DEFAULT NULL,
  `agitator_rpm` float DEFAULT NULL,
  `high_shear_rpm` float DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `ph` float DEFAULT '7',
  `step_time` int DEFAULT NULL,
  `step_timer_control` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `qc_temperature` tinyint(1) DEFAULT '0',
  `brix` float DEFAULT NULL,
  `qc_ph` tinyint(1) DEFAULT NULL,
  `qc_brix` tinyint(1) DEFAULT NULL,
  `uom` varchar(20) DEFAULT NULL,
  `temp_low` float DEFAULT NULL,
  `temp_high` float DEFAULT NULL,
  `step_condition` varchar(100) DEFAULT NULL,
  `qc_temp` tinyint(1) DEFAULT '0',
  `record_steam_pressure` tinyint(1) DEFAULT '0',
  `record_ctw` tinyint(1) DEFAULT '0',
  `operation_brix_record` tinyint(1) DEFAULT '0',
  `operation_ph_record` tinyint(1) DEFAULT '0',
  `brix_sp` varchar(50) DEFAULT NULL,
  `ph_sp` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_sku_steps_id` (`id`),
  KEY `ix_sku_steps_sku_id` (`sku_id`)
) ENGINE=InnoDB AUTO_INCREMENT=675 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: stock_adjustments
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


-- Table: users
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` enum('Admin','Manager','Operator','QC_Inspector','Viewer') DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT NULL,
  `permissions` json DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `ix_users_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table: warehouses
CREATE TABLE `warehouses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_warehouses_warehouse_id` (`warehouse_id`),
  KEY `ix_warehouses_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

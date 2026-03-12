-- Data: production_orders
-- Rows: 3
-- Backup: 2026-03-11T18:43:46.935866

INSERT INTO `production_orders` (`id`, `order_number`, `plant_id`, `recipe_id`, `target_quantity`, `start_date`, `status`, `created_at`) VALUES (1, 'PO-20231010-001', 1, 1, 500.00, '2023-10-10', 'completed', '2026-01-10 11:20:50');
INSERT INTO `production_orders` (`id`, `order_number`, `plant_id`, `recipe_id`, `target_quantity`, `start_date`, `status`, `created_at`) VALUES (2, 'PO-20231011-002', 1, 1, 200.00, '2023-10-11', 'in_progress', '2026-01-10 11:20:50');
INSERT INTO `production_orders` (`id`, `order_number`, `plant_id`, `recipe_id`, `target_quantity`, `start_date`, `status`, `created_at`) VALUES (3, 'PO-20231012-003', 1, 1, 1000.00, '2023-10-12', 'planned', '2026-01-10 11:20:50');

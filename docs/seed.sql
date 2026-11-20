
USE inventafood;


INSERT INTO Area (id_area, nombre_area) VALUES
(1, 'Barra'),
(2, 'Cocina'),
(3, 'Administracion');


INSERT INTO Producto (id_producto, nombre, precio) VALUES
(1, 'Cafe latte', 2900.00),
(2, 'Cafe americano', 2200.00),
(3, 'Capuccino', 2800.00),
(4, 'Chocolate caliente', 3000.00),
(5, 'Te chai latte', 3200.00),
(6, 'Brownie', 2500.00),
(7, 'Sandwich de pollo', 4500.00),
(8, 'Agua mineral botella', 1500.00);


INSERT INTO Ingrediente (id_ingrediente, nombre, unidad_base) VALUES
(1, 'Cafe en grano', 'g'),
(2, 'Leche', 'ml'),
(3, 'Chocolate en polvo', 'g'),
(4, 'Azucar', 'g'),
(5, 'Te chai', 'g'),
(6, 'Harina', 'g'),
(7, 'Cacao', 'g'),
(8, 'Mantequilla', 'g'),
(9, 'Huevo', 'unidad'),
(10, 'Pan', 'unidad'),
(11, 'Pollo', 'g'),
(12, 'Lechuga', 'g'),
(13, 'Tomate', 'g'),
(14, 'Agua', 'ml'),
(15, 'Vaso desechable', 'unidad'),
(16, 'Tapa de vaso', 'unidad');


INSERT INTO Usuario (id_usuario, nombre, correo, contrasena, id_area, rol) VALUES
(1, 'Camila Torres', 'duena@masscafe.cl', 'hash_demo_001', 3, 'duena'),
(2, 'Valentina Rojas', 'barra1@masscafe.cl', 'hash_demo_002', 1, 'trabajador_barra'),
(3, 'Diego Perez', 'barra2@masscafe.cl', 'hash_demo_003', 1, 'trabajador_barra'),
(4, 'Fernanda Soto', 'cocina1@masscafe.cl', 'hash_demo_004', 2, 'trabajador_cocina'),
(5, 'Matias Fuentes', 'cocina2@masscafe.cl', 'hash_demo_005', 2, 'trabajador_cocina');


INSERT INTO Configuracion_Producto
(id_configuracion, id_producto, id_ingrediente, grupo_opcion, cantidad, unidad_receta) VALUES
(1, 1, 1, 'Base', 18.000, 'g'),
(2, 1, 2, 'Base', 200.000, 'ml'),
(3, 1, 15, 'Envase', 1.000, 'unidad'),
(4, 1, 16, 'Envase', 1.000, 'unidad'),
(5, 2, 1, 'Base', 18.000, 'g'),
(6, 2, 14, 'Base', 150.000, 'ml'),
(7, 2, 15, 'Envase', 1.000, 'unidad'),
(8, 3, 1, 'Base', 18.000, 'g'),
(9, 3, 2, 'Base', 150.000, 'ml'),
(10, 3, 15, 'Envase', 1.000, 'unidad'),
(11, 3, 16, 'Envase', 1.000, 'unidad'),
(12, 4, 3, 'Base', 25.000, 'g'),
(13, 4, 2, 'Base', 200.000, 'ml'),
(14, 4, 15, 'Envase', 1.000, 'unidad'),
(15, 5, 5, 'Base', 12.000, 'g'),
(16, 5, 2, 'Base', 200.000, 'ml'),
(17, 5, 15, 'Envase', 1.000, 'unidad'),
(18, 6, 6, 'Base', 50.000, 'g'),
(19, 6, 7, 'Base', 20.000, 'g'),
(20, 6, 8, 'Base', 20.000, 'g'),
(21, 6, 9, 'Base', 0.500, 'unidad'),
(22, 7, 10, 'Base', 2.000, 'unidad'),
(23, 7, 11, 'Base', 80.000, 'g'),
(24, 7, 12, 'Base', 15.000, 'g'),
(25, 7, 13, 'Base', 20.000, 'g');


INSERT INTO Proveedor (id_proveedor, nombre, telefono_proveedor, correo_proveedor) VALUES
(1, 'Distribuidora Central', '+56 2 2345 1000', 'ventas@distribuidoracentral.cl'),
(2, 'Lacteos del Valle', '+56 2 2345 2000', 'pedidos@lacteosvalle.cl'),
(3, 'Comercial San Martin', '+56 2 2345 3000', 'contacto@sanmartin.cl');


INSERT INTO Item_Inventario
(id_item_inventario, tipo_item, id_producto, id_ingrediente, stock_actual, stock_minimo) VALUES
(1, 'ingrediente', NULL, 1, 1306.000, 1400.000),
(2, 'ingrediente', NULL, 2, 5200.000, 3000.000),
(3, 'ingrediente', NULL, 3, 445.000, 100.000),
(4, 'ingrediente', NULL, 4, 1500.000, 300.000),
(5, 'ingrediente', NULL, 5, 38.000, 40.000),
(6, 'ingrediente', NULL, 6, 1250.000, 300.000),
(7, 'ingrediente', NULL, 7, 640.000, 200.000),
(8, 'ingrediente', NULL, 8, 640.000, 200.000),
(9, 'ingrediente', NULL, 9, 28.500, 10.000),
(10, 'ingrediente', NULL, 10, 76.000, 20.000),
(11, 'ingrediente', NULL, 11, 1340.000, 500.000),
(12, 'ingrediente', NULL, 12, 470.000, 150.000),
(13, 'ingrediente', NULL, 13, 460.000, 150.000),
(14, 'ingrediente', NULL, 14, 20000.000, 3000.000),
(15, 'ingrediente', NULL, 15, 90.000, 30.000),
(16, 'ingrediente', NULL, 16, 93.000, 30.000),
(17, 'producto', 8, NULL, 24.000, 10.000);


INSERT INTO Venta (id_venta, fecha_hora, id_usuario) VALUES
(1, '2026-11-10 09:15:00', 2),
(2, '2026-11-11 11:40:00', 3),
(3, '2026-11-12 13:05:00', 4),
(4, '2026-11-14 16:20:00', 2),
(5, '2026-11-15 10:10:00', 4);


INSERT INTO Detalle_Venta (id_detalle_venta, id_venta, id_producto, cantidad) VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 2),
(4, 2, 4, 1),
(5, 3, 6, 3),
(6, 3, 7, 2),
(7, 4, 1, 3),
(8, 5, 5, 1);


INSERT INTO Detalle_Venta_Ingrediente
(id_detalle_venta_ingrediente, id_detalle_venta, id_ingrediente, cantidad_utilizada, unidad_consumo) VALUES
(1, 1, 1, 36.000, 'g'),
(2, 1, 2, 400.000, 'ml'),
(3, 1, 15, 2.000, 'unidad'),
(4, 1, 16, 2.000, 'unidad'),
(5, 2, 1, 18.000, 'g'),
(6, 2, 14, 150.000, 'ml'),
(7, 2, 15, 1.000, 'unidad'),
(8, 3, 1, 36.000, 'g'),
(9, 3, 2, 300.000, 'ml'),
(10, 3, 15, 2.000, 'unidad'),
(11, 3, 16, 2.000, 'unidad'),
(12, 4, 3, 25.000, 'g'),
(13, 4, 2, 200.000, 'ml'),
(14, 4, 15, 1.000, 'unidad'),
(15, 5, 6, 150.000, 'g'),
(16, 5, 7, 60.000, 'g'),
(17, 5, 8, 60.000, 'g'),
(18, 5, 9, 1.500, 'unidad'),
(19, 6, 10, 4.000, 'unidad'),
(20, 6, 11, 160.000, 'g'),
(21, 6, 12, 30.000, 'g'),
(22, 6, 13, 40.000, 'g'),
(23, 7, 1, 54.000, 'g'),
(24, 7, 2, 600.000, 'ml'),
(25, 7, 15, 3.000, 'unidad'),
(26, 7, 16, 3.000, 'unidad'),
(27, 8, 5, 12.000, 'g'),
(28, 8, 2, 200.000, 'ml'),
(29, 8, 15, 1.000, 'unidad');


INSERT INTO Compra (id_compra, fecha_hora, id_proveedor, id_usuario) VALUES
(1, '2026-11-08 08:30:00', 1, 1),
(2, '2026-11-09 09:00:00', 2, 1),
(3, '2026-11-13 08:45:00', 3, 1);


INSERT INTO Detalle_Compra
(id_detalle_compra, id_compra, id_item_inventario, cantidad, unidad_compra) VALUES
(1, 1, 1, 500.000, 'g'),
(2, 1, 3, 200.000, 'g'),
(3, 1, 5, 50.000, 'g'),
(4, 1, 17, 24.000, 'unidad'),
(5, 2, 2, 2000.000, 'ml'),
(6, 2, 6, 500.000, 'g'),
(7, 2, 7, 200.000, 'g'),
(8, 2, 8, 200.000, 'g'),
(9, 3, 10, 30.000, 'unidad'),
(10, 3, 11, 500.000, 'g'),
(11, 3, 12, 200.000, 'g'),
(12, 3, 13, 200.000, 'g');


INSERT INTO Movimiento_Inventario
(id_movimiento, id_item_inventario, tipo_movimiento, cantidad, fecha_hora, id_usuario, motivo) VALUES
(1, 1, 'entrada', 1000.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(2, 1, 'entrada', 500.000, '2026-11-08 08:30:00', 1, 'Compra de cafe en grano'),
(3, 1, 'salida', 144.000, '2026-11-15 10:10:00', 2, 'Consumo asociado a ventas'),
(4, 1, 'merma', 50.000, '2026-11-12 17:00:00', 1, 'Cafe derramado y no recuperable'),
(5, 2, 'entrada', 5000.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(6, 2, 'entrada', 2000.000, '2026-11-09 09:00:00', 1, 'Compra de leche'),
(7, 2, 'salida', 1700.000, '2026-11-15 10:10:00', 2, 'Consumo asociado a ventas'),
(8, 2, 'merma', 100.000, '2026-11-12 17:00:00', 1, 'Leche vencida'),
(9, 3, 'entrada', 300.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(10, 3, 'entrada', 200.000, '2026-11-08 08:30:00', 1, 'Compra de chocolate'),
(11, 3, 'salida', 25.000, '2026-11-11 11:40:00', 3, 'Consumo asociado a ventas'),
(12, 3, 'merma', 30.000, '2026-11-12 17:00:00', 1, 'Producto derramado'),
(13, 5, 'entrada', 50.000, '2026-11-08 08:30:00', 1, 'Compra de te chai'),
(14, 5, 'salida', 12.000, '2026-11-15 10:10:00', 4, 'Consumo asociado a ventas'),
(15, 6, 'entrada', 1000.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(16, 6, 'entrada', 500.000, '2026-11-09 09:00:00', 1, 'Compra de harina'),
(17, 6, 'salida', 150.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(18, 6, 'merma', 100.000, '2026-11-12 17:00:00', 1, 'Harina contaminada'),
(19, 7, 'entrada', 500.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(20, 7, 'entrada', 200.000, '2026-11-09 09:00:00', 1, 'Compra de cacao'),
(21, 7, 'salida', 60.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(22, 8, 'entrada', 500.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(23, 8, 'entrada', 200.000, '2026-11-09 09:00:00', 1, 'Compra de mantequilla'),
(24, 8, 'salida', 60.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(25, 10, 'entrada', 50.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(26, 10, 'entrada', 30.000, '2026-11-13 08:45:00', 1, 'Compra de pan'),
(27, 10, 'salida', 4.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(28, 11, 'entrada', 1000.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(29, 11, 'entrada', 500.000, '2026-11-13 08:45:00', 1, 'Compra de pollo'),
(30, 11, 'salida', 160.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(31, 12, 'entrada', 300.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(32, 12, 'entrada', 200.000, '2026-11-13 08:45:00', 1, 'Compra de lechuga'),
(33, 12, 'salida', 30.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(34, 13, 'entrada', 300.000, '2026-11-01 08:00:00', 1, 'Stock inicial'),
(35, 13, 'entrada', 200.000, '2026-11-13 08:45:00', 1, 'Compra de tomate'),
(36, 13, 'salida', 40.000, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(37, 9, 'entrada', 30.000, '2026-11-01 08:00:00', 1, 'Stock inicial de huevos'),
(38, 9, 'salida', 1.500, '2026-11-12 13:05:00', 4, 'Consumo asociado a ventas'),
(39, 14, 'entrada', 20000.000, '2026-11-01 08:00:00', 1, 'Stock inicial de agua'),
(40, 4, 'entrada', 1500.000, '2026-11-01 08:00:00', 1, 'Stock inicial de azucar'),
(41, 15, 'entrada', 100.000, '2026-11-01 08:00:00', 1, 'Stock inicial de vasos'),
(42, 15, 'salida', 10.000, '2026-11-15 10:10:00', 2, 'Consumo asociado a ventas'),
(43, 16, 'entrada', 100.000, '2026-11-01 08:00:00', 1, 'Stock inicial de tapas'),
(44, 16, 'salida', 7.000, '2026-11-14 16:20:00', 2, 'Consumo asociado a ventas'),
(45, 17, 'entrada', 24.000, '2026-11-08 08:30:00', 1, 'Compra de agua mineral');


INSERT INTO Alerta_Reposicion
(id_alerta, id_item_inventario, fecha_generacion, estado, fecha_atencion) VALUES
(1, 1, '2026-11-15 10:15:00', 'pendiente', NULL),
(2, 5, '2026-11-15 10:15:00', 'pendiente', NULL),
(3, 2, '2026-11-09 09:10:00', 'atendida', '2026-11-09 09:30:00');


SELECT 'Area' AS tabla, COUNT(*) AS registros FROM Area
UNION ALL SELECT 'Producto', COUNT(*) FROM Producto
UNION ALL SELECT 'Ingrediente', COUNT(*) FROM Ingrediente
UNION ALL SELECT 'Usuario', COUNT(*) FROM Usuario
UNION ALL SELECT 'Configuracion_Producto', COUNT(*) FROM Configuracion_Producto
UNION ALL SELECT 'Venta', COUNT(*) FROM Venta
UNION ALL SELECT 'Detalle_Venta', COUNT(*) FROM Detalle_Venta
UNION ALL SELECT 'Detalle_Venta_Ingrediente', COUNT(*) FROM Detalle_Venta_Ingrediente
UNION ALL SELECT 'Item_Inventario', COUNT(*) FROM Item_Inventario
UNION ALL SELECT 'Movimiento_Inventario', COUNT(*) FROM Movimiento_Inventario
UNION ALL SELECT 'Proveedor', COUNT(*) FROM Proveedor
UNION ALL SELECT 'Compra', COUNT(*) FROM Compra
UNION ALL SELECT 'Detalle_Compra', COUNT(*) FROM Detalle_Compra
UNION ALL SELECT 'Alerta_Reposicion', COUNT(*) FROM Alerta_Reposicion;

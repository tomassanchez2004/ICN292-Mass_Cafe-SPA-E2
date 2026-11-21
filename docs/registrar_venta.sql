-- =====================================================================
-- registrar_venta.sql  -  InventaFood (Mass Café SPA)
-- RF03: registrar las salidas de productos e ingredientes asociadas a
--       las ventas y actualizar el stock disponible.
--
-- Motor: MySQL 8.0 o superior.
-- Ejecutar DESPUÉS de schema.sql y seed.sql (y después de las consultas
-- de negocio, porque este script modifica el stock).
--
-- Al llamar a registrar_venta(usuario, producto, cantidad):
--   1. Valida que el usuario sea de barra o la dueña (actores / RNF01).
--   2. Valida que haya stock suficiente para toda la receta.
--   3. Registra la venta en Venta y Detalle_Venta.
--   4. Calcula los ingredientes usados según Configuracion_Producto
--      y los guarda en Detalle_Venta_Ingrediente.
--   5. Registra una 'salida' en Movimiento_Inventario por cada ítem.
--   6. Descuenta el stock_actual en Item_Inventario
--      (ingredientes de la receta y productos que se venden directo).
-- Todo ocurre en una transacción: si algo falla, no queda nada a medias.
--
-- Supuesto: la unidad de la receta (unidad_receta) es la misma unidad
-- base del ingrediente (unidad_base), como ocurre en seed.sql.
-- =====================================================================

USE inventafood;

DROP PROCEDURE IF EXISTS registrar_venta;

DELIMITER $$

CREATE PROCEDURE registrar_venta(
    IN p_id_usuario  INT,
    IN p_id_producto INT,
    IN p_cantidad    INT
)
BEGIN
    DECLARE v_rol        VARCHAR(30);
    DECLARE v_id_venta   INT;
    DECLARE v_id_detalle INT;
    DECLARE v_faltantes  INT DEFAULT 0;

    -- Si cualquier instrucción falla, se deshace todo
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Validaciones -------------------------------------------------
    SELECT rol INTO v_rol FROM Usuario WHERE id_usuario = p_id_usuario;

    IF v_rol IS NULL OR v_rol NOT IN ('trabajador_barra', 'duena') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Solo trabajadores de barra o la duena pueden registrar ventas';
    END IF;

    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La cantidad vendida debe ser mayor que 0';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = p_id_producto) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto no existe';
    END IF;

    -- 2. Stock suficiente (receta + producto de venta directa) ----------
    SELECT COUNT(*) INTO v_faltantes
    FROM (
        SELECT ii.stock_actual, SUM(cp.cantidad) * p_cantidad AS consumo
        FROM Configuracion_Producto cp
        JOIN Item_Inventario ii ON ii.id_ingrediente = cp.id_ingrediente
        WHERE cp.id_producto = p_id_producto
        GROUP BY ii.id_item_inventario, ii.stock_actual
        UNION ALL
        SELECT ii.stock_actual, p_cantidad AS consumo
        FROM Item_Inventario ii
        WHERE ii.id_producto = p_id_producto
    ) AS c
    WHERE c.stock_actual < c.consumo;

    IF v_faltantes > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para registrar la venta';
    END IF;

    START TRANSACTION;

    -- 3. Venta y detalle ------------------------------------------------
    INSERT INTO Venta (fecha_hora, id_usuario)
    VALUES (NOW(), p_id_usuario);
    SET v_id_venta = LAST_INSERT_ID();

    INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad)
    VALUES (v_id_venta, p_id_producto, p_cantidad);
    SET v_id_detalle = LAST_INSERT_ID();

    -- 4. Ingredientes utilizados según la receta --------------------------
    INSERT INTO Detalle_Venta_Ingrediente
        (id_detalle_venta, id_ingrediente, cantidad_utilizada, unidad_consumo)
    SELECT v_id_detalle, cp.id_ingrediente, cp.cantidad * p_cantidad, cp.unidad_receta
    FROM Configuracion_Producto cp
    WHERE cp.id_producto = p_id_producto;

    -- 5. Movimientos de salida ------------------------------------------
    INSERT INTO Movimiento_Inventario
        (id_item_inventario, tipo_movimiento, cantidad, fecha_hora, id_usuario, motivo)
    SELECT ii.id_item_inventario, 'salida', SUM(cp.cantidad) * p_cantidad, NOW(), p_id_usuario,
           CONCAT('Consumo asociado a la venta ', v_id_venta)
    FROM Configuracion_Producto cp
    JOIN Item_Inventario ii ON ii.id_ingrediente = cp.id_ingrediente
    WHERE cp.id_producto = p_id_producto
    GROUP BY ii.id_item_inventario;

    INSERT INTO Movimiento_Inventario
        (id_item_inventario, tipo_movimiento, cantidad, fecha_hora, id_usuario, motivo)
    SELECT ii.id_item_inventario, 'salida', p_cantidad, NOW(), p_id_usuario,
           CONCAT('Venta directa de producto, venta ', v_id_venta)
    FROM Item_Inventario ii
    WHERE ii.id_producto = p_id_producto;

    -- 6. Actualización del stock ------------------------------------------
    UPDATE Item_Inventario ii
    JOIN (
        SELECT cp.id_ingrediente, SUM(cp.cantidad) * p_cantidad AS consumo
        FROM Configuracion_Producto cp
        WHERE cp.id_producto = p_id_producto
        GROUP BY cp.id_ingrediente
    ) AS c ON c.id_ingrediente = ii.id_ingrediente
    SET ii.stock_actual = ii.stock_actual - c.consumo
    WHERE ii.id_item_inventario > 0;   -- compatible con el modo "safe updates" de Workbench

    UPDATE Item_Inventario
    SET stock_actual = stock_actual - p_cantidad
    WHERE id_producto = p_id_producto;

    COMMIT;

    SELECT v_id_venta AS id_venta_registrada;
END $$

DELIMITER ;


-- =====================================================================
-- DEMOSTRACIÓN
-- =====================================================================

-- Stock ANTES (café en grano, leche, vaso, tapa, agua mineral)
SELECT ii.id_item_inventario,
       COALESCE(ing.nombre, p.nombre) AS articulo,
       ii.stock_actual,
       ii.stock_minimo
FROM Item_Inventario ii
LEFT JOIN Ingrediente ing ON ing.id_ingrediente = ii.id_ingrediente
LEFT JOIN Producto p      ON p.id_producto      = ii.id_producto
WHERE ii.id_item_inventario IN (1, 2, 15, 16, 17);

-- Venta 1: Valentina Rojas (barra, id 2) vende 2 Cafe latte (producto 1)
-- Receta x2: 36 g cafe, 400 ml leche, 2 vasos, 2 tapas
CALL registrar_venta(2, 1, 2);

-- Venta 2: Valentina vende 1 Agua mineral botella (producto 8, venta directa)
CALL registrar_venta(2, 8, 1);

-- Stock DESPUÉS
-- Esperado (con el seed original):
--   Cafe en grano 1306 -> 1270 | Leche 5200 -> 4800
--   Vaso desechable 90 -> 88   | Tapa de vaso 93 -> 91
--   Agua mineral botella 24 -> 23
SELECT ii.id_item_inventario,
       COALESCE(ing.nombre, p.nombre) AS articulo,
       ii.stock_actual,
       ii.stock_minimo
FROM Item_Inventario ii
LEFT JOIN Ingrediente ing ON ing.id_ingrediente = ii.id_ingrediente
LEFT JOIN Producto p      ON p.id_producto      = ii.id_producto
WHERE ii.id_item_inventario IN (1, 2, 15, 16, 17);

-- Movimientos generados por las ventas
SELECT m.id_movimiento, m.id_item_inventario, m.tipo_movimiento,
       m.cantidad, m.fecha_hora, m.motivo
FROM Movimiento_Inventario m
WHERE m.motivo LIKE '%venta %'
ORDER BY m.id_movimiento DESC;

-- Ingredientes registrados para la venta de cafe latte
SELECT dvi.*
FROM Detalle_Venta_Ingrediente dvi
WHERE dvi.id_detalle_venta = (SELECT MAX(id_detalle_venta) FROM Detalle_Venta WHERE id_producto = 1);

-- ---------------------------------------------------------------------
-- Pruebas de rechazo (ejecutar de a una; deben mostrar un error y NO
-- modificar ningún dato):
-- CALL registrar_venta(4, 1, 1);     -- Fernanda Soto es de cocina: no puede vender
-- CALL registrar_venta(2, 1, 1000);  -- 1000 cafe latte: stock insuficiente
-- ---------------------------------------------------------------------

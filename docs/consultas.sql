USE inventafood;


SELECT
    i.id_item_inventario,
    i.tipo_item,
    COALESCE(p.nombre, ing.nombre) AS articulo,
    i.stock_actual,
    i.stock_minimo,
    CASE
        WHEN i.stock_minimo > i.stock_actual
        THEN i.stock_minimo - i.stock_actual
        ELSE 0
    END AS cantidad_para_alcanzar_minimo
FROM Item_Inventario AS i
LEFT JOIN Producto AS p
    ON i.id_producto = p.id_producto
LEFT JOIN Ingrediente AS ing
    ON i.id_ingrediente = ing.id_ingrediente
WHERE i.stock_actual <= i.stock_minimo
ORDER BY cantidad_para_alcanzar_minimo DESC;


SELECT
    ing.nombre AS ingrediente,
    dvi.unidad_consumo,
    SUM(dvi.cantidad_utilizada) AS cantidad_total_utilizada,
    COUNT(DISTINCT v.id_venta) AS ventas_en_que_se_utilizo
FROM Detalle_Venta_Ingrediente AS dvi
JOIN Ingrediente AS ing
    ON dvi.id_ingrediente = ing.id_ingrediente
JOIN Detalle_Venta AS dv
    ON dvi.id_detalle_venta = dv.id_detalle_venta
JOIN Venta AS v
    ON dv.id_venta = v.id_venta
GROUP BY ing.id_ingrediente, ing.nombre, dvi.unidad_consumo
ORDER BY cantidad_total_utilizada DESC;


SELECT
    COALESCE(p.nombre, ing.nombre) AS articulo,
    i.tipo_item,
    dc.unidad_compra,
    COUNT(DISTINCT c.id_compra) AS numero_compras,
    SUM(dc.cantidad) AS cantidad_total_comprada
FROM Detalle_Compra AS dc
JOIN Compra AS c
    ON dc.id_compra = c.id_compra
JOIN Item_Inventario AS i
    ON dc.id_item_inventario = i.id_item_inventario
LEFT JOIN Producto AS p
    ON i.id_producto = p.id_producto
LEFT JOIN Ingrediente AS ing
    ON i.id_ingrediente = ing.id_ingrediente
GROUP BY i.id_item_inventario, articulo, i.tipo_item, dc.unidad_compra
ORDER BY cantidad_total_comprada DESC;


SELECT
    COALESCE(p.nombre, ing.nombre) AS articulo,
    i.tipo_item,
    m.cantidad,
    CASE
        WHEN i.tipo_item = 'ingrediente' THEN ing.unidad_base
        ELSE 'unidad'
    END AS unidad,
    m.fecha_hora,
    u.nombre AS usuario_responsable,
    m.motivo
FROM Movimiento_Inventario AS m
JOIN Item_Inventario AS i
    ON m.id_item_inventario = i.id_item_inventario
LEFT JOIN Producto AS p
    ON i.id_producto = p.id_producto
LEFT JOIN Ingrediente AS ing
    ON i.id_ingrediente = ing.id_ingrediente
JOIN Usuario AS u
    ON m.id_usuario = u.id_usuario
WHERE m.tipo_movimiento = 'merma'
ORDER BY m.fecha_hora DESC;


SELECT
    p.nombre AS producto,
    SUM(dv.cantidad) AS unidades_vendidas,
    COUNT(DISTINCT v.id_venta) AS numero_ventas
FROM Detalle_Venta AS dv
JOIN Producto AS p
    ON dv.id_producto = p.id_producto
JOIN Venta AS v
    ON dv.id_venta = v.id_venta
GROUP BY p.id_producto, p.nombre
ORDER BY unidades_vendidas DESC;


SELECT
    m.fecha_hora,
    COALESCE(p.nombre, ing.nombre) AS articulo,
    m.tipo_movimiento,
    m.cantidad,
    CASE
        WHEN i.tipo_item = 'ingrediente' THEN ing.unidad_base
        ELSE 'unidad'
    END AS unidad,
    u.nombre AS usuario,
    m.motivo
FROM Movimiento_Inventario AS m
JOIN Item_Inventario AS i
    ON m.id_item_inventario = i.id_item_inventario
LEFT JOIN Producto AS p
    ON i.id_producto = p.id_producto
LEFT JOIN Ingrediente AS ing
    ON i.id_ingrediente = ing.id_ingrediente
JOIN Usuario AS u
    ON m.id_usuario = u.id_usuario
WHERE m.fecha_hora >= '2026-11-01 00:00:00'
  AND m.fecha_hora <  '2026-12-01 00:00:00'
ORDER BY m.fecha_hora DESC;

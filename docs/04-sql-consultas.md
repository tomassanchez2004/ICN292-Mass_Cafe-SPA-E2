# SQL y consultas de negocio

Motor: **MySQL 8.0 o superior**.

## 1. Archivos y orden de ejecución

| Orden | Archivo | Qué hace |
|---|---|---|
| 1 | `schema.sql` | Crea la base `inventafood` y sus 14 tablas, con claves primarias, claves foráneas y restricciones (`CHECK`, `UNIQUE`). |
| 2 | `seed.sql` | Carga datos sintéticos coherentes con Mass Café SPA (productos, ingredientes, recetas, usuarios, ventas, compras, movimientos y alertas de noviembre de 2026). |
| 3 | `consultas.sql` | Ejecuta las 6 consultas de negocio descritas en la sección 3. |
| 4 | `registrar_venta.sql` | Crea el procedimiento `registrar_venta` (RF03) y ejecuta una demostración. **Modifica el stock**, por lo que se ejecuta después de las consultas. |

En MySQL Workbench: abrir cada archivo (File → Open SQL Script) y ejecutarlo completo con el botón del rayo, en el orden indicado. Si la base ya existía, ejecutar antes `DROP DATABASE IF EXISTS inventafood;`.

Los resultados de la sección 3 corresponden a la base recién cargada con `schema.sql` y `seed.sql`.

## 2. Relación con los requerimientos

| Consulta / script | Requerimiento |
|---|---|
| Consulta 1: artículos en o bajo el stock mínimo | RF04, RF05, RF06, RF07 |
| Consulta 2: consumo de ingredientes por ventas | RF03 |
| Consulta 3: compras por artículo | RF02 |
| Consulta 4: mermas registradas | RF08 |
| Consulta 5: productos más vendidos | RF03 (relación venta–producto) |
| Consulta 6: historial de movimientos de noviembre | RF11 |
| `registrar_venta.sql` | RF03, RNF01, RNF02, RNF05 |

## 3. Consultas de negocio e interpretación

### Consulta 1: artículos en o bajo el stock mínimo

Lista los productos e ingredientes con `stock_actual <= stock_minimo` (condición de RF06) y cuánto falta para llegar al mínimo.

| Artículo | Stock actual | Stock mínimo | Falta para el mínimo |
|---|---|---|---|
| Café en grano | 1306 g | 1400 g | 94 g |
| Té chai | 38 g | 40 g | 2 g |

**Interpretación:** dos ingredientes requieren reposición. El café en grano es el caso más importante, porque es la base de la mayoría de las bebidas (ver consulta 5) y además tuvo una merma de 50 g (consulta 4). Esta es la misma condición que usa la automatización n8n para generar alertas (ver `05-automatizacion-n8n.md`).

### Consulta 2: consumo de ingredientes asociado a ventas

Suma la cantidad utilizada de cada ingrediente en las ventas registradas (`Detalle_Venta_Ingrediente`).

| Ingrediente | Cantidad utilizada | Ventas en que se usó |
|---|---|---|
| Leche | 1700 ml | 4 |
| Pollo | 160 g | 1 |
| Harina | 150 g | 1 |
| Agua | 150 ml | 1 |
| Café en grano | 144 g | 3 |
| Cacao | 60 g | 1 |
| Mantequilla | 60 g | 1 |
| Tomate | 40 g | 1 |
| Lechuga | 30 g | 1 |
| Chocolate en polvo | 25 g | 1 |
| Té chai | 12 g | 1 |
| Vaso desechable | 10 unidades | 4 |
| Tapa de vaso | 7 unidades | 3 |
| Pan | 4 unidades | 1 |
| Huevo | 1,5 unidades | 1 |

**Interpretación:** la leche, el café en grano y los vasos son los insumos que aparecen en más ventas. Esta consulta muestra lo que Fudo no permite ver hoy: qué ingredientes se consumen en cada venta. Las unidades no son comparables entre sí (g, ml y unidades), por lo que el orden sirve para identificar los insumos de uso frecuente, no para comparar cantidades entre ingredientes distintos.

### Consulta 3: compras por artículo

Resume las compras registradas por artículo: número de compras y cantidad total comprada.

| Artículo | Tipo | Compras | Cantidad comprada |
|---|---|---|---|
| Leche | ingrediente | 1 | 2000 ml |
| Café en grano | ingrediente | 1 | 500 g |
| Harina | ingrediente | 1 | 500 g |
| Pollo | ingrediente | 1 | 500 g |
| Chocolate en polvo | ingrediente | 1 | 200 g |
| Cacao | ingrediente | 1 | 200 g |
| Mantequilla | ingrediente | 1 | 200 g |
| Lechuga | ingrediente | 1 | 200 g |
| Tomate | ingrediente | 1 | 200 g |
| Té chai | ingrediente | 1 | 50 g |
| Pan | ingrediente | 1 | 30 unidades |
| Agua mineral botella | producto | 1 | 24 unidades |

**Interpretación:** en el período hay 3 compras (a Distribuidora Central, Lácteos del Valle y Comercial San Martín) que cubren 12 artículos. Este historial es el que usa la lista de compras de n8n para asociar cada artículo con el proveedor de su última compra.

### Consulta 4: mermas registradas

Lista las mermas con artículo, cantidad, fecha, responsable y motivo.

| Artículo | Cantidad | Fecha | Responsable | Motivo |
|---|---|---|---|---|
| Café en grano | 50 g | 12-11-2026 17:00 | Camila Torres | Café derramado y no recuperable |
| Leche | 100 ml | 12-11-2026 17:00 | Camila Torres | Leche vencida |
| Chocolate en polvo | 30 g | 12-11-2026 17:00 | Camila Torres | Producto derramado |
| Harina | 100 g | 12-11-2026 17:00 | Camila Torres | Harina contaminada |

**Interpretación:** hay 4 mermas registradas por la dueña, con motivos de derrame, vencimiento y contaminación. Registrar el motivo permite distinguir pérdidas por manipulación de pérdidas por vencimiento, que es uno de los problemas identificados en el caso.

### Consulta 5: productos más vendidos

Suma las unidades vendidas por producto y el número de ventas en que aparecen.

| Producto | Unidades vendidas | Número de ventas |
|---|---|---|
| Café latte | 5 | 2 |
| Brownie | 3 | 1 |
| Capuccino | 2 | 1 |
| Sandwich de pollo | 2 | 1 |
| Café americano | 1 | 1 |
| Chocolate caliente | 1 | 1 |
| Té chai latte | 1 | 1 |

**Interpretación:** el café latte es el producto más vendido. Como su receta usa café en grano y leche, explica que esos dos ingredientes sean los de mayor consumo (consulta 2) y que el café en grano esté bajo el mínimo (consulta 1).

### Consulta 6: historial de movimientos de noviembre de 2026

Lista todos los movimientos de inventario entre el 01-11-2026 y el 30-11-2026, con fecha, artículo, tipo, cantidad, unidad, usuario y motivo.

**Resultado:** 45 movimientos: 27 entradas (stock inicial y compras), 14 salidas (consumo asociado a ventas) y 4 mermas.

**Interpretación:** la consulta cumple RF11: permite revisar, para un período elegido, qué entró, qué salió y qué se perdió, y quién lo registró. El rango de fechas se cambia en la condición `WHERE m.fecha_hora >= ... AND m.fecha_hora < ...`.

## 4. Registro de venta con descuento automático (RF03)

`registrar_venta.sql` crea el procedimiento almacenado `registrar_venta(id_usuario, id_producto, cantidad)`. En una sola llamada:

1. Valida que el usuario sea trabajador de barra o la dueña (actores y RNF01).
2. Valida que la cantidad sea mayor que 0, que el producto exista y que haya stock suficiente.
3. Registra la venta en `Venta` y `Detalle_Venta`.
4. Calcula los ingredientes usados según la receta (`Configuracion_Producto` × cantidad vendida) y los guarda en `Detalle_Venta_Ingrediente`.
5. Registra una `salida` en `Movimiento_Inventario` por cada ítem afectado.
6. Descuenta el `stock_actual` en `Item_Inventario`, tanto de los ingredientes de la receta como de los productos que se venden directamente (por ejemplo, agua mineral).

Todo se ejecuta en una transacción: si una validación o instrucción falla, no se guarda ningún cambio (RNF05).

**Supuesto:** la unidad de la receta es la misma unidad base del ingrediente, como ocurre en `seed.sql`. Si en el futuro se usaran unidades distintas, haría falta una tabla de conversión.

### 4.1 Demostración incluida en el script

1. `CALL registrar_venta(2, 1, 2);`: Valentina Rojas (barra) vende 2 café latte.
2. `CALL registrar_venta(2, 8, 1);`: Valentina vende 1 agua mineral (venta directa de producto).

| Artículo | Stock antes | Stock después |
|---|---|---|
| Café en grano | 1306 g | 1270 g |
| Leche | 5200 ml | 4800 ml |
| Vaso desechable | 90 | 88 |
| Tapa de vaso | 93 | 91 |
| Agua mineral botella | 24 | 23 |

La venta de café latte genera automáticamente 4 filas en `Detalle_Venta_Ingrediente` (36 g de café, 400 ml de leche, 2 vasos y 2 tapas) y las salidas correspondientes en `Movimiento_Inventario`.


### 4.2 Limitaciones

- El procedimiento registra un producto por llamada, una venta con varios productos requiere varias llamadas.
- Por la implementación en base de datos de RF03, trabajadores deben de registrar ventas desde el celular (por ejemplo, un bot de Telegram conectado vía n8n).
- Los procedimientos almacenados requieren MySQL y algunos servicios compatibles con MySQL, como TiDB Cloud, no los soportan.


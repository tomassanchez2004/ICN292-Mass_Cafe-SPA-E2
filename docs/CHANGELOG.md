# CHANGELOG

Cambios relevantes del proyecto InventaFood (Mass Café SPA) desde la Entrega 1.

## [v1.0-e2] Entrega 2 

### Se mantiene
- El mismo caso PYME (Mass Café SPA, La Cantina del Café), el mismo problema (gestión de inventario) y el mismo equipo de la Entrega 1. La fuente es la entrevista con la dueña del 04-09-2026 (`docs/00-caso-pyme.md`).
- Los requerimientos RF01–RF11 y RNF01–RNF05 y su priorización MoSCoW, salvo los tres que se indican abajo.

### Cambiado
- **RF04:** la consulta de stock debe mostrar la cantidad actual y la unidad de medida.
- **RF06:** la alerta se genera cuando el stock es **igual o inferior** al mínimo configurado. Antes no tenía un criterio medible.
- **RF11:** la consulta del historial permite elegir un período y muestra fecha, tipo de movimiento y cantidad.
- **BPMN to-be:** se corrigieron las compuertas. Hay una compuerta inclusiva después de "seleccionar producto vendido" (un pedido puede ir a cocina, a barra o a ambas), otra inclusiva para unir las alertas de cocina y barra, y una exclusiva para el control de inventario.
- **BPMN to-be:** las tareas "generar alerta de reposición", "notificar alerta de reposición" y "agregar productos a la lista de compras" quedan automatizadas con n8n.
- **Motor de base de datos:** de PostgreSQL (propuesto en la E1) a **MySQL 8**, porque el equipo tiene más experiencia con él. El modelo lógico no cambia.

### Agregado
- **Modelo de datos:** modelo entidad-relación de 14 entidades en 3FN, con diccionario de datos (`docs/03-modelo-datos.md`, `.drawio` y `.png`).
- **SQL ejecutable:**
  - `schema.sql`: base `inventafood` con 14 tablas, PK, FK, `UNIQUE`, `CHECK` y `ON DELETE RESTRICT`.
  - `seed.sql`: 182 registros sintéticos coherentes (el stock cuadra con los movimientos).
  - `consultas.sql`: 6 consultas de negocio interpretadas en `docs/04-sql-consultas.md`.
  - `registrar_venta.sql`: procedimiento que registra una venta y descuenta automáticamente los ingredientes según la receta, en una transacción, validando rol y stock (RF03).
- **Automatización con n8n** (`docs/05-automatizacion-n8n.md`):
  - Flujo 1, `flujo1_alerta_reposicion.json`: alerta de reposición por Telegram cada 30 minutos (RF06).
  - Flujo 2, `flujo2_lista_compras.json`: lista de compras por proveedor los martes y viernes a las 08:00 (RF07).
  - Ambos flujos se ejecutaron y probaron en n8n Cloud, con una copia de la base en TiDB Cloud (compatible con MySQL) y un bot de Telegram.
- **Evidencias:** carpeta `evidencias/` con capturas de MySQL Workbench, n8n y Telegram.
- **Documentación:** `README.md` con los pasos para reproducir el proyecto, `docs/00` a `docs/05`, este `CHANGELOG.md` y `DECLARACION_IA.md`.
- **Informe** (PDF y Word) en `informe/` y **presentación** en `presentacion/`.

### Corregido durante la Entrega 2
- Flujos n8n: la condición de alerta pasó de `stock_actual <= stock_minimo * 1.10` a `stock_actual <= stock_minimo`, para cumplir exactamente el RF06 actualizado.
- Flujos n8n: el estado de alerta se escribe `'pendiente'` en minúscula, igual que el `CHECK` de `schema.sql`.
- Flujos n8n: se agregó un nodo "¿Hay artículos?" para no insertar ni enviar mensajes vacíos.
- Flujos n8n: el `INSERT` usa el parámetro `$1`, que es la sintaxis del nodo MySQL de n8n.
- Flujos n8n: se fijó la zona horaria `America/Santiago` para el horario de martes y viernes.
- `seed.sql`: las ventas 3 y 5 estaban registradas por un usuario de cocina. Ahora las registran usuarios de barra (Diego Pérez y Valentina Rojas), como indican los requerimientos. No cambia el resultado de ninguna consulta.

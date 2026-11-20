# Automatización con n8n

Estado: borrador, pendiente de prueba con la base MySQL final.

## 1. Objetivo

Automatizar dos tareas del proceso BPMN TO-BE de InventaFood que hoy la dueña hace revisando el inventario a mano:

1. Generar la alerta de reposición cuando un artículo llega o se acerca a su stock mínimo (RF06).
2. Preparar la lista de productos e ingredientes que requieren reposición, agrupada por proveedor, antes de las compras de martes y viernes (RF07).

Herramienta: n8n, conectado a la base de datos **MySQL** de InventaFood (decisión de la Entrega 2, ver `03-modelo-datos.md`, sección 6). Las alertas se envían por Telegram.

## 2. Trazabilidad BPMN → n8n

Los nombres de tareas corresponden al diagrama BPMN TO-BE actualizado (fase "actualización del inventario" y fase "reposición de productos").

1. Tarea BPMN: generar alerta de reposición (carriles cocina y barra, tras "¿algún ingrediente bajo el mínimo?")
- Requerimientos: RF05, RF06
- Flujo n8n: Flujo 1, `flujo1_alerta_reposicion.json`
- Nodos: Cada 30 minutos → Items bajo minimo sin alerta → Registrar alerta en BD

2. Tarea BPMN: notificar alerta de reposición (carril dueña)
- Requerimiento: RF06
- Flujo n8n: Flujo 1, `flujo1_alerta_reposicion.json`
- Nodos: Armar mensaje → Avisar a la duena (Telegram)

3. Tarea BPMN: agregar productos a la lista de compras**, con el temporizador "martes y viernes" (carril dueña)
- Requerimiento: RF07
- Flujo n8n: Flujo 2, `flujo2_lista_compras.json`
- Nodos: Martes y viernes 08:00 → Items a reponer → Agrupar por proveedor → Enviar lista a la duena (Telegram)

Las compuertas inclusivas del BPMN que unen las alertas de cocina y barra se resuelven en la base de datos: la consulta del flujo 1 revisa todos los artículos de `Item_Inventario` sin distinguir área, por lo que una o ambas áreas pueden generar alerta en la misma ejecución.

### 2.1 Actividades del BPMN TO-BE

El diagrama tiene cuatro fases, tres carriles (cocina, barra, dueña) y un pool externo (Proveedor).

Fase 1, configuración y registro. La dueña inicia sesión en InventaFood, agrega productos de venta, configura ingredientes y cantidades de los productos, configura la merma por producto y envía una solicitud a los trabajadores. Barra y cocina inician sesión en InventaFood.

Fase 2, actualización del inventario. Barra selecciona el producto vendido. Una compuerta inclusiva deriva el pedido a cocina, a barra o a ambas. Cada área ejecuta el subproceso "procesamiento automático de inventario" y luego decide "¿algún ingrediente bajo el mínimo?". Si es que no, continúa la operación; si es que sí, se genera la alerta de reposición.

Fase 3, reposición de productos. Las alertas de cocina y barra se unen en una compuerta inclusiva. La dueña notifica y revisa las alertas de reposición y agrega productos a la lista de compras. Los martes y viernes decide si compra de forma independiente (realiza la compra) o con proveedor (envía solicitud de compra; el proveedor la recibe, prepara y entrega los productos). Luego recibe los productos, registra la entrada en InventaFood y actualiza el stock.

Fase 4, control general del inventario. Los viernes la dueña revisa el inventario general de InventaFood y lo compara con el inventario físico. Si existen diferencias, ajusta el inventario general en InventaFood. Después confirma el inventario general.

Las tareas automatizadas con n8n son las de alertas y lista de compras. El subproceso "procesamiento automático de inventario" (descuento de ingredientes por venta) queda fuera de n8n.

## 3. Flujo 1: Alerta de reposición

Disparador: cada 30 minutos.

1. Items bajo minimo sin alerta (MySQL): selecciona artículos con `stock_actual <= stock_minimo * 1.10` que no tengan una alerta en estado `Pendiente`. El margen de 10 % cubre "se aproxima al mínimo" de RF06. La condición `NOT EXISTS` evita alertas duplicadas.
2. **Registrar alerta en BD** (MySQL): inserta una fila en `Alerta_Reposicion` por cada artículo, con `fecha_generacion = NOW()` y `estado = 'Pendiente'`.
3. Armar mensaje (Code): junta todos los artículos en un solo texto.
4. Avisar a la dueña (Telegram): envía el mensaje.

Si no hay artículos bajo el mínimo, el flujo termina sin enviar nada.

## 4. Flujo 2: Lista de compras

**Disparador:** martes y viernes a las 08:00 (`0 8 * * 2,5`), que corresponde al temporizador "martes y viernes" del BPMN, de modo que la lista esté lista antes de comprar.

1. Items a reponer (MySQL): artículos en o cerca del mínimo. Como el modelo no relaciona directamente artículo con proveedor, el proveedor se toma de la **última compra** del artículo (`Detalle_Compra` → `Compra` → `Proveedor`). Si nunca se ha comprado, aparece como "Sin proveedor asignado". La cantidad sugerida es la necesaria para llegar a 2 veces el mínimo (criterio propuesto, ajustable).
2. **Agrupar por proveedor** (Code): arma el texto agrupado.
3. **Enviar lista a la duena** (Telegram).

## 5. Cómo instalarlo y probarlo

Requisitos: n8n en funcionamiento y MySQL 8 o superior (la consulta del flujo 2 usa `WITH` y `ROW_NUMBER()`).

1. En n8n: menú → Import from File → elegir cada `.json`.
2. En los nodos MySQL, crear la credencial con host, puerto, base, usuario y clave. Si n8n corre en Docker y MySQL en el computador, usar `host.docker.internal` como host; si ambos están en el mismo `docker-compose`, usar el nombre del servicio.
3. En los nodos Telegram, crear la credencial con el token de un bot (BotFather) y reemplazar `REEMPLAZAR_CHAT_ID_DE_LA_DUENA` por el chat id real.
4. Verificar que `Alerta_Reposicion.id_alerta` sea `AUTO_INCREMENT` y que el valor de `estado` usado en el `seed.sql` coincida con `'Pendiente'`. Si el equipo usa otro valor, cambiarlo en el flujo 1.
5. **Prueba real:** en `seed.sql` debe existir al menos un artículo con `stock_actual <= stock_minimo`. Ejecutar cada flujo con Execute workflow y comprobar:
   - Llega el mensaje a Telegram.
   - Existe la fila nueva en `Alerta_Reposicion`.
   - Al ejecutar el flujo 1 por segunda vez no se duplica la alerta.
6. Guardar evidencia real de la ejecución (capturas del canvas de n8n y del resultado en MySQL) en el repositorio.

## 6. Limitaciones

- En el BPMN la alerta se genera justo después de cada venta; en n8n el flujo 1 revisa la base cada 30 minutos, por lo que la alerta puede tardar hasta ese tiempo en generarse.
- El descuento automático de ingredientes al registrar una venta (RF03) **no** está implementado en n8n; corresponde a la lógica del sistema o a SQL.
- La relación artículo–proveedor se infiere de la última compra; un modelo con proveedor preferente por artículo sería más preciso.
- La cantidad sugerida de compra (2 × mínimo − stock) es un criterio simple, no un cálculo de demanda.
- El estado de la alerta se cambia a atendida de forma manual o desde el sistema; n8n solo la crea.


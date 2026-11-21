# Automatización con n8n
## 1. Objetivo
Automatizar dos tareas del proceso BPMN TO-BE de InventaFood que hoy la dueña hace revisando el inventario a mano:
1. Generar la alerta de reposición cuando un artículo llega o se acerca a su stock mínimo (RF06).
2. Preparar la lista de productos e ingredientes que requieren reposición, agrupada por proveedor, antes de las compras de martes y viernes (RF07).

Herramienta: n8n (versión Cloud), conectado a la base de datos MySQL de InventaFood (decisión de la Entrega 2). La base se cargó con `schema.sql` y `seed.sql` en TiDB Cloud Starter, un servicio en la nube compatible con el protocolo y la sintaxis de MySQL 8. Las alertas se envían por Telegram.
## 2. Trazabilidad BPMN → n8n
Los nombres de tareas corresponden al diagrama BPMN TO-BE actualizado (fase "actualización del inventario" y fase "reposición de productos").
1. Tarea BPMN: generar alerta de reposición (carriles cocina y barra, tras "¿algún ingrediente bajo el mínimo?")
- Requerimientos: RF05, RF06
- Flujo n8n: Flujo 1, `flujo1_alerta_reposicion.json`
- Nodos: Cada 30 minutos → Items bajo minimo sin alerta → Hay articulos? → Registrar alerta en BD
2. Tarea BPMN: notificar alerta de reposición (carril dueña)
- Requerimiento: RF06
- Flujo n8n: Flujo 1, `flujo1_alerta_reposicion.json`
- Nodos: Armar mensaje → Avisar a la duena (Telegram)
3. Tarea BPMN: agregar productos a la lista de compras, con el temporizador "martes y viernes" (carril dueña)
- Requerimiento: RF07
- Flujo n8n: Flujo 2, `flujo2_lista_compras.json`
- Nodos: Martes y viernes 08:00 → Items a reponer → Hay articulos? → Agrupar por proveedor → Enviar lista a la duena (Telegram)

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

1. **Items bajo minimo sin alerta** (MySQL): selecciona artículos con `stock_actual <= stock_minimo * 1.10` que no tengan una alerta en estado `pendiente`. El nombre del artículo se obtiene de `Ingrediente` o `Producto` según el tipo de ítem. El margen de 10 % cubre "se aproxima al mínimo" de RF06. La condición `NOT EXISTS` evita alertas duplicadas.
2. **Hay articulos?** (IF): continúa solo si la consulta devolvió artículos. Si no hay ninguno, el flujo termina sin insertar ni enviar nada.
3. **Registrar alerta en BD** (MySQL): inserta una fila en `Alerta_Reposicion` por cada artículo, con `fecha_generacion = NOW()` y `estado = 'pendiente'`. El id del artículo se pasa como parámetro (`$1`, con Query Replacement `{{ String($json.id_item_inventario) }}`), no concatenado en el texto de la consulta.
4. **Armar mensaje** (Code): junta todos los artículos en un solo texto.
5. **Avisar a la duena** (Telegram): envía el mensaje al chat de la dueña.

El valor `'pendiente'` se escribe en minúscula para coincidir con el `CHECK (estado IN ('pendiente', 'atendida', 'cancelada'))` de `schema.sql`.

## 4. Flujo 2: Lista de compras

**Disparador:** martes y viernes a las 08:00 (`0 8 * * 2,5`), con zona horaria `America/Santiago`, que corresponde al temporizador "martes y viernes" del BPMN, de modo que la lista esté lista antes de comprar.

1. **Items a reponer** (MySQL): artículos en o cerca del mínimo. Como el modelo no relaciona directamente artículo con proveedor, el proveedor se toma de la **última compra** del artículo (`Detalle_Compra` → `Compra` → `Proveedor`), usando `ROW_NUMBER()` ordenado por `fecha_hora` y luego por `id_compra`. Si nunca se ha comprado, aparece como "Sin proveedor asignado". La cantidad sugerida es la necesaria para llegar a 2 veces el mínimo (criterio propuesto, ajustable).
2. **Hay articulos?** (IF): si no hay nada que reponer, no se envía mensaje.
3. **Agrupar por proveedor** (Code): arma el texto agrupado.
4. **Enviar lista a la duena** (Telegram).

## 5. Cómo instalarlo y probarlo

Requisitos: una instancia de n8n con acceso a internet y una base MySQL 8 o compatible (la consulta del flujo 2 usa `WITH` y `ROW_NUMBER()`). En este proyecto se usó n8n Cloud y TiDB Cloud Starter. n8n Cloud no puede conectarse a un MySQL instalado en un computador personal (`localhost`), por eso la base se dejó en la nube.

1. **Base de datos:** crear un cluster TiDB Cloud Starter (compatibilidad MySQL) y, en su SQL Editor, ejecutar `schema.sql` y luego `seed.sql`.
2. **Credencial MySQL en n8n:** Credentials → MySQL, con los datos de la ventana *Connect* de TiDB:
   - Host: `gateway01.<región>.prod.aws.tidbcloud.com`
   - Puerto: `4000`
   - Base: `inventafood`
   - Usuario y clave generados por TiDB
   - SSL activado (TiDB exige conexión cifrada)
3. **Bot de Telegram:** crear el bot con @BotFather, crear en n8n la credencial *Telegram API* con su token y obtener el chat id de la dueña desde `https://api.telegram.org/bot<TOKEN>/getUpdates`, después de enviarle un mensaje al bot.
4. **Importar los flujos:** en n8n, New workflow → ⋯ → Import from File, elegir cada `.json`, asignar las credenciales en los nodos MySQL y Telegram y reemplazar `REEMPLAZAR_CHAT_ID_DE_LA_DUENA` por el chat id real.
5. **Preparar la prueba:** en el `seed.sql` los artículos que están cerca del mínimo (Café en grano y Té chai) ya tienen una alerta `pendiente`, por lo que el flujo 1 no los vuelve a alertar. Para probar con un caso nuevo se dejó el Pan bajo su mínimo:
   ```sql
   UPDATE inventafood.Item_Inventario SET stock_actual = 15.000 WHERE id_item_inventario = 10;
   ```
6. **Prueba real:** ejecutar cada flujo con Execute workflow y comprobar los resultados (ver 5.1).
7. Guardar la evidencia de la ejecución (capturas del canvas de n8n, de Telegram y del resultado en la base) en el repositorio.

### 5.1 Resultados de la prueba

| Prueba | Resultado esperado | Resultado obtenido |
|---|---|---|
| Flujo 1, primera ejecución | Detecta el Pan, registra la alerta y avisa por Telegram | 1 artículo; todos los nodos en verde; mensaje recibido |
| Alerta en la base | Nueva fila en `Alerta_Reposicion` con `id_item_inventario = 10` y estado `pendiente` | Fila creada correctamente |
| Flujo 1, segunda ejecución | No duplica la alerta ni envía mensaje | La consulta no devuelve artículos y el flujo se detiene |
| Flujo 2 | Lista agrupada por proveedor con Café en grano, Té chai y Pan | 3 artículos agrupados por proveedor en un solo mensaje |

Lista esperada del flujo 2 con los datos del seed (y el Pan en 15):

- Comercial San Martín: Pan, pedir 25 unidades.
- Distribuidora Central: Café en grano, pedir 1494 g; Té chai, pedir 42 g.

## 6. Limitaciones

- En el BPMN la alerta se genera justo después de cada venta; en n8n el flujo 1 revisa la base cada 30 minutos, por lo que la alerta puede tardar hasta ese tiempo en generarse.
- El descuento automático de ingredientes al registrar una venta (RF03) no está implementado en n8n; corresponde a la lógica del sistema o a SQL.
- La relación artículo–proveedor se infiere de la última compra; un modelo con proveedor preferente por artículo sería más preciso.
- La cantidad sugerida de compra (2 × mínimo − stock) es un criterio simple, no un cálculo de demanda.
- El estado de la alerta se cambia a atendida de forma manual o desde el sistema; n8n solo la crea.
- La base en TiDB Cloud guarda `NOW()` en hora UTC, por lo que `fecha_generacion` queda 3 horas adelantada respecto de la hora de Chile.
- TiDB asigna los valores `AUTO_INCREMENT` por bloques, por lo que los `id_alerta` nuevos no son correlativos con los del seed (por ejemplo, 30002 en vez de 4).
- TiDB no aplica por defecto las restricciones `CHECK` del schema (las acepta pero no las valida), a diferencia de MySQL 8.
- Se usó la versión de prueba de n8n Cloud (14 días, 1.000 ejecuciones). Con el flujo 1 activo cada 30 minutos se consumen unas 48 ejecuciones al día.

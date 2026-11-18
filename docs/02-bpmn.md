# Modelamiento del proceso BPMN
## 1. Objetivo
El objetivo del modelamiento BPMN es representar el proceso de gestión de inventario de La Cantina del Café, mostrando las actividades que permiten registrar las ventas, descontar automáticamente los ingredientes utilizados, actualizar el inventario y gestionar las alertas de reposición.
## 2. Descripción del proceso
El proceso comienza con la configuración de los productos y sus ingredientes en InventaFood. Cuando se registra una venta, el sistema identifica los productos vendidos y determina los ingredientes asociados a cada uno, para después descontar las cantidades correspondientes del inventario y se actualiza el stock disponible. donde también se registran las mermas y se revisan los niveles mínimos de inventario.

Cuando el stock de un producto o ingrediente alcanza su nivel mínimo, el sistema genera una alerta de reposición, ya a partir de esta se puede preparar la lista de productos e ingredientes que necesitan ser comprados.

El proceso termina cuando se realiza el control del inventario físico y se compara con las cantidades registradas en InventaFood, y si existen diferencias, se ajusta el inventario general antes de confirmar el resultado.
## 3. Subprocesos
En el proceso se encuentran dos subprocesos principales:
- Gestión de productos de cocina: identifica los ingredientes utilizados en los productos vendidos en cocina y descuenta las cantidades correspondientes del inventario.
- Gestión de productos de barra: identifica los ingredientes utilizados en los productos vendidos en barra y descuenta las cantidades correspondientes del inventario.

Ambos subprocesos permiten mantener actualizado el inventario de ingredientes según las ventas realizadas.

## 4. Cambios realizados respecto a la Entrega 1

Para la Entrega 2 se revisó el modelo BPMN desarrollado en la Entrega 1 y se realizaron ajustes en las compuertas para representar correctamente las decisiones y uniones de los flujos del proceso.

Los principales cambios fueron:
1. Compuerta inclusiva después de seleccionar el producto vendido: permite que el proceso continúe por cocina, barra o ambas áreas, dependiendo de los productos incluidos en el pedido.
2. Compuerta inclusiva para unir las alertas de reposición: permite reunir los flujos provenientes de cocina y barra, considerando que puede generarse una alerta en una o en ambas áreas.
3. Compuerta exclusiva para unir los caminos del control de inventario: permite reunir los caminos correspondientes a la existencia o ausencia de diferencias en el inventario antes de continuar con la confirmación del inventario general.

Estos ajustes permiten representar de mejor manera la lógica del proceso y evitar uniones incorrectas entre los flujos.

## 5. Archivos del modelamiento
- Diagrama BPMN actualizado en formato PNG: "BPMN_TO_BE_E2.png".
- Archivo editable del modelamiento: "BPMN_TO_BE_E2.bpm".

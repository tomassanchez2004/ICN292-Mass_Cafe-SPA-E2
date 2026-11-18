# Requerimientos del SIG – InventaFood
## 1. Objetivo del SIG
El objetivo del sistema es mejorar la gestión de inventario de Mass Café SPA mediante un control más oportuno del ingreso, salida y disponibilidad de productos e ingredientes, reduciendo la pérdida de tiempo por trabajo manual y facilitando las decisiones de compra.

El sistema deberá permitir mantener información actualizada del stock, identificar productos e ingredientes que requieren reposición y relacionar las ventas con los ingredientes utilizados.
## 2. Actores y roles
En el sistema participan tres tipos de actores:
- Dueña: tendrá acceso completo al sistema, pudiendo consultar y actualizar el inventario, registrar compras y mermas, configurar niveles mínimos de stock y revisar las necesidades de reposición.
- Trabajadores de barra: podrán registrar las ventas y consultar el inventario correspondiente a su área.
- Trabajadores de cocina: podrán consultar el inventario correspondiente a su área.
## 3. Alcance
### In
- Registro de la cantidad actual de productos e ingredientes.
- Registro de ingresos y salidas de productos e ingredientes.
- Actualización oportuna del stock.
- Registro de mermas de productos e ingredientes.
- Definición de niveles mínimos de stock.
- Relación entre ventas y productos e ingredientes utilizados en ellas.
- Descuento de productos e ingredientes utilizados al realizar una venta.
- Generación de alertas de reposición.
- Consulta del inventario según el área del trabajador.
- Consulta y modificación del inventario completo por parte de la dueña.
- Apoyo a la generación de listas de productos e ingredientes a reponer.
- Integración o cruce de información con las ventas registradas en Fudo, o reemplazo de Fudo por una solución que permita cubrir las necesidades del sistema de inventario.
### Out
- Gestión de proveedores como proceso independiente.
- Gestión contable de la cafetería.
- Gestión de recursos humanos.
- Administración general de las ventas como objetivo principal del proyecto, aunque se podrá evaluar el reemplazo de Fudo si resulta más viable para implementar la solución propuesta.

## 4. Requerimientos funcionales
- RF01: El sistema debe permitir registrar productos e ingredientes que forman parte del inventario de la cafetería.
- RF02: El sistema debe permitir registrar el ingreso de productos e ingredientes al inventario.
- RF03: El sistema debe registrar las salidas de productos e ingredientes asociadas a las ventas y actualizar el stock disponible según los productos e ingredientes utilizados.
- RF04: El sistema debe permitir consultar el stock disponible de cada producto e ingrediente registrado, mostrando su cantidad actual y unidad de medida.
- RF05: El sistema debe permitir definir un nivel mínimo de stock para cada producto o ingrediente.
- RF06: El sistema debe generar automáticamente una alerta de reposición cuando el stock disponible de un producto o ingrediente sea igual o inferior al nivel mínimo configurado.
- RF07: El sistema debe permitir generar una lista de productos e ingredientes que requieren reposición.
- RF08: El sistema debe permitir registrar mermas de productos e ingredientes.
- RF09: El sistema debe permitir a la dueña consultar y modificar el inventario completo.
- RF10: El sistema debe permitir a los trabajadores consultar únicamente el inventario correspondiente a su área.
- RF11: El sistema debe permitir consultar el historial de movimientos del inventario dentro de un período seleccionado, mostrando la fecha, el tipo de movimiento y la cantidad correspondiente a cada producto o ingrediente.

## 5. Requerimientos no funcionales
- RNF01: El sistema debe contar con control de acceso según el rol del trabajador.
- RNF02: La información del inventario debe actualizarse oportunamente después del registro de una entrada, salida, merma o venta.
- RNF03: El sistema debe ser accesible desde dispositivos móviles de los trabajadores y computadores de la cafetería.
- RNF04: El sistema debe ser simple y fácil de utilizar para los trabajadores que actualmente realizan el proceso mediante planillas en papel.
- RNF05: El sistema debe mantener la información del inventario almacenada de forma clara y consistente para evitar diferencias entre los registros y el stock disponible.

## 6. Priorización y justificación de requerimientos
Se utiliza la metodología MoSCoW para priorizar los requerimientos:
### Must
- RF01: Es necesario contar con los productos e ingredientes que estarán contenidos en el inventario.
- RF02: Permite registrar las entradas de productos e ingredientes al inventario.
- RF03: Es fundamental para actualizar el stock según las ventas y los productos e ingredientes utilizados, respondiendo al problema identificado.
- RF04: Permite conocer el stock disponible y su unidad de medida para facilitar el control del inventario.
- RF05: Permite establecer los niveles mínimos utilizados para decidir cuándo reponer.
- RF06: Permite anticipar posibles quiebres de stock mediante alertas cuando se alcanza o supera hacia abajo el nivel mínimo configurado.
- RF07: Apoya directamente las decisiones de compra y reposición.
- RF09: Es necesario que la dueña pueda consultar el inventario completo y modificarlo.
- RF10: Permite separar el acceso de los trabajadores según su área.
- RNF01: Permite controlar qué puede consultar cada trabajador según su rol.
- RNF02: Es fundamental mantener actualizada la información del inventario después de cada movimiento.
- RNF05: Es necesario mantener consistencia en la información para reducir diferencias entre el registro y el stock real disponible.
### Should
- RF08: Permite registrar las mermas y obtener información sobre las pérdidas de productos e ingredientes.
- RNF03: Permite utilizar el sistema desde dispositivos móviles de los trabajadores y computadores de la cafetería, facilitando el registro y consulta del inventario.
- RNF04: Busca facilitar el uso del sistema por parte de los trabajadores.
### Could
- RF11: Aporta información histórica adicional para apoyar futuras decisiones de compra.
## 7. Requerimientos trazados al problema
Cada problema identificado en la cafetería se relaciona con uno o más requerimientos del sistema
- El inventario se registra manualmente y requiere mantener identificados los productos e ingredientes que forman parte del stock: RF01, RF02, RF03, RNF02 y RNF05.
- Existen diferencias entre el stock registrado y el stock real: RF03, RF04 y RNF05.
- Fudo registra las ventas, pero no permite identificar en detalle los productos e ingredientes utilizados en cada venta: RF03.
- No se sabe con precisión qué productos o ingredientes deben comprarse, dificultando las decisiones de compra: RF04, RF05, RF06, RF07 y RF11.
- Se realizan compras adicionales durante la semana cuando faltan productos: RF05, RF06 y RF07.
- Existen pérdidas de productos por vencimiento y mermas: RF08.
- La dueña necesita consultar y modificar el inventario completo: RF09.
- Los trabajadores necesitan consultar el inventario correspondiente a su área: RF10 y RNF01.
- Se requiere facilitar el uso del sistema dentro de la cafetería: RNF03 y RNF04.
## 8. Actualizaciones realizadas para la Entrega 2
Respecto de la Entrega 1, se realizaron ajustes en tres requerimientos funcionales:
- RF04: Se especifica que la consulta de stock debe mostrar la cantidad actual y la unidad de medida de cada producto e ingrediente.
- RF06: Se establece una condición concreta para generar alertas: el stock debe ser igual o inferior al nivel mínimo configurado.
- RF11: Se especifica que la consulta histórica debe permitir seleccionar un período y visualizar la fecha, el tipo de movimiento y la cantidad correspondiente.

Estos cambios son debidos a que en la Entrega 1, tanto el RF04 y RF06 no explicitaban un criterio medible, mientras que el RF11 se entendía más como un propósito que como un resultado medible. 

Los demás requerimientos mantienen su propósito original y continúan respondiendo a las necesidades identificadas en la cafetería.

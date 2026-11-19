# Modelo de datos
## 1. Descripción del modelo entidad-relación
El modelo entidad-relación de InventaFood representa la información necesaria para gestionar el inventario de Mass Café SPA, donde el modelo está compuesto por 14 entidades que permiten administrar productos, ingredientes, ventas, inventario, compras, proveedores, usuarios y alertas de reposición.

Las entidades consideradas son:
1. Producto
2. Ingrediente
3. Configuracion_Producto
4. Venta
5. Detalle_Venta
6. Detalle_Venta_Ingrediente
7. Usuario
8. Área
9. Item_Inventario
10. Movimiento_Inventario
11. Compra
12. Detalle_Compra
13. Proveedor
14. Alerta_Reposicion

El modelo permite relacionar los productos vendidos con los ingredientes utilizados, registrar los cambios de stock y mantener un historial de los movimientos del inventario.

## 2. Relaciones entre las entidades
- Producto – Configuracion_Producto: un producto puede tener varias configuraciones de ingredientes.
- Ingrediente – Configuracion_Producto: un ingrediente puede utilizarse en distintos productos.
- Venta – Detalle_Venta: una venta puede contener uno o varios productos.
- Detalle_Venta – Detalle_Venta_Ingrediente: un detalle de venta puede generar varios registros de ingredientes utilizados.
- Ingrediente – Detalle_Venta_Ingrediente: un ingrediente puede aparecer en distintos registros de consumo.
- Producto – Item_Inventario: cada producto tiene un registro de inventario.
- Ingrediente – Item_Inventario: cada ingrediente tiene un registro de inventario.
- Item_Inventario – Movimiento_Inventario: un artículo puede tener múltiples movimientos.
- Item_Inventario – Detalle_Compra: un artículo puede aparecer en distintas compras.
- Item_Inventario – Alerta_Reposicion: un artículo puede generar distintas alertas.
- Usuario – Venta: un usuario puede registrar varias ventas.
- Usuario – Movimiento_Inventario: un usuario puede registrar varios movimientos.
- Usuario – Compra: un usuario puede registrar varias compras.
- Área – Usuario: un área puede tener varios usuarios.
- Proveedor – Compra: un proveedor puede estar asociado a varias compras.
## 3. Normalización del modelo
El modelo fue revisado considerando las tres primeras formas normales:
### 3.1 Primera Forma Normal (1FN)
El modelo cumple con 1FN porque cada entidad cuenta con una clave primaria que permite identificar de manera única sus registros y cada atributo almacena valores individuales, donde no existen grupos de datos repetidos dentro de una misma columna.
Por ejemplo, en la entidad Proveedor los datos de contacto se encuentran separados en los atributos telefono_proveedor y correo_proveedor.

## 3.2 Segunda Forma Normal (2FN)
El modelo cumple con 2FN porque sus atributos dependen completamente de la clave primaria de cada entidad. Las entidades utilizan claves primarias simples, por lo que no existen dependencias parciales respecto de una parte de una clave primaria compuesta.

### 3.3 Tercera Forma Normal (3FN)

El modelo cumple con 3FN porque los atributos que no son claves dependen directamente de la clave primaria de su respectiva entidad y no de otros atributos no clave. La información se encuentra distribuida en entidades independientes para evitar duplicidad y facilitar su actualización.

Por esto, el modelo se considera normalizado hasta la Tercera Forma Normal (3FN).
## 4. Diccionario de datos
### 4.1 Producto
- "id_producto": INT, PK. Identificador único del producto.
- "nombre": VARCHAR(100), NOT NULL. Nombre del producto.
- "precio": DECIMAL(10,2), NOT NULL. Precio de venta del producto.

### 4.2 Ingrediente
- "id_ingrediente": INT, PK. Identificador único del ingrediente.
- "nombre": VARCHAR(100), NOT NULL. Nombre del ingrediente.
- "unidad_base": VARCHAR(20), NOT NULL. Unidad utilizada para controlar el inventario del ingrediente.

### 4.3 Configuracion_Producto
- "id_configuracion": INT, PK. Identificador único de la configuración.
- "id_producto": INT, FK. Identificador del producto asociado.
- "id_ingrediente": INT, FK. Identificador del ingrediente utilizado.
- "grupo_opcion": VARCHAR(50), NOT NULL. Grupo o categoría al que pertenece el ingrediente dentro de la configuración.
- "cantidad": DECIMAL(10,3), NOT NULL. Cantidad de ingrediente utilizada en el producto.
- "unidad_receta": VARCHAR(20), NOT NULL. Unidad utilizada para expresar la cantidad del ingrediente en la receta.

### 4.4 Venta
- "id_venta": INT, PK. Identificador único de la venta.
- "fecha_hora": DATETIME, NOT NULL. Fecha y hora en que se realiza la venta.
- "id_usuario": INT, FK. Identificador del usuario que registra la venta.
### 4.5 Detalle_Venta
- "id_detalle_venta": INT, PK. Identificador único del detalle de venta.
- "id_venta": INT, FK. Identificador de la venta a la que pertenece.
- "id_producto": INT, FK. Identificador del producto vendido.
- "cantidad": INT, NOT NULL. Cantidad de unidades vendidas del producto.
### 4.6 Detalle_Venta_Ingrediente
- "id_detalle_venta_ingrediente": INT, PK. Identificador único del registro de consumo.
- "id_detalle_venta": INT, FK. Identificador del detalle de venta asociado.
- "id_ingrediente": INT, FK. Identificador del ingrediente utilizado.
- "cantidad_utilizada": DECIMAL(10,3), NOT NULL. Cantidad de ingrediente utilizada en la preparación.
- "unidad_consumo": VARCHAR(20), NOT NULL. Unidad en que se registra el consumo del ingrediente.
### 4.7 Usuario
- "id_usuario": INT, PK. Identificador único del usuario.
- "nombre": VARCHAR(100), NOT NULL. Nombre del usuario.
- "correo": VARCHAR(150), NOT NULL. Correo electrónico del usuario.
- "contraseña": VARCHAR(255), NOT NULL. Contraseña almacenada mediante un mecanismo de hash.
- "id_area": INT, FK. Identificador del área a la que pertenece el usuario.
- "rol": VARCHAR(30), NOT NULL. Rol o nivel de acceso del usuario dentro del sistema.
### 4.8 Área
- "id_area": INT, PK. Identificador único del área.
- "nombre_area": VARCHAR(50), NN. Nombre del área de trabajo.
### 4.9 Item_Inventario
- "id_item_inventario": INT, PK. Identificador único del artículo de inventario.
- "tipo_item": VARCHAR(20), NOT NULL. Indica si el artículo corresponde a un producto o ingrediente.
- "id_producto": INT, FK, NULL. Identificador del producto asociado, cuando corresponda.
- "id_ingrediente": INT, FK, NULL. Identificador del ingrediente asociado, cuando corresponda.
- "stock_actual": DECIMAL(10,3), NOT NULL. Cantidad disponible actualmente en el inventario.
- "stock_minimo": DECIMAL(10,3), NOT NULL. Cantidad mínima establecida para el artículo.
### 4.10 Movimiento_Inventario
- "id_movimiento": INT, PK. Identificador único del movimiento.
- "id_item_inventario": INT, FK. Identificador del artículo de inventario asociado.
- "tipo_movimiento": VARCHAR(30), NOT NULL. Tipo de movimiento realizado, como entrada, salida, merma o ajuste.
- "cantidad": DECIMAL(10,3), NOT NULL. Cantidad involucrada en el movimiento.
- "fecha_hora": DATETIME, NOT NULL. Fecha y hora en que se registra el movimiento.
- "id_usuario": INT, FK. Identificador del usuario que registra el movimiento.
- "motivo": VARCHAR(255), NOT NULL. Motivo por el cual se realiza el movimiento.
### 4.11 Compra
- "id_compra": INT, PK. Identificador único de la compra.
- "fecha_hora": DATETIME, NOT NULL. Fecha y hora en que se realiza la compra.
- "id_proveedor": INT, FK. Identificador del proveedor asociado a la compra.
- "id_usuario": INT, FK. Identificador del usuario que registra la compra.
### 4.12 Detalle_Compra
- "id_detalle_compra": INT, PK. Identificador único del detalle de compra.
- "id_compra": INT, FK. Identificador de la compra a la que pertenece.
- "id_item_inventario": INT, FK. Identificador del artículo de inventario comprado.
- "cantidad": DECIMAL(10,3), NOT NULL. Cantidad comprada del artículo.
- "unidad_compra": VARCHAR(20), NOT NULL. Unidad en que se registra la cantidad comprada.
### 4.13 Proveedor
- "id_proveedor": INT, PK. Identificador único del proveedor.
- "nombre": VARCHAR(100), NOT NULL. Nombre del proveedor.
- "telefono_proveedor": VARCHAR(20), NULL. Número telefónico de contacto del proveedor.
- "correo_proveedor": VARCHAR(150), NULL. Correo electrónico de contacto del proveedor.
### 4.14 Alerta_Reposicion
- "id_alerta": INT, PK. Identificador único de la alerta.
- "id_item_inventario": INT, FK. Identificador del artículo de inventario que genera la alerta.
- "fecha_generacion": DATETIME, NOT NULL. Fecha y hora en que se genera la alerta de reposición.
- "estado": VARCHAR(20), NOT NULL. Estado actual de la alerta.
- "fecha_atencion": DATETIME, NULL. Fecha y hora en que la alerta es atendida.
## 5. Consideraciones de implementación
Para implementar el modelo en MySQL se tendrán en cuenta las siguientes consideraciones:
- Las claves primarias permitirán identificar de manera única cada registro.
- Las claves foráneas permitirán mantener la integridad entre las entidades relacionadas.
- Se utilizarán restricciones para evitar registros inconsistentes.
- Las cantidades y los precios utilizarán tipos numéricos adecuados para evitar errores de precisión.
- Las contraseñas de los usuarios deberán almacenarse mediante mecanismos de hash y nunca como texto plano.
- La entidad Item_Inventario deberá asegurar que cada registro corresponda a un solo tipo de artículo.
- Las unidades de medida deberán manejarse de manera coherente para permitir conversiones entre unidades compatibles.

## 6. Cambio de tecnología: PostgreSQL a MySQL

En la Entrega 1 se había propuesto utilizar PostgreSQL como sistema de gestión de bases de datos, pero para la Entrega 2, el equipo decidió cambiar a MySQL, esto debido a que el grupo posee mayor conocimiento y experiencia trabajando con MySQL a lo largo del ramo. 

Así, el utilizar MySQL facilitará el desarrollo de la base de datos. Este cambio corresponde a una decisión tecnológica y no modifica el objetivo ni la estructura lógica del modelo entidad-relación.

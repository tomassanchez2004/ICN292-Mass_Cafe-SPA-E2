# 04 — Implementación SQL y consultas de negocio

## 1. Introducción

En esta sección se presenta la implementación de la base de datos del sistema de información de **InventaFood – Mass Cafe SPA**, desarrollada en MySQL Workbench.

El objetivo de esta implementación es disponer de una estructura de datos que permita gestionar la información relacionada con productos, ingredientes, inventario, ventas, compras, proveedores, usuarios y alertas de reposición.

La solución se compone de tres archivos SQL:

- `schema.sql`: creación de la base de datos y sus tablas.
- `seed.sql`: incorporación de datos de prueba para poblar las tablas.
- `consultas.sql`: consultas SQL orientadas a obtener información útil para la gestión del negocio.

Los scripts fueron ejecutados y probados en MySQL Workbench.

## 2. Creación de la base de datos (schema.sql)

El archivo `schema.sql` contiene las instrucciones necesarias para crear la base de datos `inventafood` y sus respectivas tablas.

La estructura está basada en las 14 entidades definidas en el modelo entidad-relación del proyecto.

### 2.1 Entidades implementadas

| N.º | Tabla | Descripción |
|---|---|---|
| 1 | Area | Almacena las áreas de trabajo del negocio. |
| 2 | Producto | Registra los productos ofrecidos por la cafetería. |
| 3 | Ingrediente | Almacena los ingredientes y sus unidades base. |
| 4 | Usuario | Registra los trabajadores y sus áreas y roles. |
| 5 | Configuracion_Producto | Define los ingredientes y cantidades de las recetas. |
| 6 | Venta | Registra las ventas realizadas. |
| 7 | Detalle_Venta | Almacena los productos y cantidades de cada venta. |
| 8 | Detalle_Venta_Ingrediente | Registra los ingredientes utilizados en las ventas. |
| 9 | Item_Inventario | Gestiona el stock de productos e ingredientes. |
| 10 | Movimiento_Inventario | Registra entradas, salidas, mermas y ajustes. |
| 11 | Proveedor | Almacena la información de los proveedores. |
| 12 | Compra | Registra las compras realizadas a proveedores. |
| 13 | Detalle_Compra | Detalla los artículos y cantidades adquiridas. |
| 14 | Alerta_Reposicion | Registra las alertas de reposición de inventario. |

### 2.2 Claves y restricciones

Para mantener la integridad de la información se implementaron las siguientes características:

- **PRIMARY KEY:** identifica de manera única cada registro de las tablas.
- **FOREIGN KEY:** establece las relaciones entre las entidades y asegura la integridad referencial.
- **AUTO_INCREMENT:** permite generar automáticamente los identificadores.
- **NOT NULL:** establece que determinados atributos deben contener información.
- **UNIQUE:** evita la duplicación de valores en atributos como correos electrónicos y nombres de áreas.
- **CHECK:** establece condiciones para validar los datos ingresados.

También se definieron acciones `ON UPDATE` y `ON DELETE` para controlar las modificaciones y eliminaciones de registros relacionados.

Un caso particular es la tabla `Item_Inventario`, que permite administrar tanto productos como ingredientes mediante dos claves foráneas opcionales. Se incorporó una restricción `CHECK` para asegurar que cada registro corresponda exclusivamente a uno de estos dos tipos de artículos.

### 2.3 Ejecución del esquema

El script se ejecutó en MySQL Workbench y se verificó la creación de las 14 tablas mediante la instrucción `SHOW TABLES`.

La base de datos quedó disponible bajo el nombre `inventafood`.


## 3. Carga de datos (seed.sql)

Una vez creada la estructura, se ejecutó `seed.sql`, encargado de incorporar datos sintéticos coherentes con el funcionamiento de Mass Cafe SPA.

Los registros permiten representar situaciones habituales del negocio, como ventas, compras a proveedores, consumo de ingredientes, movimientos de inventario y generación de alertas de reposición.

### 3.1 Registros incorporados

La carga de datos considera los siguientes registros:

| Tabla | Registros |
|---|---:|
| Area | 3 |
| Producto | 8 |
| Ingrediente | 16 |
| Usuario | 5 |
| Configuracion_Producto | 25 |
| Venta | 5 |
| Detalle_Venta | 8 |
| Detalle_Venta_Ingrediente | 29 |
| Item_Inventario | 17 |
| Movimiento_Inventario | 45 |
| Proveedor | 3 |
| Compra | 3 |
| Detalle_Compra | 12 |
| Alerta_Reposicion | 3 |
| **Total** | **182** |

Los datos incluyen información de trabajadores, productos de cafetería, ingredientes utilizados en las preparaciones, cantidades disponibles en inventario y registros históricos de operaciones.

Además, se incorporaron movimientos de entrada, salida y merma, permitiendo representar distintos escenarios de administración del inventario.

La ejecución del archivo fue verificada mediante consultas de conteo de registros para cada tabla.

## 4. Consultas de negocio (consultas.sql)

Se desarrolló un conjunto de seis consultas SQL para obtener información relevante para la administración de InventaFood.

Estas consultas permiten identificar necesidades de reposición, analizar el consumo de ingredientes, revisar compras, controlar mermas, identificar los productos más vendidos y consultar el historial de movimientos del inventario.

### 4.1 Artículos que requieren reposición

**Objetivo:** identificar los productos e ingredientes cuyo stock actual se encuentra en el nivel mínimo o por debajo de este, determinando cuánto falta para alcanzar el stock mínimo establecido.

La consulta relaciona `Item_Inventario` con `Producto` e `Ingrediente`, utilizando `LEFT JOIN` para identificar el nombre del artículo correspondiente.

**Resultado obtenido:**

| Artículo | Stock actual | Stock mínimo | Cantidad faltante |
|---|---:|---:|---:|
| Café en grano | 1.306 g | 1.400 g | 94 g |
| Té chai | 38 g | 40 g | 2 g |

**Interpretación:** se identificaron dos ingredientes que requieren reposición. El café en grano presenta una diferencia de 94 gramos respecto de su stock mínimo, mientras que el té chai requiere 2 gramos adicionales.

Esta información permite priorizar las compras y evitar interrupciones en la preparación de productos.

### 4.2 Ingredientes de mayor consumo por ventas

**Objetivo:** identificar los ingredientes que presentan mayor utilización en las preparaciones vendidas.

La consulta relaciona `Detalle_Venta_Ingrediente`, `Ingrediente`, `Detalle_Venta` y `Venta`. Utiliza `SUM()` para calcular las cantidades totales utilizadas y `COUNT(DISTINCT)` para identificar en cuántas ventas se utilizó cada ingrediente.

**Resultado obtenido:**

Entre los principales resultados se encuentran:

| Ingrediente | Cantidad utilizada | Ventas |
|---|---:|---:|
| Leche | 1.700 ml | 4 |
| Pollo | 160 g | 1 |
| Harina | 150 g | 1 |
| Agua | 150 ml | 1 |
| Café en grano | 144 g | 3 |

La consulta obtuvo 15 registros en total.

**Interpretación:** la leche presenta el mayor consumo registrado, con 1.700 ml utilizados en cuatro ventas. El café en grano también destaca por su utilización en tres ventas.

Esta información permite reconocer los ingredientes de mayor demanda y apoyar la planificación de inventario.

### 4.3 Compras realizadas por artículo

**Objetivo:** conocer qué artículos han sido adquiridos, cuántas compras se han realizado y cuáles son las cantidades totales compradas.

La consulta relaciona `Detalle_Compra`, `Compra` e `Item_Inventario`, incorporando las tablas `Producto` e `Ingrediente` para identificar cada artículo.

Se utilizan funciones de agregación como `COUNT(DISTINCT)` y `SUM()`.

**Resultado obtenido:**

| Artículo | Tipo | Cantidad comprada | Unidad |
|---|---|---:|---|
| Leche | Ingrediente | 2.000 | ml |
| Café en grano | Ingrediente | 500 | g |
| Harina | Ingrediente | 500 | g |
| Pollo | Ingrediente | 500 | g |
| Chocolate en polvo | Ingrediente | 200 | g |
| Cacao | Ingrediente | 200 | g |

La consulta obtuvo 12 registros, considerando también otros ingredientes y productos adquiridos.

**Interpretación:** los resultados permiten conocer las cantidades adquiridas para cada artículo y consultar su historial de compras. La leche presenta la mayor cantidad comprada, con 2.000 ml.

Esta información facilita el seguimiento de las adquisiciones y la planificación de futuras compras.

### 4.4 Mermas registradas por artículo

**Objetivo:** identificar los artículos que presentan pérdidas de inventario, junto con la cantidad, fecha, usuario responsable y motivo de la merma.

La consulta utiliza la tabla `Movimiento_Inventario`, relacionándola con `Item_Inventario`, `Producto`, `Ingrediente` y `Usuario`.

Se utiliza una condición `WHERE` para considerar exclusivamente los movimientos cuyo tipo corresponde a una merma.

**Resultado obtenido:**

| Artículo | Cantidad | Unidad | Motivo |
|---|---:|---|---|
| Café en grano | 50 | g | Café derramado y no recuperable |
| Leche | 100 | ml | Leche vencida |
| Chocolate en polvo | 30 | g | Producto derramado |
| Harina | 100 | g | Harina contaminada |

Se identificaron cuatro registros de mermas.

**Interpretación:** la consulta permite reconocer las pérdidas de inventario y sus causas. Esta información resulta útil para identificar problemas de manipulación, almacenamiento o vencimiento de ingredientes.

Además, permite identificar al trabajador responsable del registro de cada movimiento.

### 4.5 Ventas por producto

**Objetivo:** identificar los productos que presentan mayores cantidades vendidas y conocer en cuántas ventas fueron incluidos.

La consulta relaciona `Detalle_Venta`, `Producto` y `Venta`, utilizando `SUM()` para calcular las unidades vendidas y `COUNT(DISTINCT)` para contabilizar las ventas correspondientes.

**Resultado obtenido:**

| Producto | Unidades vendidas | Número de ventas |
|---|---:|---:|
| Café latte | 5 | 2 |
| Brownie | 3 | 1 |
| Capuccino | 2 | 1 |
| Sandwich de pollo | 2 | 1 |
| Café americano | 1 | 1 |
| Chocolate caliente | 1 | 1 |
| Té chai latte | 1 | 1 |

**Interpretación:** el café latte es el producto con mayor cantidad de unidades vendidas, alcanzando cinco unidades distribuidas en dos ventas.

Estos resultados permiten identificar los productos con mayor demanda y apoyar decisiones relacionadas con la planificación de la oferta y el abastecimiento de ingredientes.

### 4.6 Historial de movimientos de inventario

**Objetivo:** consultar los movimientos de inventario realizados durante un período determinado, identificando el artículo, tipo de movimiento, cantidad, fecha, usuario responsable y motivo.

La consulta relaciona `Movimiento_Inventario`, `Item_Inventario`, `Producto`, `Ingrediente` y `Usuario`.

Se utiliza una condición `WHERE` para establecer un período de consulta entre el 1 y el 30 de noviembre de 2026.

**Resultado obtenido:**

Se recuperaron 45 registros correspondientes a movimientos de inventario del período consultado.

Entre los movimientos identificados se encuentran:

- Entradas de inventario asociadas a compras y stock inicial.
- Salidas relacionadas con el consumo de ingredientes y productos.
- Mermas ocasionadas por pérdidas o deterioro de artículos.

**Interpretación:** esta consulta permite mantener trazabilidad sobre los movimientos de inventario, facilitando la identificación de cuándo se realizó una operación, qué artículo fue afectado y quién fue responsable de registrarla.

También permite revisar el historial de movimientos modificando las fechas establecidas en la condición `WHERE`.

## 5. Ejecución y validación de los archivos SQL

Los tres archivos fueron ejecutados en MySQL Workbench utilizando el motor MySQL 8.0.

El procedimiento de ejecución es el siguiente:

1. Ejecutar `schema.sql` para crear la base de datos y sus 14 tablas.
2. Ejecutar `seed.sql` para incorporar los registros de prueba.
3. Ejecutar `consultas_negocio.sql` para obtener los resultados de las seis consultas de negocio.

La validación se realizó mediante la revisión de los mensajes de ejecución de MySQL Workbench y los resultados obtenidos en cada consulta.

Se comprobó que las tablas fueron creadas correctamente, que los registros fueron incorporados y que las consultas devolvieron resultados coherentes con los datos almacenados.

## 6. Aporte de la implementación SQL al sistema de información

La implementación SQL permite transformar el modelo de datos del proyecto en una base de datos funcional para Mass Cafe SPA.

Su principal aporte consiste en centralizar la información de las operaciones del negocio y permitir obtener información útil para la toma de decisiones.

En particular, las consultas desarrolladas permiten:

- Identificar necesidades de reposición de inventario.
- Reconocer los ingredientes de mayor consumo.
- Consultar las cantidades adquiridas a proveedores.
- Identificar y controlar las mermas.
- Analizar las unidades vendidas por producto.
- Mantener trazabilidad de los movimientos de inventario.

De esta manera, la base de datos constituye el soporte de información necesario para la gestión de los procesos de la cafetería y complementa el diseño del sistema de información desarrollado en el proyecto.

## 7. Archivos asociados

Los archivos SQL que respaldan esta implementación son:

| Archivo | Contenido |
|---|---|
| `schema.sql` | Creación de la base de datos, tablas, claves y restricciones. |
| `seed.sql` | Datos sintéticos para poblar las tablas. |
| `consultas.sql` | Seis consultas SQL orientadas a la gestión del negocio. |

Los tres archivos se encuentran disponibles en el repositorio GitHub del proyecto y permiten reproducir la implementación y los resultados presentados en esta documentación.

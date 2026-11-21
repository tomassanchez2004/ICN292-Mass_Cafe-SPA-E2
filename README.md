# InventaFood · Mass Café SPA (La Cantina del Café)

Sistema de información para la gestión de inventario de **Mass Café SPA**, una cafetería de especialidad de Providencia. Proyecto de **ICN292 Sistemas de Información para la Gestión**, Universidad Técnica Federico Santa María, Segundo Semestre 2026, **Entrega 2**.

- **Paralelo:** 100 · **Profesor:** Patricio Cifuentes
- **Equipo:** Joaquín Lobos · Adán Piña · Javiera Pino · Tomás Sánchez
- **Versión defendida:** tag `v1.0-e2`

## El problema y la solución

La cafetería registra sus ventas en Fudo, pero lleva el inventario en planillas de papel. Como Fudo no sabe qué ingredientes se gastan en cada venta, nadie sabe con certeza cuánto stock queda: la dueña dedica cerca de 4 horas cada viernes a contar el inventario, hay compras de urgencia fuera de los días habituales (martes y viernes) y las mermas no se registran.

**InventaFood** conecta lo que se vende con lo que se gasta:

1. Guarda las recetas y, al registrar una venta, descuenta automáticamente los ingredientes del inventario (`registrar_venta`).
2. Registra cada entrada, salida, merma y ajuste, con quién lo hizo y por qué.
3. Avisa a la dueña por Telegram cuando un artículo llega a su stock mínimo (n8n, Flujo 1).
4. Le envía la lista de compras de martes y viernes, agrupada por proveedor (n8n, Flujo 2).

## Estructura del repositorio

```
README.md                      ← esta guía
CHANGELOG.md                   ← cambios relevantes desde la Entrega 1
DECLARACION_IA.md              ← declaración de uso de inteligencia artificial
docs/
  00-caso-pyme.md              ← caso, contexto y problema
  01-requerimientos.md         ← requerimientos (RF/RNF) y priorización MoSCoW
  02-bpmn.md                   ← proceso to-be y cambios respecto de la E1 (+ .bpm y .png)
  03-modelo-datos.md           ← modelo E/R en 3FN y diccionario de datos (+ .drawio y .png)
  04-sql-consultas.md          ← implementación SQL, resultados e interpretación
  05-automatizacion-n8n.md     ← flujos n8n, trazabilidad con el BPMN y pruebas
  schema.sql                   ← crea la base y sus 14 tablas
  seed.sql                     ← carga 182 registros de prueba
  consultas.sql                ← 6 consultas de negocio
  registrar_venta.sql          ← procedimiento de venta con descuento automático (RF03)
  flujo1_alerta_reposicion.json← flujo n8n: alerta de reposición (RF06)
  flujo2_lista_compras.json    ← flujo n8n: lista de compras (RF07)
evidencias/                    ← capturas de MySQL Workbench, n8n y Telegram
informe/                       ← informe final (PDF y Word)
presentacion/                  ← diapositivas de la defensa oral
```

## Cómo reproducir el proyecto

### Requisitos

- **MySQL 8.0 o superior** (la consulta del flujo 2 usa `WITH` y `ROW_NUMBER()`, y `registrar_venta.sql` usa procedimientos almacenados).
- **MySQL Workbench 8.0** (recomendado) o la consola `mysql`.

### Paso 1: clonar el repositorio

```bash
git clone https://github.com/tomassanchez2004/ICN292-Mass_Cafe-SPA-E2.git
cd ICN292-Mass_Cafe-SPA-E2
git checkout v1.0-e2
```

### Paso 2: crear y cargar la base

`schema.sql` crea la base `inventafood`. Si ya existe una base con ese nombre, primero ejecutar:

```sql
DROP DATABASE IF EXISTS inventafood;
```

Luego ejecutar los archivos en este orden:

| Orden | Archivo | Resultado esperado |
|---|---|---|
| 1 | `docs/schema.sql` | Crea la base `inventafood` y muestra sus 14 tablas |
| 2 | `docs/seed.sql` | Carga los datos y muestra el conteo por tabla (182 registros en total) |
| 3 | `docs/consultas.sql` | Ejecuta las 6 consultas de negocio |
| 4 | `docs/registrar_venta.sql` | Crea el procedimiento `registrar_venta` y ejecuta una venta de prueba. Va al final porque **modifica el stock** |

**En MySQL Workbench:** File → Open SQL Script → elegir el archivo → ejecutar completo y repetir con cada archivo en el orden indicado.

**Desde la consola:**

```bash
mysql -u root -p < docs/schema.sql
mysql -u root -p < docs/seed.sql
mysql -u root -p < docs/consultas.sql
mysql -u root -p < docs/registrar_venta.sql
```

### Paso 3: verificar los resultados

Con la base recién cargada, se obtiene lo siguiente:

| Consulta | Resultado esperado |
|---|---|
| 1. Artículos en o bajo el stock mínimo | 2 filas: café en grano (1.306 / 1.400 g) y té chai (38 / 40 g) |
| 2. Consumo de ingredientes por ventas | 15 filas; la leche encabeza con 1.700 ml en 4 ventas |
| 3. Compras por artículo | 12 filas |
| 4. Mermas registradas | 4 filas |
| 5. Productos más vendidos | 7 filas; café latte, con 5 unidades, es el primero |
| 6. Movimientos de noviembre 2026 | 45 filas (27 entradas, 14 salidas y 4 mermas) |

Y al final de `registrar_venta.sql` (2 cafés latte y 1 agua mineral vendidos por barra):

| Artículo | Stock antes | Stock después |
|---|---|---|
| Café en grano | 1.306 g | 1.270 g |
| Leche | 5.200 ml | 4.800 ml |
| Vaso desechable | 90 | 88 |
| Tapa de vaso | 93 | 91 |
| Agua mineral botella | 24 | 23 |

Pruebas de rechazo (comentadas al final del script; se ejecutan de a una y no modifican datos):

```sql
CALL registrar_venta(4, 1, 1);     -- usuario de cocina: se rechaza
CALL registrar_venta(2, 1, 1000);  -- stock insuficiente: se rechaza
```

### Paso 4 (opcional): automatización con n8n

Los flujos están en `docs/flujo1_alerta_reposicion.json` y `docs/flujo2_lista_compras.json`. Para ejecutarlos:

1. En n8n: **New workflow → ⋯ → Import from File** y elegir cada `.json`.
2. Crear una credencial **MySQL** con los datos de la base (host, puerto, base `inventafood`, usuario y clave) y asignarla en los nodos de MySQL.
3. Crear un bot con **@BotFather** en Telegram, crear la credencial **Telegram API** con su token y asignarla en los nodos de Telegram.
4. Reemplazar `REEMPLAZAR_CHAT_ID_DE_LA_DUENA` por el chat id del destinatario.
5. Para probar el Flujo 1 con un caso nuevo, dejar un artículo bajo su mínimo:
   ```sql
   UPDATE inventafood.Item_Inventario SET stock_actual = 15.000 WHERE id_item_inventario = 10;
   ```
6. Ejecutar cada flujo con **Execute workflow**.

Las credenciales no se suben al repositorio. Nosotros probamos los flujos en n8n Cloud, con una copia de la base en TiDB Cloud (compatible con MySQL), porque un servicio en la nube no puede conectarse a un MySQL local. El detalle de la configuración y los resultados de las pruebas están en `docs/05-automatizacion-n8n.md`, y las capturas en `evidencias/`.

## Requerimientos y dónde se cumplen

| Requerimiento | Evidencia | Estado |
|---|---|---|
| RF01 Registrar productos e ingredientes | `Producto`, `Ingrediente`, `Item_Inventario` | Cumplido |
| RF02 Registrar ingresos | `Compra`, `Detalle_Compra`, movimientos de entrada · consulta 3 | Cumplido |
| RF03 Salidas por venta y actualización del stock | `registrar_venta.sql` · consultas 2 y 5 | Cumplido |
| RF04 Consultar stock con unidad | Consulta 1 | Cumplido |
| RF05 Definir stock mínimo | `Item_Inventario.stock_minimo` | Cumplido |
| RF06 Alerta automática de reposición | Flujo 1 de n8n + `Alerta_Reposicion` | Cumplido |
| RF07 Lista de reposición | Flujo 2 de n8n | Cumplido |
| RF08 Registrar mermas | Movimientos de tipo merma · consulta 4 | Cumplido |
| RF09 Dueña consulta y modifica todo | Rol `duena` en `Usuario` (sin aplicación) | Parcial |
| RF10 Trabajadores ven solo su área | El inventario aún no está asociado a un área | Parcial |
| RF11 Historial por período | Consulta 6 | Cumplido |

## Limitaciones principales

- No hay una interfaz para los trabajadores: las ventas se registran llamando a `registrar_venta` desde MySQL. La mejora propuesta es registrarlas desde el celular con el bot de Telegram vía n8n.
- El inventario no está asociado a un área (RF10) y no hay integración con Fudo.
- La copia de la base usada en n8n (TiDB Cloud) guarda la hora en UTC, no valida los `CHECK` y no admite procedimientos; por eso `registrar_venta` se ejecuta en MySQL.

El detalle está en el informe (`informe/`, sección 8) y en `docs/04-sql-consultas.md` y `docs/05-automatizacion-n8n.md`.

## Equipo

| Integrante | Parte que subió y mantiene |
|---|---|
| Tomás Sánchez | Base del repositorio, BPMN to-be y modelo E/R (`docs/00` a `03`) |
| Joaquín Lobos | SQL (`schema.sql`, `seed.sql`, `consultas.sql`) |
| Adán Piña | Automatización con n8n |
| Javiera Pino | Informe final |

El trabajo se hizo en conjunto; cada integrante quedó a cargo de subir y mantener una parte del repositorio.

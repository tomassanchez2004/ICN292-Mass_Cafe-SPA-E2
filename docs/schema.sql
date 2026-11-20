CREATE DATABASE inventafood;
USE inventafood;


CREATE TABLE Area (
    id_area INT AUTO_INCREMENT,
    nombre_area VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_area),
    UNIQUE (nombre_area)
);


CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_producto),
    CHECK (precio >= 0)
);


CREATE TABLE Ingrediente (
    id_ingrediente INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    unidad_base VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_ingrediente),
    UNIQUE (nombre)
);


CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    id_area INT NOT NULL,
    rol VARCHAR(30) NOT NULL,
    PRIMARY KEY (id_usuario),
    UNIQUE (correo),
    FOREIGN KEY (id_area) REFERENCES Area(id_area)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Configuracion_Producto (
    id_configuracion INT AUTO_INCREMENT,
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    grupo_opcion VARCHAR(50) NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    unidad_receta VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_configuracion),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CHECK (cantidad > 0)
);


CREATE TABLE Venta (
    id_venta INT AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    id_usuario INT NOT NULL,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Detalle_Venta (
    id_detalle_venta INT AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id_detalle_venta),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (cantidad > 0)
);


CREATE TABLE Detalle_Venta_Ingrediente (
    id_detalle_venta_ingrediente INT AUTO_INCREMENT,
    id_detalle_venta INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_utilizada DECIMAL(10,3) NOT NULL,
    unidad_consumo VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_detalle_venta_ingrediente),
    FOREIGN KEY (id_detalle_venta) REFERENCES Detalle_Venta(id_detalle_venta)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (cantidad_utilizada > 0)
);


CREATE TABLE Item_Inventario (
    id_item_inventario INT AUTO_INCREMENT,
    tipo_item VARCHAR(20) NOT NULL,
    id_producto INT NULL,
    id_ingrediente INT NULL,
    stock_actual DECIMAL(10,3) NOT NULL,
    stock_minimo DECIMAL(10,3) NOT NULL,
    PRIMARY KEY (id_item_inventario),
    UNIQUE (id_producto),
    UNIQUE (id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    CHECK (stock_actual >= 0),
    CHECK (stock_minimo >= 0),
    CHECK (
        (tipo_item = 'producto' AND id_producto IS NOT NULL AND id_ingrediente IS NULL)
        OR
        (tipo_item = 'ingrediente' AND id_ingrediente IS NOT NULL AND id_producto IS NULL)
    )
);


CREATE TABLE Movimiento_Inventario (
    id_movimiento INT AUTO_INCREMENT,
    id_item_inventario INT NOT NULL,
    tipo_movimiento VARCHAR(30) NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    id_usuario INT NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_movimiento),
    FOREIGN KEY (id_item_inventario) REFERENCES Item_Inventario(id_item_inventario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (cantidad > 0),
    CHECK (tipo_movimiento IN ('entrada', 'salida', 'merma', 'ajuste'))
);


CREATE TABLE Proveedor (
    id_proveedor INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono_proveedor VARCHAR(20) NULL,
    correo_proveedor VARCHAR(150) NULL,
    PRIMARY KEY (id_proveedor)
);


CREATE TABLE Compra (
    id_compra INT AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    id_proveedor INT NOT NULL,
    id_usuario INT NOT NULL,
    PRIMARY KEY (id_compra),
    FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE Detalle_Compra (
    id_detalle_compra INT AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_item_inventario INT NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL,
    unidad_compra VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_detalle_compra),
    FOREIGN KEY (id_compra) REFERENCES Compra(id_compra)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (id_item_inventario) REFERENCES Item_Inventario(id_item_inventario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (cantidad > 0)
);


CREATE TABLE Alerta_Reposicion (
    id_alerta INT AUTO_INCREMENT,
    id_item_inventario INT NOT NULL,
    fecha_generacion DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    fecha_atencion DATETIME NULL,
    PRIMARY KEY (id_alerta),
    FOREIGN KEY (id_item_inventario) REFERENCES Item_Inventario(id_item_inventario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CHECK (estado IN ('pendiente', 'atendida', 'cancelada'))
);


SHOW TABLES;

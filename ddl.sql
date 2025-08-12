-- *************** Estructura base de datos "Finca" ***************

CREATE DATABASE finca;

USE finca;

-- *****Gestion Empleado*****

CREATE TABLE IF NOT EXISTS rol (
	id INT PRIMARY KEY AUTO_INCREMENT,
	rol VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS empleado (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    rol INT,
    FOREIGN KEY (rol) REFERENCES rol (id)
);

-- *****Gestion Proveedor*****

CREATE TABLE IF NOT EXISTS proveedor (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    nit VARCHAR(20) UNIQUE NOT NULL,
    descripcion TEXT
);

-- *****Gestion Cliente*****

CREATE TABLE IF NOT EXISTS cliente (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    nit VARCHAR(20) UNIQUE NOT NULL,
    descripcion TEXT
);

-- *****Gestion Maquinaria*****

CREATE TABLE IF NOT EXISTS maquinaria (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    anio_compra INTEGER,
    modelo VARCHAR(50),
    seguro_soat DATE,
    tecnomecanica DATE,
    descripcion TEXT,
    activa BOOLEAN NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS servicio (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    servicio VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS uso_maquinaria (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha_uso DATE NOT NULL,
    observaciones TEXT,
    tipo_servicio INTEGER NOT NULL,
    id_maquinaria INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    FOREIGN KEY (tipo_servicio) REFERENCES servicio(id),
    FOREIGN KEY (id_maquinaria) REFERENCES maquinaria(id),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)
);

CREATE TABLE IF NOT EXISTS mantenimiento (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha_mantenimiento DATE NOT NULL,
    observaciones TEXT,
    costo DECIMAL(10,2) NOT NULL,
    acto_funcionamiento BOOLEAN NOT NULL,
    id_maquina INTEGER NOT NULL,
    FOREIGN KEY (id_maquina) REFERENCES maquinaria(id)
);

CREATE TABLE IF NOT EXISTS pago_mantenimiento (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha_pago DATE NOT NULL,
    tipo_pago VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    id_mantenimiento INTEGER NOT NULL,
    FOREIGN KEY (id_mantenimiento) REFERENCES mantenimiento(id)
);

-- *****Gestion Inventario*****

CREATE TABLE IF NOT EXISTS producto (
    codigo INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS entrada (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    cantidad INTEGER NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    id_producto INTEGER NOT NULL,
    id_proveedor INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES producto(codigo),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)
);

-- *****Gestion Venta*****

CREATE TABLE IF NOT EXISTS venta (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    total_venta DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    id_empleado INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS detalle_venta (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    cantidad_venta INTEGER NOT NULL,
    id_venta INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES venta(id),
    FOREIGN KEY (id_producto) REFERENCES producto(codigo)
);

CREATE TABLE IF NOT EXISTS tipo_pago (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre_pago VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS detalle_venta_pago (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    fecha_pago DATE NOT NULL,
    id_venta INTEGER NOT NULL,
    id_tipo_pago INTEGER NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES venta(id),
    FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pago(id)
);


/* ============================
   TABLAS COMPLEMENTARIAS PARA PRODUCCIÓN AGRÍCOLA
   ============================ */

/* 1. Catálogo de cultivos */
CREATE TABLE IF NOT EXISTS cultivo (
    id_cultivo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cultivo VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,  -- Ej: kg, litros
    precio_referencia DECIMAL(10,2) DEFAULT 0
);

/* 2. Lotes o parcelas de terreno */
CREATE TABLE IF NOT EXISTS lote (
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    nombre_lote VARCHAR(100) NOT NULL,
    hectareas DECIMAL(5,2) NOT NULL,
    ubicacion VARCHAR(200)
);

/* 3. Registro de siembras */
CREATE TABLE IF NOT EXISTS siembra (
    id_siembra INT PRIMARY KEY AUTO_INCREMENT,
    id_lote INT NOT NULL,
    id_cultivo INT NOT NULL,
    fecha_siembra DATE NOT NULL,
    cantidad_sembrada DECIMAL(10,2) NOT NULL,
    id_responsable INT NOT NULL,
    FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
    FOREIGN KEY (id_cultivo) REFERENCES cultivo(id_cultivo),
    FOREIGN KEY (id_responsable) REFERENCES empleado(id)
);

/* 4. Registro de cosechas */
CREATE TABLE IF NOT EXISTS cosecha (
    id_cosecha INT PRIMARY KEY AUTO_INCREMENT,
    id_siembra INT NOT NULL,
    fecha_cosecha DATE NOT NULL,
    cantidad_cosechada DECIMAL(10,2) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    calidad VARCHAR(50),  -- Ej: Alta, Media, Baja
    FOREIGN KEY (id_siembra) REFERENCES siembra(id_siembra)
);

/* 5. Insumos agrícolas */
CREATE TABLE IF NOT EXISTS insumo (
    id_insumo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL, -- fertilizante, pesticida, alimento animal, etc.
    stock INT NOT NULL DEFAULT 0,
    precio_unitario DECIMAL(10,2) NOT NULL
);

/* 6. Uso de insumos */
CREATE TABLE IF NOT EXISTS uso_insumo (
    id_uso INT PRIMARY KEY AUTO_INCREMENT,
    id_insumo INT NOT NULL,
    id_siembra INT NOT NULL,
    cantidad_usada DECIMAL(10,2) NOT NULL,
    fecha_uso DATE NOT NULL,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_insumo) REFERENCES insumo(id_insumo),
    FOREIGN KEY (id_siembra) REFERENCES siembra(id_siembra),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)
);

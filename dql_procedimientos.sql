USE finca;

-- 1. Listar productos por proveedor
DROP PROCEDURE IF EXISTS listar_proveedor;
DELIMITER $$
CREATE PROCEDURE listar_proveedor(IN nombre_proveedor VARCHAR(100))
BEGIN
    SELECT p.codigo AS codigo_producto,
           p.nombre AS nombre_producto,
           pr.nombre AS nombre_proveedor
    FROM entrada e
    JOIN producto p ON e.id_producto = p.codigo
    JOIN proveedor pr ON e.id_proveedor = pr.id
    WHERE pr.nombre = nombre_proveedor
    LIMIT 10;
END$$
DELIMITER ;

-- 2. Actualizar cantidad de producto
DROP PROCEDURE IF EXISTS actualizar_cantidad_producto;
DELIMITER $$
CREATE PROCEDURE actualizar_cantidad_producto(IN i_codigo INT, IN i_stock INT)
BEGIN
    IF i_stock <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El número de stock debe ser mayor a 0';
    ELSE
        UPDATE producto
        SET stock = i_stock
        WHERE codigo = i_codigo;
    END IF;
END$$
DELIMITER ;

-- 3. Obtener historial de ventas de un empleado
DROP PROCEDURE IF EXISTS historial_cliente;
DELIMITER $$
CREATE PROCEDURE historial_cliente(IN i_id_empleado INT)
BEGIN
    SELECT e.id AS id_empleado,
           e.nombre AS nombre_empleado,
           v.total_venta,
           v.fecha_venta
    FROM empleado e
    JOIN venta v ON v.id_empleado = e.id
    WHERE e.id = i_id_empleado;
END$$
DELIMITER ;

-- 4. Registrar una venta
DROP PROCEDURE IF EXISTS registrar_venta;
DELIMITER $$
CREATE PROCEDURE registrar_venta(
    IN p_total_venta DECIMAL(10,2),
    IN p_id_empleado INT,
    IN p_id_cliente INT
)
BEGIN
    IF p_total_venta <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El valor de la venta debe ser mayor a 0';
    ELSE
        INSERT INTO venta (total_venta, fecha_venta, id_empleado, id_cliente)
        VALUES (p_total_venta, CURDATE(), p_id_empleado, p_id_cliente);
        SELECT LAST_INSERT_ID() AS id_venta;
    END IF;
END$$
DELIMITER ;

-- 5. Buscar clientes por nombre
DROP PROCEDURE IF EXISTS buscar_cliente_nombre;
DELIMITER $$
CREATE PROCEDURE buscar_cliente_nombre(IN i_nombre VARCHAR(100))
BEGIN
    SELECT c.id, c.nombre, c.telefono
    FROM cliente c
    WHERE c.nombre LIKE CONCAT('%', i_nombre, '%');
END$$
DELIMITER ;

-- 6. Registrar un mantenimiento de maquinaria
DROP PROCEDURE IF EXISTS registrar_mantenimiento;
DELIMITER $$
CREATE PROCEDURE registrar_mantenimiento(
    IN i_fecha_mantenimiento DATE,
    IN i_observaciones TEXT,
    IN i_costo DECIMAL(10,2),
    IN i_acto_funcionamiento BOOLEAN,
    IN i_id_maquina INT
)
BEGIN
    IF i_costo < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El costo no puede ser negativo';
    ELSE
        INSERT INTO mantenimiento (fecha_mantenimiento, observaciones, costo, acto_funcionamiento, id_maquina)
        VALUES (i_fecha_mantenimiento, i_observaciones, i_costo, i_acto_funcionamiento, i_id_maquina);
    END IF;
END$$
DELIMITER ;

-- 7. Listar pagos por tipo
DROP PROCEDURE IF EXISTS listar_pago_tipo;
DELIMITER $$
CREATE PROCEDURE listar_pago_tipo(IN i_nombre_pago VARCHAR(50))
BEGIN
    SELECT *
    FROM tipo_pago tp
    WHERE tp.nombre_pago = i_nombre_pago;
END$$
DELIMITER ;

-- 8. Registrar un nuevo cliente
DROP PROCEDURE IF EXISTS registrar_cliente_nuevo;
DELIMITER $$
CREATE PROCEDURE registrar_cliente_nuevo(
    IN i_nombre VARCHAR(100),
    IN i_telefono VARCHAR(20),
    IN i_correo VARCHAR(100),
    IN i_nit VARCHAR(20),
    IN i_descripcion TEXT
)
BEGIN
    DECLARE nit_existente INT;
    SELECT COUNT(*) INTO nit_existente
    FROM cliente
    WHERE nit = i_nit;
    
    IF nit_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El cliente ya existe';
    ELSE
        INSERT INTO cliente (nombre, telefono, correo, nit, descripcion)
        VALUES (i_nombre, i_telefono, i_correo, i_nit, i_descripcion);
    END IF;
END$$
DELIMITER ;

-- 9. Buscar cliente por NIT
DROP PROCEDURE IF EXISTS buscar_nit_cliente;
DELIMITER $$
CREATE PROCEDURE buscar_nit_cliente(IN i_nit VARCHAR(20))
BEGIN
    SELECT c.*
    FROM cliente c
    WHERE c.nit = i_nit;
END$$
DELIMITER ;

-- 10. Registrar un nuevo proveedor
DROP PROCEDURE IF EXISTS registrar_proveedor;
DELIMITER $$
CREATE PROCEDURE registrar_proveedor(
    IN i_nombre VARCHAR(100),
    IN i_telefono VARCHAR(20),
    IN i_correo VARCHAR(100),
    IN i_nit VARCHAR(20),
    IN i_descripcion TEXT
)
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM proveedor
    WHERE nit = i_nit;

    IF existe > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El proveedor ya existe';
    ELSE
        INSERT INTO proveedor (nombre, telefono, correo, nit, descripcion)
        VALUES (i_nombre, i_telefono, i_correo, i_nit, i_descripcion);
    END IF;
END$$
DELIMITER ;

-- 11. Buscar proveedor por nombre o nit
DROP PROCEDURE IF EXISTS buscar_proveedor;
DELIMITER $$
CREATE PROCEDURE buscar_proveedor(
    IN i_nombre VARCHAR(100),
    IN i_nit VARCHAR(20)
)
BEGIN
    SELECT p.*
    FROM proveedor p
    WHERE (i_nombre IS NOT NULL AND p.nombre = i_nombre)
       OR (i_nit IS NOT NULL AND p.nit = i_nit);
END$$
DELIMITER ;

-- 12. Consultar historial de uso de maquinaria
DROP PROCEDURE IF EXISTS historial_uso_maquinaria;
DELIMITER $$
CREATE PROCEDURE historial_uso_maquinaria(IN i_id_uso_maquinaria INT)
BEGIN
    SELECT um.id,
           um.fecha_uso,
           s.servicio AS servicio_realizado
    FROM uso_maquinaria um
    JOIN servicio s ON s.id = um.tipo_servicio
    WHERE um.id = i_id_uso_maquinaria;
END$$
DELIMITER ;

-- 13. Producto más vendido
DROP PROCEDURE IF EXISTS producto_mas_vendido;
DELIMITER $$
CREATE PROCEDURE producto_mas_vendido()
BEGIN
    SELECT p.codigo AS codigo_producto,
           p.nombre AS nombre_producto,
           SUM(dv.cantidad_venta) AS total_vendido
    FROM detalle_venta dv
    JOIN producto p ON p.codigo = dv.id_producto
    GROUP BY p.codigo, p.nombre
    ORDER BY total_vendido DESC
    LIMIT 1;
END$$
DELIMITER ;

-- 14. Actualizar precio de producto
DROP PROCEDURE IF EXISTS actualizar_precio_producto;
DELIMITER $$
CREATE PROCEDURE actualizar_precio_producto(IN i_codigo INT, IN i_precio_venta DECIMAL(10,2))
BEGIN
    IF i_precio_venta <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El precio debe ser mayor a 0';
    ELSE
        UPDATE producto
        SET precio_venta = i_precio_venta
        WHERE codigo = i_codigo;
    END IF;
END$$
DELIMITER ;

-- 15. Consultar maquinaria usada en una fecha específica
DROP PROCEDURE IF EXISTS consultar_maquina_fecha;
DELIMITER $$
CREATE PROCEDURE consultar_maquina_fecha(IN i_fecha_uso DATE)
BEGIN
    SELECT um.id_maquinaria,
           um.fecha_uso,
           um.observaciones
    FROM uso_maquinaria um
    WHERE um.fecha_uso = i_fecha_uso;
END$$
DELIMITER ;

-- 16. Buscar cliente por nombre
DROP PROCEDURE IF EXISTS buscar_cliente;
DELIMITER $$
CREATE PROCEDURE buscar_cliente(IN i_nombre VARCHAR(100))
BEGIN
    SELECT c.*
    FROM cliente c
    WHERE c.nombre LIKE CONCAT('%', i_nombre, '%');
END$$
DELIMITER ;

-- 17. Calcular total de ventas por empleado
DROP PROCEDURE IF EXISTS calcular_ventas_empleado;
DELIMITER $$
CREATE PROCEDURE calcular_ventas_empleado(IN i_id_empleado INT)
BEGIN
    SELECT e.id AS id_empleado,
           e.nombre AS nombre_empleado,
           SUM(v.total_venta) AS total_ventas
    FROM empleado e
    JOIN venta v ON v.id_empleado = e.id
    WHERE e.id = i_id_empleado
    GROUP BY e.id, e.nombre;
END$$
DELIMITER ;

-- 18. Listar pagos de mantenimiento de una maquinaria específica
DROP PROCEDURE IF EXISTS listar_pagos_mantenimiento;
DELIMITER $$
CREATE PROCEDURE listar_pagos_mantenimiento(IN i_id_maquinaria INT)
BEGIN
    SELECT pm.id AS id_pago,
           pm.fecha_pago,
           pm.valor
    FROM pago_mantenimiento pm
    JOIN mantenimiento m ON m.id = pm.id_mantenimiento
    WHERE m.id_maquina = i_id_maquinaria;
END$$
DELIMITER ;

-- 19. Top 5 clientes con más compras
DROP PROCEDURE IF EXISTS top_clientes_compras;
DELIMITER $$
CREATE PROCEDURE top_clientes_compras()
BEGIN
    SELECT c.nombre AS nombre_cliente,
           SUM(v.total_venta) AS total_compras
    FROM cliente c
    JOIN venta v ON c.id = v.id_cliente
    GROUP BY c.id, c.nombre
    ORDER BY total_compras DESC
    LIMIT 5;
END$$
DELIMITER ;
-- *************** Procedimientos almacenados "Finca" ***************

use finca;

-- 1. Listar productos por proveedor

drop procedure listar_proveedor;

DELIMITER $$
CREATE PROCEDURE listar_proveedor(IN nombre_proveedor VARCHAR(100))
BEGIN
	SELECT p.codigo "codigo Producto", p.nombre "producto nombre", pr.nombre "nombre proveedor"
	FROM producto p
	JOIN proveedor pr ON pr.id = p.codigo
	WHERE nombre_proveedor = pr.nombre
	LIMIT 10;
END$$
DELIMITER ;

call listar_proveedor("AgroFert S.A.S.");

-- 2. Actualizar cantidad de producto

drop procedure actualizar_cantidad_producto;

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

call actualizar_cantidad_producto(1, 500);
select * from producto;

-- 3. Obtener historial de ventas de un empleado

drop procedure historial_cliente;

DELIMITER $$
CREATE PROCEDURE historial_cliente(IN i_id_empleado INT)
BEGIN
	SELECT e.id "id empleado", e.nombre "nombre empleado", v.total_venta "total de ventas" 
	FROM empleado e
	JOIN venta v ON v.id = e.id
	WHERE i_id_empleado = e.id;
END$$
DELIMITER ;

call historial_cliente(1);

-- 4. Registrar una venta

drop procedure registrar_venta;

DELIMITER $$
CREATE PROCEDURE registrar_venta(
    IN p_total_venta DECIMAL(10,2),
    IN p_id_empleado INT,
    IN p_id_cliente INT
)
BEGIN
    INSERT INTO venta (total_venta, fecha_venta, id_empleado, id_cliente)
    VALUES (p_total_venta, NOW(), p_id_empleado, p_id_cliente);

    SELECT LAST_INSERT_ID() AS id_venta;
END$$
DELIMITER ;

call registrar_venta(150000, 1, 3);

-- 5. Buscar clientes por nombre

drop procedure buscar_cliente_nombre;

DELIMITER $$
CREATE PROCEDURE buscar_cliente_nombre(IN i_nombre VARCHAR(100))
BEGIN
	SELECT c.id, c.nombre, c.telefono
	FROM cliente c
	WHERE nombre like concat("%", i_nombre, "%");
END$$
DELIMITER ;

call buscar_cliente_nombre("perez")

-- 6. Registrar un mantenimiento de maquinaria

drop procedure registrar_mantenimiento;

DELIMITER $$
CREATE PROCEDURE registrar_mantenimiento(
	IN i_fecha_mantenimiento DATE,
	IN i_observaciones TEXT,
	IN i_costo DECIMAL(10,2),
	IN i_acto_funcionamiento BOOLEAN,
	IN i_id_maquina INT
)
BEGIN
	INSERT INTO mantenimiento (fecha_mantenimiento, observaciones, costo, acto_funcionamiento, id_maquina)
	VALUES (i_fecha_mantenimiento, i_observaciones, i_costo, i_acto_funcionamiento, i_id_maquina);
END$$
DELIMITER ;

call registrar_mantenimiento("2025-08-12", "Aceite", 600, 0, 1);

-- 7. Listar pagos por tipo

drop procedure listar_pago_tipo;

DELIMITER $$
CREATE PROCEDURE listar_pago_tipo(IN i_nombre_pago VARCHAR(50))
BEGIN
	SELECT *
	FROM tipo_pago tp
	WHERE nombre_pago = i_nombre_pago;
END$$
DELIMITER ;

call listar_pago_tipo("efectivo")

-- 8. Registrar un nuevo cliente

drop procedure registrar_cliente_nuevo;

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
		SIGNAL SQLSTATE "45001"
        	SET MESSAGE_TEXT = "El usuario ya existe en la base de datos";
	ELSE
		INSERT INTO cliente (nombre, telefono, correo, nit, descripcion)
		VALUES (i_nombre, i_telefono, i_correo, i_nit, i_descripcion);
	END IF;
END$$
DELIMITER ;

call registrar_cliente_nuevo("jesus olarte", 3187785439, "jesusolarte@gmail.com", 1111111111, "Estudiante jesus proyecto");

-- 10. Buscar cliente por nit

drop procedure buscar_nit_cliente;

DELIMITER $$
CREATE PROCEDURE buscar_nit_cliente(IN i_nit VARCHAR(20))
BEGIN
	SELECT c.nombre, c.telefono, c.correo, c.nit, c.descripcion
	FROM cliente c
	WHERE c.nit = i_nit;
END$$
DELIMITER ;

call buscar_nit_cliente(900001001);

-- 11. Registrar un nuevo proveedor

drop procedure registrar_proveedor;

DELIMITER $$
CREATE PROCEDURE registrar_proveedor(
	IN i_nombre VARCHAR(100),
	IN i_telefono VARCHAR(20),
	IN i_correo VARCHAR(100),
	IN i_nit VARCHAR(20),
	IN i_descripcion TEXT
)
BEGIN
	DECLARE nit_existente INT;
	
	SELECT COUNT(*) INTO nit_existente 
	FROM proveedor
	WHERE nit = i_nit;
	
	IF nit_existente > 0 THEN
		SIGNAL SQLSTATE "45001"
        	SET MESSAGE_TEXT = "El proveedor ya existe en la base de datos";
	ELSE
		INSERT INTO proveedor (nombre, telefono, correo, nit, descripcion)
		VALUES (i_nombre, i_telefono, i_correo, i_nit, i_descripcion);
	END IF;
END$$
DELIMITER ;

call registrar_proveedor("AgroJesus", 1111111111, "agrojesus@gmail.com", 1111111111, "industria agricola jesus");

-- 11 Buscar proveedor por nombre o NIT

drop procedure buscar_proveedor;

DELIMITER $$
CREATE PROCEDURE buscar_proveedor(
	IN i_nombre VARCHAR(100),
	IN i_nit VARCHAR(20)
) 
BEGIN
	SELECT p.nombre, p.telefono, p.correo, p.nit, p.descripcion 
	FROM proveedor p
	WHERE nombre = i_nombre OR nit = i_nit; 
END$$
DELIMITER ;

call buscar_proveedor("AgroJesus", null);
call buscar_proveedor(null, 1111111111);

-- 12 Consultar historial de uso de maquinaria

drop procedure historial_uso_maquinaria;

DELIMITER $$
CREATE PROCEDURE historial_uso_maquinaria(IN i_id_uso_maquinaria INT)
BEGIN
	SELECT um.id, um.fecha_uso "fecha de uso", s.servicio "servicio realizado"
	FROM uso_maquinaria um
	JOIN servicio s ON s.id = um.id
	WHERE i_id_uso_maquinaria = um.id;
END$$
DELIMITER ;

call historial_uso_maquinaria(6);

-- 13. Producto más vendido

drop procedure producto_mas_vendido;

DELIMITER $$
CREATE PROCEDURE producto_mas_vendido()
BEGIN
	SELECT p.codigo "codigo producto", p.nombre "nombre producto", MAX(dv.cantidad_venta) AS "cantidad mas vendida"
	FROM detalle_venta dv
	JOIN producto p ON p.codigo = dv.id;
END$$
DELIMITER ;

call producto_mas_vendido();
-- 14. Actualizar precio de producto

drop procedure actualizar_precio_producto;

DELIMITER $$
CREATE PROCEDURE actualizar_precio_producto(IN i_codigo INT, IN i_precio_venta DECIMAL(10,2))
BEGIN
	IF i_precio_venta <= 0 THEN
		SIGNAL SQLSTATE "45001"
			SET MESSAGE_TEXT = "No se le puede asignar un valor igual o menor a 0 a este producto";
	ELSE 
		UPDATE producto
		SET precio_venta = i_precio_venta
		WHERE codigo = i_codigo;
	END IF;
END$$
DELIMITER ;

call actualizar_precio_producto(1, 40000);

-- 15. Consultar maquinaria usada en una fecha específica

drop procedure consultar_maquina_fecha;

DELIMITER $$
CREATE PROCEDURE consultar_maquina_fecha(IN i_fecha_uso DATE)
BEGIN
	SELECT um.id "id maquina", um.fecha_uso "fecha de uso", um.observaciones "observaciones"
	FROM uso_maquinaria um
	WHERE fecha_uso = i_fecha_uso; 
END$$
DELIMITER ;

call consultar_maquina_fecha ("2025-01-01");

-- 17. Buscar cliente por nombre 

drop procedure buscar_cliente;

DELIMITER $$
CREATE PROCEDURE buscar_cliente (IN i_nombre VARCHAR(100))
BEGIN
	SELECT c.id "id cliente", c.nombre "nombre cliente", c.telefono "telefono cliente"
	FROM cliente c
	WHERE c.nombre LIKE CONCAT("%", i_nombre, "%");
END$$
DELIMITER ;

call buscar_cliente("jesus");

-- 18. Calcular total de ventas por empleado

drop procedure calcular_ventas_empleado;

DELIMITER $$
CREATE PROCEDURE calcular_ventas_empleado(IN i_id_empleado INT)
BEGIN
	SELECT e.id "id empleado", e.nombre "nombre empleado", sum(v.total_venta) "total de ventas", v.fecha_venta "fecha de venta"
	FROM empleado e
	JOIN venta v ON v.id_empleado = e.id
	WHERE e.id = i_id_empleado;
END$$
DELIMITER ;

call calcular_ventas_empleado(1);

-- 19. Listar pagos de mantenimiento de una maquinaria específica

drop procedure listar_pagos_mantenimiento;

DELIMITER $$
CREATE PROCEDURE listar_pagos_mantenimiento(IN i_id_maquinaria INT)
BEGIN
	SELECT pm.id "id del pago", pm.fecha_pago "fecha de pago", pm.valor "valor del pago"
	FROM pago_mantenimiento pm
	JOIN maquinaria m ON m.id = pm.id_mantenimiento 
	WHERE m.id = i_id_maquinaria;
END$$
DELIMITER ;

call listar_pagos_mantenimiento(1);

-- 20. Top 5 clientes con más compras

drop procedure top_clientes_compras;

DELIMITER $$
CREATE PROCEDURE top_clientes_compras()
BEGIN
	SELECT c.nombre "nombre cliente", v.total_venta
	FROM cliente c
	JOIN venta v ON c.id = v.id_cliente
	ORDER BY v.total_venta DESC
	LIMIT 5;
END$$
DELIMITER ;

call top_clientes_compras();
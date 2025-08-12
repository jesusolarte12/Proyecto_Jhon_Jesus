USE finca;


-- 1. Total ventas en un mes y año dados
DROP FUNCTION IF EXISTS total_ventas_mes;
DELIMITER $$
CREATE FUNCTION total_ventas_mes(anio INT, mes INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT IFNULL(SUM(total_venta), 0) 
      INTO total
    FROM venta
    WHERE YEAR(fecha_venta) = anio AND MONTH(fecha_venta) = mes;
    RETURN total;
END$$
DELIMITER ;

-- 2. Utilidad de un producto (precio_venta - precio promedio compra)
DROP FUNCTION IF EXISTS utilidad_producto;
DELIMITER $$
CREATE FUNCTION utilidad_producto(id_producto INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE utilidad DECIMAL(10,2);
    DECLARE precioCompra DECIMAL(10,2);
    DECLARE precioVenta DECIMAL(10,2);

    SELECT AVG(precio_compra) INTO precioCompra
    FROM entrada
    WHERE id_producto = id_producto;

    SELECT precio_venta INTO precioVenta
    FROM producto
    WHERE codigo = id_producto;

    SET utilidad = IFNULL(precioVenta - precioCompra, 0);
    RETURN utilidad;
END$$
DELIMITER ;

-- 3. Stock disponible de un producto
DROP FUNCTION IF EXISTS stock_disponible;
DELIMITER $$
CREATE FUNCTION stock_disponible(id_producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT stock INTO cantidad
    FROM producto
    WHERE codigo = id_producto;
    RETURN IFNULL(cantidad,0);
END$$
DELIMITER ;

-- 4. Promedio de ventas mensuales de un producto
DROP FUNCTION IF EXISTS promedio_ventas_producto;
DELIMITER $$
CREATE FUNCTION promedio_ventas_producto(id_producto INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(cant)
    INTO promedio
    FROM (
        SELECT SUM(dv.cantidad_venta) AS cant
        FROM detalle_venta dv
        JOIN venta v ON dv.id_venta = v.id
        WHERE dv.id_producto = id_producto
        GROUP BY YEAR(v.fecha_venta), MONTH(v.fecha_venta)
    ) t;
    RETURN IFNULL(promedio,0);
END$$
DELIMITER ;

-- 5. Costo total de mantenimiento
DROP FUNCTION IF EXISTS costo_total_mantenimiento;
DELIMITER $$
CREATE FUNCTION costo_total_mantenimiento()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(costo) INTO total
    FROM mantenimiento;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

-- 6. Ventas realizadas por un empleado
DROP FUNCTION IF EXISTS ventas_por_empleado;
DELIMITER $$
CREATE FUNCTION ventas_por_empleado(id_emp INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(total_venta) INTO total
    FROM venta
    WHERE id_empleado = id_emp;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

-- 7. Monto total de pagos de una venta
DROP FUNCTION IF EXISTS monto_total_pagos;
DELIMITER $$
CREATE FUNCTION monto_total_pagos(id_venta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(monto) INTO total
    FROM detalle_venta_pago
    WHERE id_venta = id_venta;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

-- 8. Estado de una maquinaria (Activa/Inactiva)
DROP FUNCTION IF EXISTS estado_maquinaria;
DELIMITER $$
CREATE FUNCTION estado_maquinaria(id_maq INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE est BOOLEAN;
    DECLARE resultado VARCHAR(20);
    SELECT activa INTO est
    FROM maquinaria
    WHERE id = id_maq;
    SET resultado = IF(est=1, 'Activa', 'Inactiva');
    RETURN resultado;
END$$
DELIMITER ;

-- 9. Último mantenimiento de maquinaria
DROP FUNCTION IF EXISTS mantenimiento_reciente;
DELIMITER $$
CREATE FUNCTION mantenimiento_reciente(id_maq INT)
RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE fecha DATE;
    SELECT MAX(fecha_mantenimiento) INTO fecha
    FROM mantenimiento
    WHERE id_maquina = id_maq;
    RETURN fecha;
END$$
DELIMITER ;

-- 10. Clientes frecuentes (que han comprado más del umbral dado)
DROP FUNCTION IF EXISTS clientes_frecuentes;
DELIMITER $$
CREATE FUNCTION clientes_frecuentes(umbral DECIMAL(10,2))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad
    FROM (
        SELECT id_cliente, SUM(total_venta) total
        FROM venta
        GROUP BY id_cliente
        HAVING total > umbral
    ) t;
    RETURN IFNULL(cantidad,0);
END$$
DELIMITER ;

-- 11. Diferencia contra stock ideal
DROP FUNCTION IF EXISTS diferencia_stock_ideal;
DELIMITER $$
CREATE FUNCTION diferencia_stock_ideal(id_producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE actual INT;
    DECLARE ideal INT DEFAULT 100; -- ejemplo: valor meta
    SELECT stock INTO actual
    FROM producto
    WHERE codigo = id_producto;
    RETURN ideal - IFNULL(actual,0);
END$$
DELIMITER ;

-- 12. Ventas diarias en una fecha
DROP FUNCTION IF EXISTS ventas_diarias;
DELIMITER $$
CREATE FUNCTION ventas_diarias(fecha DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(total_venta) INTO total
    FROM venta
    WHERE fecha_venta = fecha;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

-- 13. Cantidad total vendida de un producto
DROP FUNCTION IF EXISTS cantidad_total_vendida;
DELIMITER $$
CREATE FUNCTION cantidad_total_vendida(id_prod INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(cantidad_venta) INTO total
    FROM detalle_venta
    WHERE id_producto = id_prod;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

-- 14. Precio promedio comprado de un producto
DROP FUNCTION IF EXISTS precio_promedio_compra;
DELIMITER $$
CREATE FUNCTION precio_promedio_compra(id_prod INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE precio DECIMAL(10,2);
    SELECT AVG(precio_compra) INTO precio
    FROM entrada
    WHERE id_producto = id_prod;
    RETURN IFNULL(precio,0);
END$$
DELIMITER ;

-- 15. Margen bruto porcentaje de un producto
DROP FUNCTION IF EXISTS margen_bruto_producto;
DELIMITER $$
CREATE FUNCTION margen_bruto_producto(id_prod INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE venta DECIMAL(10,2);
    DECLARE compra DECIMAL(10,2);
    SELECT precio_venta INTO venta FROM producto WHERE codigo = id_prod;
    SELECT AVG(precio_compra) INTO compra FROM entrada WHERE id_producto = id_prod;
    RETURN IFNULL(((venta - compra)/venta)*100,0);
END$$
DELIMITER ;

-- 16. Total clientes en base
DROP FUNCTION IF EXISTS total_clientes;
DELIMITER $$
CREATE FUNCTION total_clientes()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM cliente;
    RETURN total;
END$$
DELIMITER ;

-- 17. Total proveedores
DROP FUNCTION IF EXISTS total_proveedores;
DELIMITER $$
CREATE FUNCTION total_proveedores()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM proveedor;
    RETURN total;
END$$
DELIMITER ;

-- 18. Producto con más stock
DROP FUNCTION IF EXISTS producto_max_stock;
DELIMITER $$
CREATE FUNCTION producto_max_stock()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre VARCHAR(100);
    SELECT nombre INTO nombre
    FROM producto
    ORDER BY stock DESC
    LIMIT 1;
    RETURN nombre;
END$$
DELIMITER ;

-- 19. Producto con menos stock
DROP FUNCTION IF EXISTS producto_min_stock;
DELIMITER $$
CREATE FUNCTION producto_min_stock()
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nombre VARCHAR(100);
    SELECT nombre INTO nombre
    FROM producto
    ORDER BY stock ASC
    LIMIT 1;
    RETURN nombre;
END$$
DELIMITER ;

-- 20. Total de ventas históricas
DROP FUNCTION IF EXISTS total_ventas_historicas;
DELIMITER $$
CREATE FUNCTION total_ventas_historicas()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(total_venta) INTO total FROM venta;
    RETURN IFNULL(total,0);
END$$
DELIMITER ;

USE finca;

-- 1. Generar reporte mensual de ventas
CREATE EVENT IF NOT EXISTS ev_reporte_ventas_mensual
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_DATE + INTERVAL 1 MONTH
DO
    INSERT INTO auditoria_venta(id_venta, fecha, accion)
    SELECT id, NOW(), 'REPORTE_MENSUAL'
    FROM venta
    WHERE MONTH(fecha_venta) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
      AND YEAR(fecha_venta) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH);

-- 2. Generar reporte mensual de mantenimiento total
CREATE EVENT IF NOT EXISTS ev_reporte_mantenimiento_mensual
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO auditoria_pago_mantenimiento(id_pago, fecha, accion)
    SELECT id, NOW(), 'SUMA_MENSUAL'
    FROM pago_mantenimiento
    WHERE MONTH(fecha_pago) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);

-- 3. Actualiza estado maquinaria inactiva sin uso 6 meses
CREATE EVENT IF NOT EXISTS ev_actualizar_maquinaria_inactiva
ON SCHEDULE EVERY 1 MONTH
DO
    UPDATE maquinaria
    SET activa = 0
    WHERE id IN (
        SELECT m.id FROM maquinaria m
        LEFT JOIN uso_maquinaria u ON u.id_maquinaria = m.id
        WHERE u.fecha_uso IS NULL
           OR u.fecha_uso < (CURRENT_DATE - INTERVAL 6 MONTH)
    );

-- 4. Generar reporte mensual de clientes con más compras
CREATE EVENT IF NOT EXISTS ev_resumen_clientes_mensual
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO auditoria_cliente(accion, id_cliente, fecha)
    SELECT 'REPORTE_TOP', id_cliente, NOW()
    FROM (
        SELECT v.id_cliente, SUM(v.total_venta) total
        FROM venta v
        WHERE MONTH(v.fecha_venta) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
        GROUP BY v.id_cliente
        ORDER BY total DESC
        LIMIT 5
    ) tt;

-- 5. Generar reporte mas vendido del mes
CREATE EVENT IF NOT EXISTS ev_producto_mas_vendido_mes
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO auditoria_producto(accion, id_producto, fecha)
    SELECT 'TOP_MENSUAL', dv.id_producto, NOW()
    FROM detalle_venta dv
    JOIN venta v ON dv.id_venta = v.id
    WHERE MONTH(v.fecha_venta) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
    GROUP BY dv.id_producto
    ORDER BY SUM(dv.cantidad_venta) DESC
    LIMIT 1;

-- 6. Actualizar precios de productos perecederos cada mes (+5%)
CREATE EVENT IF NOT EXISTS ev_actualizar_precios_perecederos
ON SCHEDULE EVERY 1 MONTH
DO
    UPDATE producto
    SET precio_venta = precio_venta * 1.05
    WHERE nombre LIKE '%leche%' OR nombre LIKE '%fruta%';

-- 7. Limpiar auditorías de más de 1 año
CREATE EVENT IF NOT EXISTS ev_limpiar_auditorias_antiguas
ON SCHEDULE EVERY 1 WEEK
DO
    DELETE FROM auditoria_producto WHERE fecha < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);
    DELETE FROM auditoria_cliente  WHERE fecha < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- 8. Generar reporte de ventas diarias
CREATE EVENT IF NOT EXISTS ev_reporte_ventas_diarias
ON SCHEDULE EVERY 1 DAY
DO
    INSERT INTO auditoria_venta(id_venta, fecha, accion)
    SELECT id, NOW(), 'REPORTE_DIARIO'
    FROM venta
    WHERE fecha_venta = CURRENT_DATE - INTERVAL 1 DAY;

-- 9. Actualizar salario (incremento anual) a todos los empleados
-- Suponiendo que tienes campo "salario" en empleado.
-- Si no lo tienes, ignora este evento.
-- CREATE EVENT IF NOT EXISTS ev_incremento_salarial_anual
-- ON SCHEDULE EVERY 1 YEAR
-- DO
--     UPDATE empleado SET salario = salario * 1.03;

-- 10. Generar reporte mensual de pagos mantenimientos
CREATE EVENT IF NOT EXISTS ev_reporte_pago_mantenimiento_mensual
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO auditoria_pago_mantenimiento(id_pago, fecha, accion)
    SELECT id, NOW(), 'SUMA_MENSUAL'
    FROM pago_mantenimiento
    WHERE MONTH(fecha_pago) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);

-- 11. Actualizar valores negativos de stock a cero (corrección de integridad)
CREATE EVENT IF NOT EXISTS ev_correccion_stock_negativo
ON SCHEDULE EVERY 1 DAY
DO
    UPDATE producto SET stock = 0 WHERE stock < 0;

-- 12. Generar alerta por productos con stock menor a 10
CREATE TABLE IF NOT EXISTS auditoria_alertas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50),
    id_producto INT,
    fecha DATETIME
);
CREATE EVENT IF NOT EXISTS ev_alerta_stock_bajo
ON SCHEDULE EVERY 1 DAY
DO
    INSERT INTO auditoria_alertas(tipo, id_producto, fecha)
    SELECT 'STOCK_BAJO', codigo, NOW()
    FROM producto
    WHERE stock < 10;

-- 13. Generar reporte de ingresos y egresos (simulado)
CREATE TABLE IF NOT EXISTS reporte_financiero (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    tipo VARCHAR(50),
    monto DECIMAL(10,2)
);
CREATE EVENT IF NOT EXISTS ev_reporte_financiero_mensual
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO reporte_financiero(fecha, tipo, monto)
    SELECT CURRENT_DATE, 'VENTAS', SUM(total_venta)
    FROM venta
    WHERE MONTH(fecha_venta) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);

-- 14. Generar log para ventas mayores a $1M cada día
CREATE EVENT IF NOT EXISTS ev_auditar_ventas_altas_diarias
ON SCHEDULE EVERY 1 DAY
DO
    INSERT INTO auditoria_venta(id_venta, fecha, accion)
    SELECT id, NOW(), 'VENTA_ALTA'
    FROM venta
    WHERE total_venta >= 1000000 AND fecha_venta = CURRENT_DATE - INTERVAL 1 DAY;

-- 15. Generar reporte de ingresos por tipo de pago mensual
CREATE EVENT IF NOT EXISTS ev_reporte_ingreso_por_pago
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO reporte_financiero(fecha, tipo, monto)
    SELECT CURRENT_DATE, tp.nombre_pago, SUM(dvp.monto)
    FROM detalle_venta_pago dvp
    JOIN tipo_pago tp ON tp.id = dvp.id_tipo_pago
    WHERE MONTH(dvp.fecha_pago) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
    GROUP BY tp.nombre_pago;

-- 16. Actualizar inventario desde compras cada día
CREATE EVENT IF NOT EXISTS ev_actualizar_stock_entrada_diaria
ON SCHEDULE EVERY 1 DAY
DO
    UPDATE producto
    SET stock = stock + (
        SELECT IFNULL(SUM(cantidad),0)
        FROM entrada
        WHERE id_producto = producto.codigo AND fecha_compra = CURRENT_DATE - INTERVAL 1 DAY
    );

-- 17. Limpiar clientes sin ventas en el último año
CREATE EVENT IF NOT EXISTS ev_eliminar_clientes_inactivos
ON SCHEDULE EVERY 1 MONTH
DO
    DELETE FROM cliente
    WHERE id NOT IN (
        SELECT DISTINCT id_cliente FROM venta WHERE fecha_venta > CURRENT_DATE - INTERVAL 1 YEAR
    );

-- 18. Limpiar proveedores sin compras en el último año
CREATE EVENT IF NOT EXISTS ev_eliminar_proveedores_inactivos
ON SCHEDULE EVERY 1 MONTH
DO
    DELETE FROM proveedor
    WHERE id NOT IN (
        SELECT DISTINCT id_proveedor FROM entrada WHERE fecha_compra > CURRENT_DATE - INTERVAL 1 YEAR
    );

-- 19. Generar reporte mensual de maquinaria inactiva
CREATE EVENT IF NOT EXISTS ev_reporte_maquinaria_inactiva
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO auditoria_maquinaria(id_maquinaria, fecha, accion)
    SELECT id, NOW(), 'INACTIVA_MES'
    FROM maquinaria
    WHERE activa = 0;

-- 20. Generar resumen mensual de ventas por empleado
CREATE TABLE IF NOT EXISTS reporte_ventas_empleado (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    fecha DATE,
    monto DECIMAL(10,2)
);
CREATE EVENT IF NOT EXISTS ev_resumen_ventas_empleado_mensual
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO reporte_ventas_empleado(id_empleado, fecha, monto)
    SELECT id_empleado, CURRENT_DATE, SUM(total_venta)
    FROM venta
    WHERE MONTH(fecha_venta) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
    GROUP BY id_empleado;

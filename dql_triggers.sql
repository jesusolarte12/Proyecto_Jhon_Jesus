USE finca;

-- 1. Descontar stock cuando se registre venta
DELIMITER $$
CREATE TRIGGER descuenta_stock_venta
AFTER INSERT ON detalle_venta
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock - NEW.cantidad_venta
    WHERE codigo = NEW.id_producto;
END$$
DELIMITER ;

-- 2. Evitar stock negativo al actualizar un producto
DELIMITER $$
CREATE TRIGGER valida_stock_no_negativo
BEFORE UPDATE ON producto
FOR EACH ROW
BEGIN
    IF NEW.stock < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock no puede ser negativo';
    END IF;
END$$
DELIMITER ;

-- 3. Auditoría de cambios de precio de producto
CREATE TABLE IF NOT EXISTS historial_precio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    fecha DATETIME,
    precio_antiguo DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    FOREIGN KEY (id_producto) REFERENCES producto(codigo)
);
DELIMITER $$
CREATE TRIGGER log_cambio_precio_producto
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF OLD.precio_venta <> NEW.precio_venta THEN
        INSERT INTO historial_precio(id_producto, fecha, precio_antiguo, precio_nuevo)
        VALUES (NEW.codigo, NOW(), OLD.precio_venta, NEW.precio_venta);
    END IF;
END$$
DELIMITER ;

-- 4. Registrar cambio en empleado (ejemplo: nombre)
CREATE TABLE IF NOT EXISTS historial_empleado (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    fecha DATETIME,
    campo_modificado VARCHAR(50),
    valor_antiguo VARCHAR(100),
    valor_nuevo VARCHAR(100),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id)
);
DELIMITER $$
CREATE TRIGGER log_cambio_nombre_empleado
AFTER UPDATE ON empleado
FOR EACH ROW
BEGIN
    IF OLD.nombre <> NEW.nombre THEN
        INSERT INTO historial_empleado(id_empleado, fecha, campo_modificado, valor_antiguo, valor_nuevo)
        VALUES (NEW.id, NOW(), 'nombre', OLD.nombre, NEW.nombre);
    END IF;
END$$
DELIMITER ;

-- 5. Auditoría de cambios de salario (si tienes campo salario, aquí ejemplo con rol)
DELIMITER $$
CREATE TRIGGER log_cambio_rol_empleado
AFTER UPDATE ON empleado
FOR EACH ROW
BEGIN
    IF OLD.rol <> NEW.rol THEN
        INSERT INTO historial_empleado(id_empleado, fecha, campo_modificado, valor_antiguo, valor_nuevo)
        VALUES (NEW.id, NOW(), 'rol', OLD.rol, NEW.rol);
    END IF;
END$$
DELIMITER ;

-- 6. Marcar maquinaria como inactiva tras mantenimiento que la deja fuera de servicio
DELIMITER $$
CREATE TRIGGER desactivar_maquinaria_mantenimiento
AFTER INSERT ON mantenimiento
FOR EACH ROW
BEGIN
    IF NEW.acto_funcionamiento = 0 THEN
        UPDATE maquinaria SET activa = 0 WHERE id = NEW.id_maquina;
    END IF;
END$$
DELIMITER ;

-- 7. Auditoría de nuevo cliente
CREATE TABLE IF NOT EXISTS auditoria_cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    accion VARCHAR(50),
    id_cliente INT,
    fecha DATETIME,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);
DELIMITER $$
CREATE TRIGGER auditar_cliente_nuevo
AFTER INSERT ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_cliente(accion, id_cliente, fecha)
    VALUES ('INSERT', NEW.id, NOW());
END$$
DELIMITER ;

-- 8. Auditoría de borrado de cliente
DELIMITER $$
CREATE TRIGGER auditar_cliente_eliminado
AFTER DELETE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_cliente(accion, id_cliente, fecha)
    VALUES ('DELETE', OLD.id, NOW());
END$$
DELIMITER ;

-- 9. Auditoría de nuevo proveedor
CREATE TABLE IF NOT EXISTS auditoria_proveedor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    accion VARCHAR(50),
    id_proveedor INT,
    fecha DATETIME,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id)
);
DELIMITER $$
CREATE TRIGGER auditar_proveedor_nuevo
AFTER INSERT ON proveedor
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_proveedor(accion, id_proveedor, fecha)
    VALUES ('INSERT', NEW.id, NOW());
END$$
DELIMITER ;

-- 10. Auditoría borrado de proveedor
DELIMITER $$
CREATE TRIGGER auditar_proveedor_borrado
AFTER DELETE ON proveedor
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_proveedor(accion, id_proveedor, fecha)
    VALUES ('DELETE', OLD.id, NOW());
END$$
DELIMITER ;

-- 11. Auditoría de nuevo producto
CREATE TABLE IF NOT EXISTS auditoria_producto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    accion VARCHAR(50),
    id_producto INT,
    fecha DATETIME,
    FOREIGN KEY (id_producto) REFERENCES producto(codigo)
);
DELIMITER $$
CREATE TRIGGER auditar_producto_nuevo
AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_producto(accion, id_producto, fecha)
    VALUES ('INSERT', NEW.codigo, NOW());
END$$
DELIMITER ;

-- 12. Auditoría borrado de producto
DELIMITER $$
CREATE TRIGGER auditar_producto_borrado
AFTER DELETE ON producto
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_producto(accion, id_producto, fecha)
    VALUES ('DELETE', OLD.codigo, NOW());
END$$
DELIMITER ;

-- 13. Registrar compra y aumento de stock
DELIMITER $$
CREATE TRIGGER aumentar_stock_entrada
AFTER INSERT ON entrada
FOR EACH ROW
BEGIN
    UPDATE producto
    SET stock = stock + NEW.cantidad
    WHERE codigo = NEW.id_producto;
END$$
DELIMITER ;

-- 14. Auditoría de pago de mantenimiento
CREATE TABLE IF NOT EXISTS auditoria_pago_mantenimiento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_pago INT,
    fecha DATETIME,
    accion VARCHAR(50),
    FOREIGN KEY (id_pago) REFERENCES pago_mantenimiento(id)
);
DELIMITER $$
CREATE TRIGGER auditar_pago_mantenimiento_nuevo
AFTER INSERT ON pago_mantenimiento
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_pago_mantenimiento(id_pago, fecha, accion)
    VALUES (NEW.id, NOW(), 'INSERT');
END$$
DELIMITER ;

-- 15. Evitar pagos de mantenimiento negativos
DELIMITER $$
CREATE TRIGGER valida_pago_mantenimiento_valor
BEFORE INSERT ON pago_mantenimiento
FOR EACH ROW
BEGIN
    IF NEW.valor < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite valor de pago negativo';
    END IF;
END$$
DELIMITER ;

-- 16. Actualiza tecnomecánica/soat en maquinaria tras mantenimiento
DELIMITER $$
CREATE TRIGGER actualizar_fecha_soat_tecnomecanica
AFTER INSERT ON mantenimiento
FOR EACH ROW
BEGIN
    IF NEW.observaciones LIKE '%soat%' THEN
        UPDATE maquinaria SET seguro_soat = NEW.fecha_mantenimiento WHERE id = NEW.id_maquina;
    END IF;
    IF NEW.observaciones LIKE '%tecnomecanica%' THEN
        UPDATE maquinaria SET tecnomecanica = NEW.fecha_mantenimiento WHERE id = NEW.id_maquina;
    END IF;
END$$
DELIMITER ;

-- 17. Auditoría de ventas
CREATE TABLE IF NOT EXISTS auditoria_venta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT,
    fecha DATETIME,
    accion VARCHAR(50),
    FOREIGN KEY (id_venta) REFERENCES venta(id)
);
DELIMITER $$
CREATE TRIGGER auditar_venta_nueva
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_venta(id_venta, fecha, accion)
    VALUES (NEW.id, NOW(), 'INSERT');
END$$
DELIMITER ;

-- 18. Registrar cambios de cantidad_venta en detalles de venta
CREATE TABLE IF NOT EXISTS auditoria_detalle_venta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_detalle INT,
    fecha DATETIME,
    cantidad_antigua INT,
    cantidad_nueva INT,
    FOREIGN KEY (id_detalle) REFERENCES detalle_venta(id)
);
DELIMITER $$
CREATE TRIGGER auditar_cambio_cantidad_detalle
AFTER UPDATE ON detalle_venta
FOR EACH ROW
BEGIN
    IF OLD.cantidad_venta <> NEW.cantidad_venta THEN
        INSERT INTO auditoria_detalle_venta(id_detalle, fecha, cantidad_antigua, cantidad_nueva)
        VALUES (NEW.id, NOW(), OLD.cantidad_venta, NEW.cantidad_venta);
    END IF;
END$$
DELIMITER ;

-- 19. Registrar auditoría de cambios sobre maquinaria
CREATE TABLE IF NOT EXISTS auditoria_maquinaria (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_maquinaria INT,
    fecha DATETIME,
    accion VARCHAR(50),
    FOREIGN KEY (id_maquinaria) REFERENCES maquinaria(id)
);
DELIMITER $$
CREATE TRIGGER auditoria_maquinaria_update
AFTER UPDATE ON maquinaria
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_maquinaria(id_maquinaria, fecha, accion)
    VALUES (NEW.id, NOW(), 'UPDATE');
END$$
DELIMITER ;

-- 20. Auditoría nueva entrada de inventario
CREATE TABLE IF NOT EXISTS auditoria_entrada (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_entrada INT,
    fecha DATETIME,
    cantidad INT,
    FOREIGN KEY (id_entrada) REFERENCES entrada(id)
);
DELIMITER $$
CREATE TRIGGER auditar_entrada_nueva
AFTER INSERT ON entrada
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_entrada(id_entrada, fecha, cantidad)
    VALUES (NEW.id, NOW(), NEW.cantidad);
END$$
DELIMITER ;

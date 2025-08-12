-- *************** Creacion de usuarios ***************

-- 1. Usuario administrador
create user 'Administrador'@'%' identified by 'Administrador123';

grant all privileges on finca.* to 'Administrador'@'%';

-- 2. Usuario vendedor
create user 'Vendedor'@'%' identified by 'Vendedor123';

-- el vendedor puede ver productos, clientes y registrar ventas
grant select on finca.producto to 'Vendedor'@'%';
grant select on finca.cliente to 'Vendedor'@'%';

-- tambien puede insertar ventas y detalles
GRANT insert on finca.venta to 'Vendedor'@'%';
GRANT insert on finca.detalle_venta to 'Vendedor'@'%';
GRANT insert on finca.detalle_venta_pago to 'Vendedor'@'%';

-- 3. Usuario contador
create user 'Contador'@'%' identified by 'Contador123'

-- el contador solo lectura de información financiera
grant select on finca.venta to 'Contador'@'%';
grant select on finca.detalle_venta to 'Contador'@'%';
grant select on finca.detalle_venta_pago to 'Contador'@'%';

grant select on finca.mantenimiento to 'Contador'@'%';
grant select on finca.pago_mantenimiento to 'Contador'@'%';

-- 4. Usuario encargado de inventario
create user 'Inventario'@'%' identified by 'Inventario123'

-- control total de productos y entradas
grant select, insert, update, delete on finca.producto to 'Inventario'@'%';
grant select, insert, update, delete on finca.entrada to 'Inventario'@'%';

-- puede ver proveedores
grant select on finca.proveedor to 'Inventario'@'%';

-- 5. Usuario administrador de campo
create user 'Campo'@'%' identified by 'Campo123'

-- gestion de maquinaria y servicios
grant select, insert on finca.uso_maquinaria to 'Campo'@'%';
grant select on finca.maquinaria to 'Campo'@'%';
grant select on finca.servicio to 'Campo'@'%';

-- puede registrar mantenimientos pero no modificar pagos
grant insert on finca.mantenimiento to 'Campo'@'%';
grant select on finca.mantenimiento to 'Campo'@'%';

select user, Host from mysql.user;
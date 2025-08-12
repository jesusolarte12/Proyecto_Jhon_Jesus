-- *************** Consultas basicas ***************

use finca;

-- 1.Obtener todos los nombres y teléfonos de los clientes.
select e.nombre "nombre cliente", c.telefono "telefono cliente"
from cliente c;

-- 2.Mostrar el nombre y correo de todos los empleados.
select e.nombre "nombre empleado", e.correo "correo empleado"
from empleado e;

-- 3.Listar todos los productos con su precio de venta.
select p.nombre "nombre producto", p.precio_venta "precio de venta"
from producto p;

-- 4.Ver todas las máquinas con su año de compra.
select m.nombre "nombre maquina", m.anio_compra "año de compra"
from maquinaria m;

-- 5.Mostrar todos los proveedores con su descripción.
select p.nombre "nombre proveedor", p.descripcion "descripcion proveedor"
from proveedor p;

-- 6.Listar todos los roles registrados en el sistema.
select r.rol
from rol r;

-- 7.Obtener todas las ventas con su total de venta.
select p.nombre "nombre producto", v.total_venta "total de la venta"
from venta v
join producto p on p.codigo = v.id;

-- 8.Mostrar las fechas y costos de todos los mantenimientos.
select m.fecha_mantenimiento "fecha de mantenimiento", m.costo "costo del mantenimiento"
from mantenimiento m;

-- 9.Ver todas las entradas con cantidad y precio de compra.
select e.cantidad "cantidad de entrada", e.precio_compra "precio de compra"
from entrada e;

-- 10.Listar todos los pagos de mantenimiento con su fecha.
select m2.nombre "nombre maquina", pm.fecha_pago "fecha de pago"
from pago_mantenimiento pm
join mantenimiento m on m.id = pm.id_mantenimiento
join maquinaria m2 on m2.id = m.id_maquina;

-- 11.Mostrar todas las ventas ordenadas por fecha de venta ascendente.
select p.codigo "codigo producto", v.fecha_venta "fecha de venta"
from venta v
join producto p
order by v.fecha_venta asc;

-- 12.Obtener las máquinas activas (activa = TRUE).
select m.nombre "nombre maquina", m.activa "maquina activa"
from maquinaria m
where m.activa = 1;

-- 13. Listar los productos cuyo precio de venta sea mayor a 10.000.
select p.nombre "nombre producto", p.precio_venta "precio de venta"
from producto p
where p.precio_venta > 10000
order by p.precio_venta asc;

-- 14. Mostrar los empleados con teléfono que empiece por "3".
select e.nombre "nombre empleado", e.rol "rol del empleado", e.telefono "telefono empleado"
from empleado e
where e.telefono like concat("%", 3);

-- 15.Obtener los clientes cuyo NIT sea mayor a un valor específico.
select c.nombre "nombre cliente", c.nit "nit cliente"
from cliente c
where c.nit > 900001040;

-- 16.Ver todos los mantenimientos realizados después de una fecha específica.
select m2.nombre "nombre maquina", m.fecha_mantenimiento "fecha de mantenimiento"
from mantenimiento m
join maquinaria m2 on m.id = m.id_maquina
where m.fecha_mantenimiento > "2025-01-10";

-- 17. mostrar las entradas con cantidad mayor a 10.
select e.cantidad "cantidad de entrada"
from entrada e
join producto p on p.codigo = e.id_producto
where e.cantidad > 10
order by e.cantidad asc;

-- 18.Listar los productos ordenados por nombre en orden descendente.
select p.nombre "nombre producto" 
from producto p
order by p.nombre desc;

-- 19.Mostrar los servicios cuyo nombre contenga la palabra "Revisión".
select m.nombre "nombre maquina", um.observaciones "observaciones de maquinaria"
from uso_maquinaria um
join maquinaria m on m.id = um.id_maquinaria
where um.observaciones like concat ("%", "Revision", "%");

-- 20.Ver las ventas con total de venta menor a 100000.
select v.id "id venta", v.total_venta "total de la venta"
from venta v
where v.total_venta < 100000
order by v.total_venta desc;

-- 21.Mostrar las máquinas cuyo seguro_soat haya vencido antes de cierta fecha.
select m.nombre "nombre maquina", m.seguro_soat "seguro", m.activa
from maquinaria m
where activa = 0;

-- 22.Listar los pagos de mantenimiento con valor mayor a 355000.
select pm.id "id mantenimiento", pm.valor "valor mantenimiento"
from pago_mantenimiento pm
where pm.valor > 355000
order by pm.valor asc;

-- 23.Mostrar el nombre y año de compra de máquinas ordenadas por año.
select m.nombre "nombre maquina", m.anio_compra "año de compra"
from maquinaria m
order by m.anio_compra asc;

-- 24.Listar clientes ordenados por nombre alfabéticamente.
select c.nombre "nombre cliente"
from cliente c
order by c.nombre asc;

-- 25.Obtener todos los roles cuyo nombre tenga más de 15 caracteres.
select r.rol
from rol r
where char_length(r.rol) > 15;

-- 26.Mostrar ventas ordenadas de mayor a menor por total de venta.
select v.id "id de la venta", v.total_venta "total de la venta"
from venta v
order by v.total_venta desc;

-- 27.Ver todos los proveedores con correo que contenga “@gmail.com”.
select p.nombre "nombre proveedor", p.telefono "telefono del proveedor", p.correo "correo del proveedor"
from proveedor p
where p.correo like concat("%", "gmail.com", "%")

-- 28.Listar empleados cuyo nombre empiece por la letra “A”.
select e.nombre "nombre empleado"
from empleado e
where e.nombre like concat("A", "%")

-- 30.Mostrar todos los productos cuyo precio esté entre 20000 y 40000.
select p.nombre "nombre producto", p.precio_venta "precio de venta"
from producto p
where p.precio_venta >= 20000 and p.precio_venta <= 40000
order by p.precio_venta asc;

-- 31.Contar cuántos clientes hay registrados.
select count(c.id) "cantidad clientes registrados"
from cliente c;

-- 32.Contar cuántas máquinas están activas.
select count(m.id) "cantidad maquinas activas"
from maquinaria m
where m.activa = 1;

-- 32.Calcular el promedio del precio de venta de los productos.
select avg(p.precio_venta) "promedio precio de venta productos"
from producto p;

-- 33.Obtener el total de ventas realizadas en el año actual.
select sum(total_venta) "total ventas años 2025"
from venta v
where year(fecha_venta) = "2025";

-- 34.Calcular el costo total de todos los mantenimientos.
select sum(m.costo) "costo en dolares"
from mantenimiento m;

-- 35.Contar cuántos pagos de mantenimiento hay por tipo de pago.
select count(pm.tipo_pago) "cantidad pagos mantenimiento"
from pago_mantenimiento pm;

-- 36.Mostrar el total de productos vendidos en cada venta.
select id_venta, sum(cantidad_venta) total_productos
from detalle_venta
group by id_venta;

-- 37.Listar los clientes junto con el total de ventas que han realizado.
select c.nombre, count(v.id) "total de ventas"
from cliente c
join venta v on c.id = v.id_cliente
group by c.nombre;

-- 38.Obtener el total invertido en entradas por cada producto.
select p.nombre, sum(e.cantidad * e.precio_compra) "total de invertido"
from entrada e
join producto p on e.id_producto = p.codigo
group by p.nombre;

-- 39.Calcular el costo promedio de mantenimiento por máquina.
select m.nombre, AVG(mt.costo) "costo promedio"
from mantenimiento mt
join maquinaria m on mt.id_maquina = m.id
group by m.nombre;

-- 40.Listar los proveedores junto con la cantidad de productos que suministran.
select pr.nombre, count(distinct e.id_producto) "total de productos"
from entrada e
join proveedor pr on e.id_proveedor = pr.id
group by pr.nombre;

-- 41.Contar cuántas ventas realizó cada empleado.
select emp.nombre, count(v.id) "total vendas de empleado"
from empleado emp
join venta v on emp.id = v.id_empleado
group by emp.nombre;

-- 42.Calcular el total recaudado por cada tipo de pago en ventas.
select tp.nombre_pago, sum(dvp.monto) "total de recaudado"
from detalle_venta_pago dvp
join tipo_pago tp on dvp.id_tipo_pago = tp.id
group by tp.nombre_pago;

-- 43.Mostrar los productos más vendidos (ordenar por cantidad).
select p.nombre "nombre producto", sum(dv.cantidad_venta) "cantidad vendida"
from detalle_venta dv
join producto p on dv.id_producto = p.codigo
group by p.nombre
order by cantidad_venta desc;

-- 44.Listar las máquinas junto con el número de veces que se han usado.
select m.nombre, count(um.id) "cantidad veces usada"
from uso_maquinaria um
join maquinaria m on um.id_maquinaria = m.id
group by m.nombre;

-- 45.Calcular el total de horas de uso por máquina (si se registran tiempos en observaciones).
select m.nombre, sum(CAST(um.observaciones AS DECIMAL)) "horas de uso"
from uso_maquinaria um
join maquinaria m on um.id_maquinaria = m.id
group by m.nombre;

-- 46.Listar los mantenimientos junto con el número de pagos asociados.
select mt.id, count(pm.id) "total de pagos"
from mantenimiento mt
left join pago_mantenimiento pm on mt.id = pm.id_mantenimiento
group by mt.id;

-- 47.Obtener el total invertido en entradas agrupado por proveedor.
select pr.nombre, sum(e.cantidad * e.precio_compra) "total de inventario invertido"
from entrada e
join proveedor pr on e.id_proveedor = pr.id
group by pr.nombre;

-- 48.Mostrar el total de ventas por mes.
select year(fecha_venta) año, month(fecha_venta) mes, sum(total_venta) "total ventas del mes"
from venta
group by año, mes
order by año, mes;

-- 49.Calcular el valor total de pagos de mantenimiento por mes.
select year(fecha_pago) año, month(fecha_pago) mes, sum(valor) "valor total pagos mantenimiento"
from pago_mantenimiento
group by año, mes
order by año, mes;

-- 50.Listar empleados junto con el número de máquinas que han usado.
select emp.nombre, count(distinct um.id_maquinaria) "maquinas usadas"
from empleado emp
join uso_maquinaria um on emp.id = um.id_empleado
group by emp.nombre;

-- 51.Obtener el producto más caro.
select nombre "nombre producto", precio_venta "precio de venta"
from producto
order by precio_venta desc
LIMIT 1;

-- 52.Obtener la máquina más antigua registrada.
select nombre, anio_compra "año de compra"
from maquinaria
order by anio_compra asc
LIMIT 1;

-- 53.Listar los clientes con más de 3 compras realizadas.
select c.nombre, count(v.id) "total de compras"
from cliente c
join venta v on c.id = v.id_cliente
group by c.nombre
having count(v.id) > 3;

-- 54.Contar cuántos servicios distintos se han registrado en uso_maquinaria.
select count(distinct tipo_servicio) "total de servicios realizados"
from uso_maquinaria;

-- 55.Mostrar el total de entradas hechas por cada empleado.
select emp.nombre, count(e.id) "total de entradas por empleado"
from empleado emp
join entrada e on emp.id = e.id_empleado
group by emp.nombre;

-- 56.Calcular el valor total de ventas por cliente.
select c.nombre, sum(v.total_venta) "total ventas por cliente"
from cliente c
join venta v on c.id = v.id_cliente
group by c.nombre;

-- 57.Mostrar el total de productos distintos vendidos por cada cliente.
select c.nombre, count(distinct dv.id_producto) "total de productos distintos x cliente"
from cliente c
join venta v on c.id = v.id_cliente
join detalle_venta dv on v.id = dv.id_venta
group by c.nombre;

-- 58.Listar los proveedores que suministraron productos con precio de compra mayor a 500.
select distinct pr.nombre
from proveedor pr
join entrada e on pr.id = e.id_proveedor
where e.precio_compra > 500;

-- 59.Calcular el costo total de mantenimiento por máquina.
select m.nombre, sum(mt.costo) "costo total mantenimiento maquina"
from mantenimiento mt
join maquinaria m on mt.id_maquina = m.id
group by m.nombre;

-- 60. Calcular el costo total de mantenimiento por máquina
select m.nombre, sum(mt.costo) "costo total mantenimiento"
from mantenimiento mt
join maquinaria m on mt.id_maquina = m.id
group by m.nombre;

-- 61. Mostrar los tipos de pago utilizados en ventas
select distinct tp.nombre_pago "tipo pago"
from detalle_venta_pago dvp
join tipo_pago tp on dvp.id_tipo_pago = tp.id;

-- 62. Obtener el producto menos vendido
select p.nombre, sum(dv.cantidad_venta) "producto menos vendido"
from detalle_venta dv
join producto p on dv.id_producto = p.codigo
group by p.nombre
order by cantidad_venta asc
LIMIT 1;

-- 63. Listar las ventas junto con el nombre del cliente
select v.id "id venta", v.fecha_venta "fecha de venta", c.nombre "nombre cliente"
from venta v
join cliente c on v.id_cliente = c.id;

-- 64. Listar los pagos de mantenimiento junto con la fecha de mantenimiento
select pm.id "id pago", pm.fecha_pago "fecha de pago", mt.fecha_mantenimiento "fecha de mantenimiento"
from pago_mantenimiento pm
join mantenimiento mt on pm.id_mantenimiento = mt.id;

-- 65. Mostrar las entradas junto con el nombre del producto
select e.id "id entrada", e.cantidad "cantidad de entrada", e.precio_compra "precio de compra", p.nombre "producto nombre"
from entrada e
join producto p on e.id_producto = p.codigo;

-- 66. Obtener las ventas junto con el nombre del producto y cantidad vendida
select v.id "id venta", p.nombre "producto nombre", dv.cantidad_venta "cantidad vendida"
from venta v
join detalle_venta dv on v.id = dv.id_venta
join producto p on dv.id_producto = p.codigo;

-- 67. Listar las máquinas junto con el último mantenimiento realizado
select m.nombre, max(mt.fecha_mantenimiento) "ultimo mantenimiento realizado el:"
from maquinaria m
left join mantenimiento mt on m.id = mt.id_maquina
group by m.nombre;

-- 68. Mostrar las ventas con el nombre del cliente y el total de pago recibido
select v.id, c.nombre, sum(dvp.monto) "monto total"
from venta v
join cliente c on v.id_cliente = c.id
join detalle_venta_pago dvp on v.id = dvp.id_venta
group by v.id, c.nombre;

-- 69. Obtener la cantidad total de productos vendidos por mes
select year(v.fecha_venta) año, month(v.fecha_venta) mes, sum(dv.cantidad_venta) total_vendido
from venta v
join detalle_venta dv on v.id = dv.id_venta
group by año, mes
order by año, mes;

-- 70. Mostrar el total de pagos de mantenimiento agrupado por tipo de pago
select tipo_pago, sum(valor) "total pagos mantenimiento"
from pago_mantenimiento
group by tipo_pago;

-- 71. Obtener los clientes que han comprado más que el promedio de todos los clientes
select nombre, total_gastado
from (
    select c.nombre, sum(v.total_venta) total_gastado
    from cliente c
    join venta v on c.id = v.id_cliente
    group by c.nombre) sub
where total_gastado > (
    select AVG(total_venta)
    from venta
);

-- 72. Mostrar las máquinas que no han tenido mantenimiento
select m.nombre "nombre maquina"
from maquinaria m
left join mantenimiento mt on m.id = mt.id_maquina
where mt.id is null;

-- 73. Listar los productos que nunca se han vendido
select p.nombre
from producto p
left join detalle_venta dv on p.codigo = dv.id_producto
where dv.id is null;

-- 74. Obtener los proveedores que no han registrado entradas
select pr.nombre "nombre proveedor"
from proveedor pr
left join entrada e on pr.id = e.id_proveedor
where e.id is null;

-- 75. Mostrar las ventas cuyo total sea mayor al promedio de ventas
select *
from venta
where total_venta > (select AVG(total_venta) from venta);

-- 76. Listar los clientes que han comprado todos los productos registrados
select c.nombre "nombre cliente"
from cliente c
join venta v on c.id = v.id_cliente
join detalle_venta dv on v.id = dv.id_venta
group by c.nombre
having count(distinct dv.id_producto) = (select count(*) from producto);

-- 77. Mostrar el empleado con más entradas registradas
select emp.nombre "nombre empleado", count(e.id) "total entradas"
from empleado emp
join entrada e on emp.id = e.id_empleado
group by emp.nombre
order by "total_entradas" desc
LIMIT 1;

-- 78. Obtener la máquina que más veces se ha usado
select m.nombre "nombre maquina", count(um.id) "veces de uso"
from maquinaria m
join uso_maquinaria um on m.id = um.id_maquinaria
group by m.nombre
order by "veces de uso" desc
LIMIT 1;

-- 79. Listar los productos cuyo precio de venta es mayor que el precio de compra promedio
select p.nombre "nombre producto", p.precio_venta "precio de venta"
from producto p
where p.precio_venta > (select AVG(precio_compra) from entrada);

-- 80. Mostrar el mantenimiento más caro realizado
select *
from mantenimiento
order by costo desc
LIMIT 1;

-- 81. Obtener el cliente con la compra más reciente
select c.nombre "nombre cliente", v.fecha_venta "fecha de venta"
from cliente c
join venta v on c.id = v.id_cliente
order by v.fecha_venta desc
LIMIT 1;

-- 82. Listar las máquinas con el mantenimiento más reciente
select m.nombre "nombre maquinaria", max(mt.fecha_mantenimiento) "ultimo mantenimiento"
from maquinaria m
join mantenimiento mt on m.id = mt.id_maquina
group by m.nombre
order by "ultimo mantenimiento" desc;

-- 83. Obtener los productos vendidos en más de 5 ventas distintas
select p.nombre "nombre producto", count(distinct dv.id_venta) "ventas distintas"
from producto p
join detalle_venta dv on p.codigo = dv.id_producto
group by p.nombre
having "ventas distintas" > 5;

-- 84. Mostrar las ventas pagadas con más de un tipo de pago
select v.id, count(distinct dvp.id_tipo_pago) tipos_pago
from venta v
join detalle_venta_pago dvp on v.id = dvp.id_venta
group by v.id
having tipos_pago > 1;

-- 85. Listar los empleados que han usado más de 3 máquinas distintas
select e.nombre "nombre empleado", count(distinct um.id_maquinaria) "maquinas usadas"
from empleado e
join uso_maquinaria um on e.id = um.id_empleado
group by e.nombre
having "maquinas usadas" > 3;

-- 86. Obtener el mes con más ventas registradas
select year(fecha_venta) año, month(fecha_venta) mes, count(*) "total ventas"
from venta
group by año, mes
order by "total ventas" desc
LIMIT 1;

-- 87. Mostrar las máquinas que han tenido más de 2 mantenimientos en un año
select m.nombre "nombre maquinaria", year(mt.fecha_mantenimiento) año, count(*) "total mantenimientos"
from maquinaria m
join mantenimiento mt on m.id = mt.id_maquina
group by m.nombre, año
having "total mantenimientos" > 2;

-- 88. Listar los productos que han generado más ingresos
select p.nombre "nombre producto", sum(dv.cantidad_venta * p.precio_venta) ingresos
from producto p
join detalle_venta dv on p.codigo = dv.id_producto
group by p.nombre
order by ingresos desc;

-- 89. Obtener los clientes que no han hecho compras en el último año
select c.nombre "nombre cliente"
from cliente c
left join venta v on c.id = v.id_cliente and v.fecha_venta >= date_sub(curdate(), interval 1 year)
where v.id is null;

-- 90. Mostrar los proveedores con los que se ha hecho más compras en valor monetario
select p.nombre "nombre proveedor", sum(e.cantidad * e.precio_compra) "total de compras"
from proveedor p
join entrada e on p.id = e.id_proveedor
group by p.nombre
order by "total de compras" desc;

-- 91. Listar las máquinas cuyo seguro y tecnomecánica están vencidos
select nombre "nombre maquinaria", seguro_soat "seguro", tecnomecanica
from maquinaria
where seguro_soat < curdate() and tecnomecanica < curdate();

-- 92. Obtener el producto más comprado por un cliente específico
select p.nombre "nombre producto", sum(dv.cantidad_venta) "total comprado"
from producto p
join detalle_venta dv on p.codigo = dv.id_producto
join venta v on dv.id_venta = v.id
where v.id_cliente = 1
group by p.nombre
order by "total comprado" desc
LIMIT 1;

-- 93. Mostrar las ventas que incluyan productos de más de un proveedor
select v.id "id de la venta", count(distinct e.id_proveedor) "distinto proveedor"
from venta v
join detalle_venta dv on v.id = dv.id_venta
join entrada e on dv.id_producto = e.id_producto
group by v.id
having "distinto proveedor" > 1;

-- 94. Obtener las máquinas con mantenimientos cuyo costo total supere cierto valor
select m.nombre "nombre maquinaria", sum(mt.costo) "costo total"
from maquinaria m
join mantenimiento mt on m.id = mt.id_maquina
group by m.nombre
having "costo total" > 1000;

-- 95. Mostrar el mantenimiento con más pagos asociados
select mt.id "id mantenimiento", count(pm.id) "total de pagos"
from mantenimiento mt
join pago_mantenimiento pm on mt.id = pm.id_mantenimiento
group by mt.id
order by "total de pagos" desc
LIMIT 1;

-- 96. Listar los clientes con el pago más alto en una venta
select c.nombre "nombre cliente", max(dvp.monto) "pago maximo"
from cliente c
join venta v on c.id = v.id_cliente
join detalle_venta_pago dvp on v.id = dvp.id_venta
group by c.nombre
order by "pago maximo" desc;

-- 97. Obtener los proveedores con productos cuyo precio de venta sea mayor que el de compra
select distinct pr.nombre "nombre proveedor"
from proveedor pr
join entrada e on pr.id = e.id_proveedor
join producto p on e.id_producto = p.codigo
where p.precio_venta > e.precio_compra;

-- 98. Mostrar las ventas con más de 3 productos distintos vendidos
select v.id "id venta", count(distinct dv.id_producto) productos_distintos
from venta v
join detalle_venta dv on v.id = dv.id_venta
group by v.id
having productos_distintos > 3;

-- 99. Obtener los productos que nunca han tenido entrada registrada
select p.nombre "nombre producto"
from producto p
left join entrada e on p.codigo = e.id_producto
where e.id is null;

-- 100. Listar los clientes que han comprado productos de todos los proveedores
select c.nombre "nombre cliente"
from cliente c
join venta v on c.id = v.id_cliente
join detalle_venta dv on v.id = dv.id_venta
join entrada e on dv.id_producto = e.id_producto
group by c.nombre
having count(distinct e.id_proveedor) = (select count(*) from proveedor);






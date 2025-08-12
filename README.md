# 🌱 Proyecto: Base de Datos para Gestión Integral de Finca Agrícola

## 📄 Descripción General

Este proyecto implementa una *base de datos relacional completa* para la administración integral de una finca agrícola, incorporando:

- Diseño de tablas normalizadas (hasta 3FN) que cubren procesos operativos, administrativos y productivos.
- Inserción de datos de prueba coherentes y realistas.
- Automatizaciones y lógica de negocio mediante *Procedimientos Almacenados, **Funciones SQL, **Triggers* y *Eventos*.
- Cobertura de todas las áreas clave: producción agrícola, inventario, ventas, clientes, proveedores, maquinaria, personal y mantenimiento.

---

## 🗂 Estructura de Archivos

- ddl.sql → Creación de todas las tablas y relaciones.
- dml.sql → Inserción de datos de prueba para las tablas principales y complementarias.
- procedimientos.sql → 20 procedimientos almacenados corregidos y optimizados.
- funciones.sql → 20 funciones SQL para cálculos y consultas reutilizables.
- triggers.sql → 20 triggers para control de integridad, auditoría y automatización.
- eventos.sql → 20 eventos programados para reportes y mantenimiento automático.

---

## 🗃 Esquema de la Base de Datos

### *Módulos principales*
- *Personal y Roles:* empleado, rol
- *Clientes y Proveedores:* cliente, proveedor
- *Inventario y Productos:* producto, entrada
- *Ventas y Pagos:* venta, detalle_venta, tipo_pago, detalle_venta_pago
- *Maquinaria y Mantenimiento:* maquinaria, uso_maquinaria, servicio, mantenimiento, pago_mantenimiento
- *Producción Agrícola:*  
  - cultivo
  - lote
  - siembra
  - cosecha
  - insumo
  - uso_insumo

---

## ⚙️ Lógica de Negocio

### 📌 Procedimientos (20)
- Registro y actualización de empleados, clientes, proveedores, ventas, productos, mantenimientos.
- Reportes: producto más vendido, top clientes, historial de uso de maquinaria, pagos de mantenimiento.
- Validaciones: evitar duplicados, precios/stock no válidos.

### 📌 Funciones (20)
- Consultas rápidas para apoyo en reportes: total ventas por mes, utilidad de productos, stock disponible, mantenimiento reciente, clientes frecuentes, diferencias de stock ideal, etc.

### 📌 Triggers (20)
- Actualización automática de stock en ventas/entradas.
- Auditorías (INSERT/UPDATE/DELETE) en clientes, productos, empleados, proveedores y maquinaria.
- Prevención de datos inválidos (stocks o pagos negativos).
- Cambios automáticos de estado de maquinaria.

### 📌 Eventos (20)
- Generación automática de reportes diarios, mensuales y anuales (ventas, inventario, maquinaria).
- Limpieza de datos obsoletos en auditorías.
- Alertas de stock bajo y maquinaria inactiva.
- Actualización masiva de precios, salarios e inventarios según fechas programadas.

---

## 📊 Datos de Ejemplo (DML)
- Mínimo 50 registros por tabla principal y complementaria.
- Datos coherentes y realistas basados en operaciones agrícolas reales.
- Ejemplos completos para probar todos los módulos, incluyendo producción agrícola y ciclo cultivo-cosecha.

## 🔒 Seguridad y Gestión de Acceso

- El sistema incluye un control de acceso basado en roles implementado directamente en MySQL, con la creación de usuarios y asignación de privilegios según funciones específicas dentro de la operación de la finca.
Roles definidos

1. Administrador → Acceso total a la base de datos, sin restricciones.

2. Vendedor → Permisos para gestionar ventas, clientes e inventario.

3. Contador → Acceso a reportes financieros, pagos y ventas.

4. Encargado de Inventario → Gestión de productos, entradas y stock.

4. Supervisor de Campo → Registro y seguimiento de maquinaria, mantenimiento y producción agrícola.

## 👥 Colaboradores

- Jesús David Olarte Landinez
- Jhon Fredy León
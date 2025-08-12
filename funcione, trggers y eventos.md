# 📑 Funciones, Triggers y Eventos en el Proyecto “Finca”

## 📌 Índice
1. [Resumen](#resumen)
2. [Funciones SQL](#funciones-sql)
3. [Triggers (Disparadores)](#triggers-disparadores)
4. [Eventos SQL](#eventos-sql)

---

<h2 id="resumen">🟩 Resumen</h2>
Este documento detalla el desarrollo y finalidad de **funciones**, **triggers** y **eventos SQL** en la base de datos **"Finca"**, los componentes clave para la automatización, control de integridad y generación automática de reportes.

Con estos bloques, la base logra:
- Automatizar procesos agrícolas.
- Mejorar la trazabilidad.
- Optimizar la gestión diaria de la información.

---

<h2 id="funciones-sql">🧮 Funciones SQL</h2>
Las funciones permiten realizar cálculos rápidos y reutilizables en consultas, reportes y procedimientos, añadiendo inteligencia y ahorro de tiempo.

**Cantidad:** 20 funciones personalizadas.

**Principales usos:**
- **Cálculos financieros:** utilidad por producto, margen bruto, ventas diarias, mensuales e históricas.
- **Consultas operativas:** stock disponible, clientes frecuentes, producto con más/menos stock.
- **Auditoría y monitorización:** último mantenimiento de maquinaria, diferencia con stock ideal, ventas por empleado.

**Aportes:**
- Generación de reportes dinámicos.
- Validaciones y comparaciones en tiempo real.
- Integración con vistas, procedimientos y eventos para cálculos automáticos.

---

<h2 id="triggers-disparadores">⚡ Triggers (Disparadores)</h2>
Reglas automáticas que se ejecutan ante cambios en las tablas. Protegen la integridad de los datos y generan auditoría sin intervención manual.

**Cantidad:** 20 triggers implementados.

**Principales usos:**
- **Automatización de inventario:** descuentan stock tras ventas, aumentan tras compras y previenen inventario negativo.
- **Auditoría y trazabilidad:** registran cambios en empleados, productos, precios, clientes, proveedores, ventas y mantenimientos.
- **Control de operaciones críticas:** validación de pagos negativos, marcado de maquinaria como inactiva según mantenimientos.
- **Generación de históricos:** de actualizaciones, eliminaciones e inserciones importantes.

**Aportes:**
- Mayor seguridad y confiabilidad.
- Histórico y rastreo de acciones clave.
- Automatización que ahorra tiempo y reduce errores humanos.

---

<h2 id="eventos-sql">⏰ Eventos SQL</h2>
Tareas programadas que se ejecutan automáticamente en la base de datos, sin intervención humana.

**Cantidad:** 20 eventos programados.

**Principales usos:**
- **Reportes periódicos:** ventas, mantenimiento, maquinaria inactiva, ingresos/egresos, clientes y productos destacados (mensual, diario y semanal).
- **Mantenimiento automático:** limpieza de auditorías, corrección de stocks negativos, actualización de precios y salarios.
- **Alertas:** por stock bajo, ventas altas, productos más vendidos, proveedores/clientes inactivos.
- **Actualizaciones automáticas:** inventario desde compras, eliminación de registros obsoletos.

**Aportes:**
- Mantenimiento y actualización continua.
- Generación de información clave para informes y decisiones.
- Evidencias automáticas para auditorías.

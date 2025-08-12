📑Funciones, Triggers y Eventos en el Proyecto “Finca”
Índice

Resumen

Funciones SQL

Triggers (Disparadores)

Eventos SQL

Cómo Consultar y Probar

🟩 Resumen
Este documento detalla el desarrollo y finalidad de funciones, triggers y eventos SQL en la base de datos "Finca", los componentes clave para la automatización, control de integridad y generación automática de reportes.
Con estos bloques, la base logra automatizar procesos agrícolas, mejorar la trazabilidad y optimizar la gestión diaria de la información.

🧮 Funciones SQL
Las funciones permiten realizar cálculos rápidos y reutilizables en consultas, reportes y procedimientos, añadiendo inteligencia y ahorro de tiempo.

20 funciones personalizadas, entre ellas:

Cálculos financieros, como utilidad por producto, margen bruto, ventas diarias, mensuales y históricas.

Consultas operativas, como stock disponible, clientes frecuentes, producto con más/menos stock.

Funciones de auditoría y monitorización, como último mantenimiento de maquinaria, diferencia con stock ideal, ventas de empleados.

Aportes:

Permiten generar reportes dinámicos y realizar validaciones/comparaciones en tiempo real.

Se integran fácilmente en vistas, procedimientos y eventos para automatizar cálculos.

⚡ Triggers (Disparadores)
Son reglas automáticas que se ejecutan ante cambios en las tablas, protegen la integridad de los datos y generan auditoría sin intervención manual.

20 triggers implementados, incluyen:

Automatización de inventario: Descuentan stock tras las ventas, lo aumentan tras compras y previenen inventario negativo.

Auditoría y trazabilidad: Registran cambios en empleados, productos, precios, clientes, proveedores, ventas, mantenimientos.

Control de operaciones críticas: Validan pagos negativos, marcan maquinaria como inactiva tras mantenimientos determinados.

Generan registros históricos: De actualizaciones, eliminaciones e inserciones importantes para el análisis posterior.

Aportes:

Mejoran la seguridad y confiabilidad.

Mantienen histórico y rastreo de acciones clave.

Automatizan la gestión diaria, ahorrando tiempo y evitando errores humanos.

⏰ Eventos SQL
Permiten programar tareas recurrentes en la base sin intervención humana, ideal para reportes, limpieza de datos, alertas y actualizaciones periódicas.

20 eventos programados como:

Reportes Mensuales, Diarios y Semanales: Ventas, mantenimiento, maquinaria inactiva, ingresos/egresos, clientes y productos top.

Mantenimiento automático: Limpieza de auditorías, corrección de stocks negativos, actualización de precios y salarios.

Alertas: Por stock bajo, ventas altas, productos más vendidos, proveedores/clientes inactivos.

Actualizaciones automáticas: Inventario desde compras, eliminación de registros obsoletos.

Aportes:

Garantizan el mantenimiento, actualización y seguridad de la información a lo largo del tiempo.

Generan información clave de manera automática, útil para informes, toma de decisiones y evidencias.

🛠️ Cómo Consultar y Probar
Usa los siguientes comandos para revisar cada componente:

Funciones:

text
SHOW FUNCTION STATUS WHERE Db = 'finca';
Consulta funciones disponibles.

Triggers:

text
SHOW TRIGGERS FROM finca;
Lista los disparadores creados.

Eventos:

text
SHOW EVENTS FROM finca;
Lista los eventos programados.

Recomendación:
Antes de usar eventos, asegúrate de activar el programador:

text
SET GLOBAL event_scheduler = ON;
🚀 Conclusión
Gracias a la integración de funciones, triggers, y eventos, el modelo de datos es mucho más automatizado, protegido y listo para la gestión agrícola moderna, la generación de reportes automáticos y la auditoría regulatoria y académica.
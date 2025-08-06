// backend/db.js
const mysql = require('mysql2');

const conexion = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'jhonm320429',        // cambia por tu contraseña si tienes
  database: 'finca'
});

conexion.connect((err) => {
  if (err) {
    console.error('Error de conexión:', err);
  } else {
    console.log('✅ Conectado a MySQL');
  }
});

module.exports = conexion;

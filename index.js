const express = require('express');
const cors = require('cors');
const path = require('path');
const db = require('./db');

const app = express();
app.use(express.json()); // 👈 Para que funcione req.body

const PORT = 3000;

app.use(cors());

// Servir archivos estáticos desde /public
app.use(express.static(path.join(__dirname, 'public')));

// Ruta API
app.get('/api/empleados', (req, res) => {
  db.query('SELECT * FROM usuarios', (err, resultados) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error en la base de datos' });
    }
    res.json(resultados);
  });
});

// POST /api/new/empleado
app.post('/api/new/empleado', (req, res) => {
  const { empleado,telefono,correo,rol } = req.body;

  if (!empleado || !telefono || !correo || !rol || rol === "0") {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' });
  }


  const sql = 'INSERT INTO empleados (nombre, telefono, correo, rol) VALUES (?,?,?,?)';
  db.query(sql, [empleado,telefono,correo,rol], (err, resultado) => {
    if (err) {
      // console.error('Error al insertar rol:', err);
      return res.status(500).json({ error: 'Error en la base de datos' });
    }
    res.status(201).json({ id: resultado.insertId, empleado, rol });
  });
});

// POST /api/new/rol
app.post('/api/new/rol', (req, res) => {
  const { rol } = req.body;

  if (!rol) {
    return res.status(400).json({ error: 'El campo "rol" es obligatorio' });
  }

  const sql = 'INSERT INTO roles (rol) VALUES (?)';
  db.query(sql, [rol], (err, resultado) => {
    if (err) {
      // console.error('Error al insertar rol:', err);
      return res.status(500).json({ error: 'Error en la base de datos' });
    }
    res.status(201).json({ id: resultado.insertId, rol });
  });
});

// Ruta /api/get_roles/
app.get('/api/get_roles/', (req, res) => {
  db.query('SELECT * FROM roles', (err, resultados) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error en la base de datos' });
    }
    res.json(resultados);
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en: http://localhost:${PORT}`);
});

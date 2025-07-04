const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

const app = express();
const port = 5000;

// Replace these values with your actual MySQL credentials
const db = mysql.createConnection({
  host: process.env.DB_HOST || 'mysql-service', // Use service name in K8s
  user: process.env.DB_USER || 'vijay',
  password: process.env.DB_PASSWORD || 'Password123',
  database: process.env.DB_NAME || 'appdb'
});

db.connect((err) => {
  if (err) {
    console.error('DB connection error:', err);
    process.exit(1);
  }
  console.log('Connected to MySQL database');

  db.query(
    `CREATE TABLE IF NOT EXISTS bookings (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100),
      travelingFrom VARCHAR(100),
      destination VARCHAR(100),
      food VARCHAR(100)
    )`,
    (err) => {
      if (err) throw err;
      console.log('Table ensured');
    }
  );
});

app.use(bodyParser.json());

app.post('/store', (req, res) => {
  const { name, travelingFrom, destination, food } = req.body;
  if (!name || !travelingFrom || !destination || !food) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  db.query(
    'INSERT INTO bookings (name, travelingFrom, destination, food) VALUES (?, ?, ?, ?)',
    [name, travelingFrom, destination, food],
    (err, result) => {
      if (err) {
        console.error('Insert error:', err);
        return res.status(500).json({ error: 'DB insert failed' });
      }
      res.json({ message: `Saved: ${name}`, id: result.insertId });
    }
  );
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});

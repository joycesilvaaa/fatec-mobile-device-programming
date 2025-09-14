const express = require('express');
const cors = require('cors');
const sqlite3 = require('sqlite3').verbose();

const app = express();
const PORT = 3001;
app.use(cors());
app.use(express.json());

const db = new sqlite3.Database('products.db');

// Cria tabela se não existir
db.run(`CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT,
  preco REAL,
  descricao TEXT
)`);

// GET /produtos
app.get('/produtos', (req, res) => {
  db.all('SELECT * FROM products', [], (err, rows) => {
    if (err) return res.status(500).json({error: err.message});
    res.json(rows);
  });
});

// Adicione rotas para inserir, atualizar e deletar se quiser manipular produtos via API

app.listen(PORT, () => console.log(`API rodando em http://localhost:${PORT}`));
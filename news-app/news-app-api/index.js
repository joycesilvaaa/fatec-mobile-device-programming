const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3003;
const DATA_FILE = 'news.json';

app.use(cors());
app.use(bodyParser.json());

// Helper: Load news
function loadNews() {
  if (!fs.existsSync(DATA_FILE)) return [];
  return JSON.parse(fs.readFileSync(DATA_FILE));
}

// GET /noticias
app.get('/noticias', (req, res) => {
  res.json(loadNews());
});

app.listen(PORT, () => console.log(`API rodando em http://localhost:${PORT}`));
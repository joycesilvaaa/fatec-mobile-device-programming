const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3002;
const DATA_FILE = 'contacts.json';

app.use(cors());
app.use(bodyParser.json());

// Helper: Load contacts
function loadContacts() {
  if (!fs.existsSync(DATA_FILE)) return [];
  return JSON.parse(fs.readFileSync(DATA_FILE));
}

// Helper: Save contacts
function saveContacts(contacts) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(contacts, null, 2));
}

// GET /contatos
app.get('/contatos', (req, res) => {
  res.json(loadContacts());
});

// POST /contatos
app.post('/contatos', (req, res) => {
  const contacts = loadContacts();
  const newContact = { id: Date.now(), ...req.body };
  contacts.push(newContact);
  saveContacts(contacts);
  res.status(201).json(newContact);
});

// PUT /contatos/:id
app.put('/contatos/:id', (req, res) => {
  const contacts = loadContacts();
  const id = parseInt(req.params.id);
  const idx = contacts.findIndex(c => c.id === id);
  if (idx === -1) return res.status(404).send();
  contacts[idx] = { ...contacts[idx], ...req.body };
  saveContacts(contacts);
  res.json(contacts[idx]);
});

// DELETE /contatos/:id
app.delete('/contatos/:id', (req, res) => {
  let contacts = loadContacts();
  const id = parseInt(req.params.id);
  contacts = contacts.filter(c => c.id !== id);
  saveContacts(contacts);
  res.status(204).send();
});

app.listen(PORT, () => console.log(`API rodando em http://localhost:${PORT}`));
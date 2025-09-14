const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3000;
const DATA_FILE = 'tasks.json';

app.use(cors());
app.use(bodyParser.json());

// Helper: Load tasks
function loadTasks() {
  if (!fs.existsSync(DATA_FILE)) return [];
  return JSON.parse(fs.readFileSync(DATA_FILE));
}

// Helper: Save tasks
function saveTasks(tasks) {
  fs.writeFileSync(DATA_FILE, JSON.stringify(tasks, null, 2));
}

// GET /tarefas
app.get('/tarefas', (req, res) => {
  res.json(loadTasks());
});

// POST /tarefas
app.post('/tarefas', (req, res) => {
  const tasks = loadTasks();
  const newTask = { id: Date.now(), ...req.body, concluida: false };
  tasks.push(newTask);
  saveTasks(tasks);
  res.status(201).json(newTask);
});

// PUT /tarefas/:id
app.put('/tarefas/:id', (req, res) => {
  const tasks = loadTasks();
  const id = parseInt(req.params.id);
  const idx = tasks.findIndex(t => t.id === id);
  if (idx === -1) return res.status(404).send();
  tasks[idx] = { ...tasks[idx], ...req.body };
  saveTasks(tasks);
  res.json(tasks[idx]);
});

// DELETE /tarefas/:id
app.delete('/tarefas/:id', (req, res) => {
  let tasks = loadTasks();
  const id = parseInt(req.params.id);
  tasks = tasks.filter(t => t.id !== id);
  saveTasks(tasks);
  res.status(204).send();
});

app.listen(PORT, () => console.log(`API rodando em http://localhost:${PORT}`));
/**
 * Task Manager API
 * -----------------
 * A tiny in-memory REST API that acts as the "system under test" for this
 * repository. It intentionally exposes a full CRUD surface plus basic
 * validation and error responses so it can be exercised realistically by
 * every testing tool in this project (Postman/Newman, SoapUI, Karate,
 * JMeter, Artillery, Gatling).
 */

const express = require('express');
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

let tasks = [];
let nextId = 1;

function findTask(id) {
  return tasks.find((t) => t.id === Number(id));
}

// Health check - used by CI to know when the server is ready
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', tasksInMemory: tasks.length });
});

// List all tasks
app.get('/api/tasks', (req, res) => {
  res.status(200).json(tasks);
});

// Get a single task
app.get('/api/tasks/:id', (req, res) => {
  const task = findTask(req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  res.status(200).json(task);
});

// Create a task
app.post('/api/tasks', (req, res) => {
  const { title, completed } = req.body || {};
  if (!title || typeof title !== 'string') {
    return res.status(400).json({ error: 'title is required and must be a string' });
  }
  const task = {
    id: nextId++,
    title,
    completed: Boolean(completed) || false,
    createdAt: new Date().toISOString(),
  };
  tasks.push(task);
  res.status(201).json(task);
});

// Update a task
app.put('/api/tasks/:id', (req, res) => {
  const task = findTask(req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  const { title, completed } = req.body || {};
  if (title !== undefined) task.title = title;
  if (completed !== undefined) task.completed = Boolean(completed);
  task.updatedAt = new Date().toISOString();
  res.status(200).json(task);
});

// Delete a task
app.delete('/api/tasks/:id', (req, res) => {
  const index = tasks.findIndex((t) => t.id === Number(req.params.id));
  if (index === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }
  tasks.splice(index, 1);
  res.status(204).send();
});

// Reset endpoint - handy for repeatable test runs in CI/load tests
app.post('/api/tasks/reset', (req, res) => {
  tasks = [];
  nextId = 1;
  res.status(200).json({ status: 'reset' });
});

app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`Task Manager API listening on http://localhost:${PORT}`);
});

module.exports = app;

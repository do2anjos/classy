const express = require('express');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const app = express();
const PORT = process.env.PORT || 3000;

// Conectar ao banco de dados
const db = new sqlite3.Database('./poo.db', (err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err.message);
  } else {
    console.log('✅ Conectado ao banco de dados SQLite.');
  }
});

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// Rotas de páginas (navegação)
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));
app.get('/login-aluno', (req, res) => res.sendFile(path.join(__dirname, 'public', 'login-aluno.html')));
app.get('/perfil', (req, res) => res.sendFile(path.join(__dirname, 'public', 'perfil.html')));
app.get('/home', (req, res) => res.sendFile(path.join(__dirname, 'public', 'home.html')));
app.get('/forum', (req, res) => res.sendFile(path.join(__dirname, 'public', 'forum.html')));
app.get('/aulas', (req, res) => res.sendFile(path.join(__dirname, 'public', 'aulas.html')));
app.get('/exerci', (req, res) => res.sendFile(path.join(__dirname, 'public', 'exercicios.html')));
app.get('/ranking', (req, res) => res.sendFile(path.join(__dirname, 'public', 'ranking.html')));
app.get('/certificados', (req, res) => res.sendFile(path.join(__dirname, 'public', 'certificados.html')));

// 🔽 Rotas de API (exemplos)
app.post('/api/login', (req, res) => {
  const { email, senha } = req.body;
  db.get(`SELECT * FROM aluno WHERE email = ? AND senha = ?`, [email, senha], (err, row) => {
    if (err) return res.status(500).json({ error: err.message });
    if (row) {
      res.json({ success: true, aluno: row });
    } else {
      res.status(401).json({ success: false, message: 'Credenciais inválidas' });
    }
  });
});

app.get('/api/alunos', (req, res) => {
  db.all('SELECT id, nome, email FROM aluno', (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

app.get('/api/certificados/:alunoId', (req, res) => {
  const alunoId = req.params.alunoId;
  const sql = `
    SELECT certificado.nome, certificado.data_emissao
    FROM certificado
    INNER JOIN aluno_certificado ON certificado.id = aluno_certificado.certificado_id
    WHERE aluno_certificado.aluno_id = ?
  `;
  db.all(sql, [alunoId], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

app.get('/api/ranking', (req, res) => {
  const sql = `
    SELECT aluno.nome, SUM(resposta.pontuacao) AS total_pontos
    FROM resposta
    INNER JOIN aluno ON resposta.aluno_id = aluno.id
    GROUP BY aluno.id
    ORDER BY total_pontos DESC
    LIMIT 10
  `;
  db.all(sql, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando em http://localhost:${PORT}`);
});

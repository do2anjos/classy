PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  senha TEXT NOT NULL,
  matricula TEXT UNIQUE,
  telefone TEXT,
  foto_perfil TEXT,
  pontos INTEGER DEFAULT 0,
  turma TEXT,
  tipo TEXT CHECK(tipo IN ('aluno', 'professor', 'admin')),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS disciplinas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  descricao TEXT,
  carga_horaria INTEGER,
  icone TEXT
);

CREATE TABLE IF NOT EXISTS aulas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  disciplina_id INTEGER NOT NULL,
  titulo TEXT NOT NULL,
  descricao TEXT,
  conteudo TEXT NOT NULL,
  video_url TEXT,
  ordem INTEGER,
  duracao INTEGER,
  FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS progresso_aulas (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  aula_id INTEGER NOT NULL,
  concluido BOOLEAN DEFAULT 0,
  data_conclusao TIMESTAMP,
  progresso INTEGER DEFAULT 0,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  FOREIGN KEY (aula_id) REFERENCES aulas(id),
  UNIQUE(usuario_id, aula_id)
);

CREATE TABLE IF NOT EXISTS exercicios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  aula_id INTEGER NOT NULL,
  titulo TEXT NOT NULL,
  enunciado TEXT NOT NULL,
  tipo TEXT CHECK(tipo IN ('multipla_escolha', 'verdadeiro_falso', 'codigo', 'texto_livre')),
  dificuldade TEXT CHECK(dificuldade IN ('facil', 'medio', 'dificil')),
  resposta_correta TEXT NOT NULL,
  FOREIGN KEY (aula_id) REFERENCES aulas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS forum_posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  titulo TEXT NOT NULL,
  conteudo TEXT NOT NULL,
  data_postagem TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE IF NOT EXISTS certificados (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  titulo TEXT NOT NULL,
  disciplina TEXT NOT NULL,
  data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

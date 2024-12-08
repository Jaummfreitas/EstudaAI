import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
static final DatabaseHelper instance = DatabaseHelper._init();
static Database? _database;

DatabaseHelper._init();

Future<Database> get database async {
  if (_database != null) return _database!;

  _database = await _initDB('estudeai.db');
  return _database!;
}

Future<Database> _initDB(String fileName) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, fileName);

  return await openDatabase(
    path,
    version: 2,
    onCreate: _createDB,
    onUpgrade: _onUpgrade,
  );
}

Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE User ADD COLUMN user_email TEXT');
  }
}

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT NOT NULL,
        user_password TEXT NOT NULL,
        user_email TEXT NOT NULL,
        user_status INTEGER NOT NULL CHECK (user_status IN (0, 1))
      );
    ''');

  await db.execute('''
    CREATE TABLE Evento (
      evento_id INTEGER PRIMARY KEY AUTOINCREMENT,
      evento_name TEXT NOT NULL,
      evento_descricao TEXT,
      evento_date TEXT NOT NULL,
      evento_time TEXT NOT NULL,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES User(user_id)
    );
  ''');

  await db.execute('''
    CREATE TABLE Amigos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id_1 INTEGER,
      user_id_2 INTEGER,
      data_inicio TEXT NOT NULL,
      FOREIGN KEY (user_id_1) REFERENCES User(user_id),
      FOREIGN KEY (user_id_2) REFERENCES User(user_id)
    );
  ''');

    await db.execute('''
      CREATE TABLE Quizzes (
        quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tema TEXT NOT NULL,
        valor INTEGER NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE Pergunta (
        pergunta_id INTEGER PRIMARY KEY AUTOINCREMENT,
        pergunta TEXT NOT NULL,
        id_resposta_correta INTEGER,
        valor INTEGER NOT NULL,
        id_quiz INTEGER,
        FOREIGN KEY (id_resposta_correta) REFERENCES Alternativas(alternativa_id)
        FOREIGN KEY (id_quiz) REFERENCES Quizzes(quiz_id)
      );
    ''');

  await db.execute('''
    CREATE TABLE Alternativas (
      alternativa_id INTEGER PRIMARY KEY AUTOINCREMENT,
      pergunta_id INTEGER,
      conteudo TEXT NOT NULL,
      FOREIGN KEY (pergunta_id) REFERENCES Pergunta(pergunta_id)
    );
  ''');

  await db.execute('''
    CREATE TABLE User_quizzes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      user_id INTEGER,
      nota INTEGER NOT NULL,
      FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id),
      FOREIGN KEY (user_id) REFERENCES User(user_id)
    );
  ''');
}

Future close() async {
  final db = _database;
  if (db != null) {
    await db.close();
  }
}
}
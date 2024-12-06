import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:estudeai/Views/Service/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class QuizService {
  static final QuizService instance = QuizService._init();
  int idUsuario = SessionManager().userId!;

  QuizService._init();

  Future<void> createQuiz(
      String nome, String tema, int valor, String quantidade) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'Quizzes',
      {
        'nome': nome,
        'tema': tema,
        'valor': valor,
      },
    );

    int quant = int.parse(quantidade);

    criarPerguntasGenericas(valor, quant);
    await associarUsuarioAoQuiz();
  }

  Future<void> criarPerguntasGenericas(int valor, int quantidade) async {
    final db = await DatabaseHelper.instance.database;
    for (int i = 1; i <= quantidade; i++) {
      int perguntaId = await db.insert(
        'Pergunta',
        {
          'pergunta': 'Pergunta genérica $i',
          'id_resposta_correta': null,
          'valor': valor,
          'id_quiz': await db
              .rawQuery("SELECT MAX(quiz_id) as id FROM Quizzes")
              .then((res) => res.first['id']), // Vincula ao último quiz criado
        },
      );

      int alternativaCorretaId = -1;
      for (int j = 1; j <= 4; j++) {
        int alternativaId = await db.insert(
          'Alternativas',
          {
            'pergunta_id': perguntaId,
            'conteudo': 'Alternativa $j para Pergunta $i',
          },
        );

        if (j == 1) {
          alternativaCorretaId = alternativaId;
        }
      }

      await db.update(
        'Pergunta',
        {'id_resposta_correta': alternativaCorretaId},
        where: 'pergunta_id = ?',
        whereArgs: [perguntaId],
      );
    }
  }

  Future<void> associarUsuarioAoQuiz() async {
    final db = await DatabaseHelper.instance.database;

    int quizId = await db
        .rawQuery("SELECT MAX(quiz_id) as id FROM Quizzes")
        .then((res) => (res.first['id'] as int?) ?? 0);

    await db.insert(
      'User_quizzes',
      {
        'quiz_id': quizId,
        'user_id': idUsuario,
        'nota': -1,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getQuestionsByQuizId(int quizId) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> questions = await db.query(
      'Pergunta',
      where: 'id_quiz = ?',
      whereArgs: [quizId],
    );

    return questions;
  }

  Future<List<Map<String, dynamic>>> getAlternativesByQuestionId(
      int questionId) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> alternatives = await db.query(
      'Alternativas',
      where: 'pergunta_id = ?',
      whereArgs: [questionId],
    );

    return alternatives;
  }

  Future<List<Map<String, dynamic>>> getQuizzesByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> userQuizzes = await db.rawQuery('''
    SELECT q.*
    FROM Quizzes q
    INNER JOIN User_quizzes uq ON q.quiz_id = uq.quiz_id
    WHERE uq.user_id = ?
  ''', [userId]);

    return userQuizzes;
  }

  Future<String> getAlternativeTextById(int alternativeId) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> result = await db.query(
      'Alternativas',
      columns: ['conteudo'],
      where: 'alternativa_id = ?',
      whereArgs: [alternativeId],
    );

    return result.isNotEmpty
        ? result.first['conteudo']
        : 'Alternativa não encontrada';
  }

  Future<void> deleteQuizById(int quizId) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      await txn.delete(
        'Alternativas',
        where:
            'pergunta_id IN (SELECT pergunta_id FROM Pergunta WHERE id_quiz = ?)',
        whereArgs: [quizId],
      );

      await txn.delete(
        'Pergunta',
        where: 'id_quiz = ?',
        whereArgs: [quizId],
      );

      await txn.delete(
        'User_quizzes',
        where: 'quiz_id = ?',
        whereArgs: [quizId],
      );

      await txn.delete(
        'Quizzes',
        where: 'quiz_id = ?',
        whereArgs: [quizId],
      );
    });
  }

  Future<void> saveQuizScore(int quizId, int userId, double score) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'User_quizzes',
      {'nota': score.toInt()},
      where: 'quiz_id = ? AND user_id = ?',
      whereArgs: [quizId, userId],
    );
  }

  Future<int?> getQuizScore(int quizId, int userId) async {
    final db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> result = await db.query(
      'User_quizzes',
      columns: ['nota'],
      where: 'quiz_id = ? AND user_id = ?',
      whereArgs: [quizId, userId],
    );

    return result.isNotEmpty ? result.first['nota'] as int? : null;
  }
}

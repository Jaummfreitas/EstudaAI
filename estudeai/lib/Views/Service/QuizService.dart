import 'package:estudeai/Views/Service/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class QuizService {
  static final QuizService instance = QuizService._init();
  int idUsuario = 1;

  QuizService._init();

  Future<void> createQuiz(
      String nome, String tema, int nivel, int valor, String quantidade) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'Quizzes',
      {
        'nome': nome,
        'tema': tema,
        'nivel': nivel,
        'valor': valor,
      },
    );

    int quant = int.parse(quantidade);

    criarPerguntasGenericas(nivel, valor, quant);
    await associarUsuarioAoQuiz();
  }

  Future<void> criarPerguntasGenericas(
      int nivel, int valor, int quantidade) async {
    final db = await DatabaseHelper.instance.database;
    for (int i = 1; i <= quantidade; i++) {
      int perguntaId = await db.insert(
        'Pergunta',
        {
          'pergunta': 'Pergunta genérica $i para nível $nivel',
          'nivel': nivel,
          'id_resposta_correta': null, // Temporariamente null
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

        // Defina uma alternativa correta (por exemplo, a primeira alternativa)
        if (j == 1) {
          alternativaCorretaId = alternativaId;
        }
      }

      // Atualize a pergunta com o ID da alternativa correta
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

    // Obtenha o ID do último quiz criado
    int quizId = await db
        .rawQuery("SELECT MAX(quiz_id) as id FROM Quizzes")
        .then((res) => (res.first['id'] as int?) ?? 0);

    // Insira a associação do usuário com o quiz na tabela `User_quizzes`
    await db.insert(
      'User_quizzes',
      {
        'quiz_id': quizId,
        'user_id': idUsuario, // ID do usuário base que você mencionou
        'nota':
            -1, // Nota inicial (pode ser alterada depois de completar o quiz)
      },
    );
  }

  Future<List<Map<String, dynamic>>> getQuestionsByQuizId(int quizId) async {
    final db = await DatabaseHelper.instance.database;

    // Consulta para recuperar as perguntas associadas a um quiz
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

    // Consulta para recuperar as alternativas associadas a uma pergunta
    List<Map<String, dynamic>> alternatives = await db.query(
      'Alternativas',
      where: 'pergunta_id = ?',
      whereArgs: [questionId],
    );

    return alternatives;
  }

  Future<List<Map<String, dynamic>>> getQuizzesByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;

    // Consulta para recuperar os quizzes associados a um usuário
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

    // Consulta para pegar o texto da alternativa com base no ID
    List<Map<String, dynamic>> result = await db.query(
      'Alternativas',
      columns: ['conteudo'],
      where: 'alternativa_id = ?',
      whereArgs: [alternativeId],
    );

    // Retorna o texto da alternativa ou uma string vazia se não encontrado
    return result.isNotEmpty
        ? result.first['conteudo']
        : 'Alternativa não encontrada';
  }

  Future<void> deleteQuizById(int quizId) async {
    final db = await DatabaseHelper.instance.database;

    // Inicia uma transação para garantir que todas as operações sejam atômicas
    await db.transaction((txn) async {
      // Remove as alternativas das perguntas do quiz
      await txn.delete(
        'Alternativas',
        where:
            'pergunta_id IN (SELECT pergunta_id FROM Pergunta WHERE id_quiz = ?)',
        whereArgs: [quizId],
      );

      // Remove as perguntas do quiz
      await txn.delete(
        'Pergunta',
        where: 'id_quiz = ?',
        whereArgs: [quizId],
      );

      // Remove a relação do usuário com o quiz
      await txn.delete(
        'User_quizzes',
        where: 'quiz_id = ?',
        whereArgs: [quizId],
      );

      // Remove o quiz
      await txn.delete(
        'Quizzes',
        where: 'quiz_id = ?',
        whereArgs: [quizId],
      );
    });
  }

  Future<void> saveQuizScore(int quizId, int userId, double score) async {
    final db = await DatabaseHelper.instance.database;

    // Atualiza a nota do usuário para o quiz específico
    await db.update(
      'User_quizzes',
      {'nota': score.toInt()}, // Armazena a pontuação como um inteiro
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

    // Retorna a nota ou null se não houver
    return result.isNotEmpty ? result.first['nota'] as int? : null;
  }
}

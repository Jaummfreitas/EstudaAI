import 'package:estudeai/Views/Quiz/quiz.dart';
import 'package:estudeai/Views/Service/QuizService.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  final int quizId;
  final int userId;
  final double score;
  final List<String?> selectedAnswers;
  final List<String> correctAnswers;

  QuizResultPage(
      {required this.quizId,
      required this.userId,
      required this.score,
      required this.selectedAnswers,
      required this.correctAnswers});

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late Future<List<String?>> convertedSelectedAnswers;

  @override
  void initState() {
    super.initState();
    convertedSelectedAnswers = _convertIdsToText(widget.selectedAnswers);
    _saveScore();
  }

  Future<void> _saveScore() async {
    await QuizService.instance
        .saveQuizScore(widget.quizId, widget.userId, widget.score);
  }

  Future<List<String?>> _convertIdsToText(List<String?> answerIds) async {
    List<String?> answerTexts = [];
    for (var id in answerIds) {
      if (id != null && RegExp(r'^\d+$').hasMatch(id)) {
        String text =
            await QuizService.instance.getAlternativeTextById(int.parse(id));
        answerTexts.add(text);
      } else {
        answerTexts.add('Não respondida'); // Caso não seja um ID válido
      }
    }
    return answerTexts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'RESULTADO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você acertou ${widget.score.toStringAsFixed(2)}% das questões!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Expanded(
              child: FutureBuilder<List<String?>>(
                future: convertedSelectedAnswers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar respostas.'));
                  }

                  final selectedAnswersText = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: widget.correctAnswers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Questão ${index + 1}:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                    'Sua resposta: ${selectedAnswersText[index] ?? "Não respondida"}'),
                                Text(
                                    'Resposta correta: ${widget.correctAnswers[index]}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                    (route) => false, // Remove todas as rotas anteriores
                  );
                },
                child: Text(
                  'Voltar',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

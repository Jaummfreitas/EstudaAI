import 'dart:ffi';

import 'package:estudeai/Views/Service/QuizService.dart';
import 'package:flutter/material.dart';
import 'quiz.dart';
import 'quiz_result_page.dart';

class QuizDetailPage extends StatefulWidget {
  final Quiz quiz;

  QuizDetailPage({required this.quiz});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  List<Map<String, dynamic>> questions = [];
  Map<int, List<Map<String, dynamic>>> alternatives = {};
  List<String?> selectedAnswers = [];
  List<String> correctAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    selectedAnswers = [];
    correctAnswers = [];
    alternatives = {};

    final loadedQuestions =
        await QuizService.instance.getQuestionsByQuizId(widget.quiz.quizId);
    List<String?> tempSelectedAnswers =
        List<String?>.filled(loadedQuestions.length, null);
    List<String> tempCorrectAnswers = [];
    Map<int, List<Map<String, dynamic>>> tempAlternatives = {};

    for (var question in loadedQuestions) {
      int questionId = question['pergunta_id'];
      tempCorrectAnswers.add(question['id_resposta_correta'].toString());

      final loadedAlternatives =
          await QuizService.instance.getAlternativesByQuestionId(questionId);
      tempAlternatives[questionId] = loadedAlternatives;
    }

    setState(() {
      questions = loadedQuestions;
      selectedAnswers = tempSelectedAnswers;
      correctAnswers = tempCorrectAnswers;
      alternatives = tempAlternatives;
    });
  }

  void _selectAnswer(int questionIndex, String answer) {
    setState(() {
      selectedAnswers[questionIndex] = answer;
    });
  }

  Future<double> _calculateScore() async {
    int correct = 0;
    List<String> tempCorrectAnswersText = [];

    for (int i = 0; i < questions.length; i++) {
      int correctAlternativeId = int.parse(correctAnswers[i]);
      String correctText = await QuizService.instance
          .getAlternativeTextById(correctAlternativeId);
      tempCorrectAnswersText.add(correctText);

      if (selectedAnswers[i] != null) {
        String selectedText = await QuizService.instance
            .getAlternativeTextById(int.parse(selectedAnswers[i]!));
        if (selectedText == correctText) {
          correct++;
        }
      }
    }

    setState(() {
      correctAnswers = tempCorrectAnswersText;
    });

    return (correct / questions.length) * 100;
  }

  void _showResult() async {
    double finalScore = await _calculateScore();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultPage(
          quizId: widget.quiz.quizId,
          userId: 1,
          score: finalScore,
          selectedAnswers: selectedAnswers,
          correctAnswers: correctAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quiz.name,
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
        child: questions.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Mostra um carregando enquanto os dados não são carregados
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tema: ${widget.quiz.theme}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final questionId = question['pergunta_id'];
                        final questionAlternatives =
                            alternatives[questionId] ?? [];

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
                                    'Questão ${index + 1}: ${question['pergunta']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ...questionAlternatives.map((alt) {
                                    return RadioListTile<String>(
                                      title: Text(alt['conteudo']),
                                      value: alt['alternativa_id'].toString(),
                                      groupValue: selectedAnswers[index],
                                      onChanged: (value) {
                                        _selectAnswer(index, value!);
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _showResult,
                      child: Text(
                        'Finalizar Quiz',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

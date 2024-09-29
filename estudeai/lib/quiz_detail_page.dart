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
  // Lista para armazenar as respostas escolhidas em cada questão
  List<String?> selectedAnswers = [];
  List<String> correctAnswers = [];

  @override
  void initState() {
    super.initState();
    // Inicializando a lista com valores nulos para cada questão
    selectedAnswers = List<String?>.filled(widget.quiz.questionsCount, null);
    correctAnswers = List<String>.filled(widget.quiz.questionsCount, 'A: 1000');
  }

  // Função para definir a resposta selecionada para cada questão
  void _selectAnswer(int questionIndex, String answer) {
    setState(() {
      selectedAnswers[questionIndex] = answer;
    });
  }

  double _calculateScore() {
    int correct = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        correct++;
      }
    }
    return (correct / widget.quiz.questionsCount) * 100;
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultPage(
          score: _calculateScore(),
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
          style: TextStyle(color: Colors.white),
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
              'Tema: ${widget.quiz.theme}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: widget.quiz.questionsCount, // Quantidade de questões
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
                              'Questão ${index + 1}: Qual o resultado da soma : 500 + 500',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // RadioListTile para cada alternativa
                            RadioListTile<String>(
                              title: const Text('A: 1000'),
                              value: 'A: 1000',
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                _selectAnswer(index, value!);
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('B: 20000'),
                              value: 'B: 20000',
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                _selectAnswer(index, value!);
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('C: 300000'),
                              value: 'C: 300000',
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                _selectAnswer(index, value!);
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('D: 4000000'),
                              value: 'D: 4000000',
                              groupValue: selectedAnswers[index],
                              onChanged: (value) {
                                _selectAnswer(index, value!);
                              },
                            ),
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

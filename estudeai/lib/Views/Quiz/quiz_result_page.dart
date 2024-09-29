import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  final double score;
  final List<String?> selectedAnswers;
  final List<String> correctAnswers;

  QuizResultPage(
      {required this.score,
      required this.selectedAnswers,
      required this.correctAnswers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              'Você acertou ${score.toStringAsFixed(2)}% das questões!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: correctAnswers.length,
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                                'Sua resposta: ${selectedAnswers[index] ?? "Não respondida"}'),
                            Text('Resposta correta: ${correctAnswers[index]}'),
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
                onPressed: () {
                  Navigator.pop(context); // Voltar para a tela anterior
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

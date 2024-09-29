import 'package:estudeai/Views/Calendario/calendario.dart';
import 'package:estudeai/Views/Home/home.dart';
import 'package:estudeai/Views/Perfil/perfil.dart';
import 'package:flutter/material.dart';
import 'quiz_detail_page.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizPage(),
    );
  }
}

class Quiz {
  final String name;
  final String theme;
  final int questionsCount;

  Quiz({
    required this.name,
    required this.theme,
    required this.questionsCount,
  });
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Quiz> quizzes = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  final TextEditingController questionsCountController =
      TextEditingController();

  void _createQuiz() {
    if (nameController.text.isNotEmpty &&
        themeController.text.isNotEmpty &&
        questionsCountController.text.isNotEmpty) {
      setState(() {
        quizzes.add(
          Quiz(
            name: nameController.text,
            theme: themeController.text,
            questionsCount: int.parse(questionsCountController.text),
          ),
        );
      });
      nameController.clear();
      themeController.clear();
      questionsCountController.clear();
    }
  }

  void _goToQuiz(Quiz quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailPage(quiz: quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QUIZZES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: Text('Home Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: Text('Calendário'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gerar Quiz',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                floatingLabelStyle: TextStyle(color: Colors.teal),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: themeController,
              decoration: InputDecoration(
                labelText: 'Tema',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                floatingLabelStyle: TextStyle(color: Colors.teal),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: questionsCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade de Questões',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                floatingLabelStyle: TextStyle(color: Colors.teal),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _createQuiz,
                child: Text(
                  'CRIAR',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Meus Quizzes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                ),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return GestureDetector(
                    onTap: () => _goToQuiz(quiz),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(quiz.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

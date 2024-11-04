import 'package:estudeai/Views/Calendario/calendario.dart';
import 'package:estudeai/Views/Home/home.dart';
import 'package:estudeai/Views/Perfil/perfil.dart';
import 'package:estudeai/Views/Service/QuizService.dart';
import 'package:estudeai/Views/Service/SessionManager.dart';
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
  final int quizId;
  final String name;
  final String theme;
  final int questionsCount;

  Quiz({
    required this.quizId,
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
  @override
  void initState() {
    super.initState();
    _loadUserQuizzes();
  }

  List<Map<String, dynamic>> quizzes = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController themeController = TextEditingController();
  final TextEditingController questionsCountController =
      TextEditingController();
  final quizHelper = QuizService.instance;

  void _loadUserQuizzes() async {
    final userId = SessionManager().userId as int;
    final userQuizzes = await quizHelper.getQuizzesByUserId(userId);
    setState(() {
      quizzes = userQuizzes;
    });
  }

  void _createQuiz() async {
    if (nameController.text.isNotEmpty &&
        themeController.text.isNotEmpty &&
        questionsCountController.text.isNotEmpty) {
      await quizHelper.createQuiz(nameController.text, themeController.text, 1,
          10, questionsCountController.text);
      _loadUserQuizzes();
      nameController.clear();
      themeController.clear();
      questionsCountController.clear();
    }
  }

  void _confirmDeleteQuiz(int quizId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover Quiz'),
        content: Text('Tem certeza de que deseja remover este quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Fecha o diálogo
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await quizHelper.deleteQuizById(quizId);
              Navigator.pop(context); // Fecha o diálogo
              _loadUserQuizzes(); // Atualiza a lista de quizzes
            },
            child: Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _goToQuiz(Map<String, dynamic> quizData) {
    // Cria uma instância de Quiz com base nos dados do Map
    Quiz quiz = Quiz(
      quizId: quizData['quiz_id'],
      name: quizData['nome'],
      theme: quizData['tema'],
      questionsCount: quizData['questions_count'] ??
          0, // Certifique-se de que esse campo existe
    );

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
                  return FutureBuilder<int?>(
                    future: quizHelper.getQuizScore(
                        quiz['quiz_id'], 1), // Passa o ID do usuário
                    builder: (context, snapshot) {
                      String? nota;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        nota = 'Carregando...';
                      } else if (snapshot.hasData && snapshot.data != -1) {
                        nota = 'Nota: ${snapshot.data}';
                      } else {
                        nota = null; // Não exibir se for -1 ou não houver nota
                      }

                      return GestureDetector(
                        onTap: () => _goToQuiz(quiz),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(quiz['nome']),
                                    if (nota != null) ...[
                                      SizedBox(height: 8),
                                      Text(nota,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _confirmDeleteQuiz(quiz['quiz_id']),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

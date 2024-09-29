import 'package:estudeai/Views/Quiz/quiz.dart';
import 'package:estudeai/Views/Calendario/calendario.dart';
import 'package:flutter/material.dart';
import 'package:estudeai/Views/Perfil/perfil.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ESTUDE.AI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: <Widget>[
              _buildOptionCard(
                context,
                'Quiz',
                Icons.quiz,
                Colors.teal,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                'Calendário',
                Icons.calendar_today,
                Colors.teal,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarPage()),
                  );
                },
              ),
              _buildOptionCard(
                context,
                'Perfil',
                Icons.account_circle,
                Colors.teal,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para criar cada card de opção
  Widget _buildOptionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

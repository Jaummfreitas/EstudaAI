import 'package:flutter/material.dart';

class DefinicoesPage extends StatelessWidget {
const DefinicoesPage({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF26A69A),
      title: const Text(
        'Sobre o App',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Estude.AI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26A69A),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Versão 1.4.0',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          const InfoCard(
            title: 'Sobre',
            content: 'O Estude AI é um aplicativo desenvolvido para auxiliar estudantes em sua jornada acadêmica, oferecendo ferramentas de organização e estudo. Nós acreditamos que a melhor forma de aprendizado é a prática, então ao acessar Quizzes em nossa Home Page, é possível criar um Quiz de perguntas sobre qualquer assunto desejado. Outro pilar do aprendizado é a organização, então ao acessar Calendário, é possível salvar datas importantes e se programar nos estudos.',
          ),
          const SizedBox(height: 20),
          const InfoCard(
            title: 'Desenvolvedores',
            content: 'Desenvolvido por estudantes da PUC-Minas como projeto da disciplina de Laboratório de Desenvolvimento de Dispositivos Móveis.',
          ),
          const SizedBox(height: 20),
          const InfoCard(
            title: 'Contato',
            content: 'Email: suporte@estudeai.com\nSite: www.estudeai.com',
          ),
        ],
      ),
    ),
  );
}
}

class InfoCard extends StatelessWidget {
final String title;
final String content;

const InfoCard({
  Key? key,
  required this.title,
  required this.content,
}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26A69A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
}
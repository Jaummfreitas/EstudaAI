import 'package:flutter/material.dart';

class DefinicoesPage extends StatefulWidget {
  const DefinicoesPage({Key? key}) : super(key: key);

  @override
  _DefinicoesPageState createState() => _DefinicoesPageState();
}

class _DefinicoesPageState extends State<DefinicoesPage> {
  bool notificationsEnabled = false;
  bool vibrationEnabled = false;
  String selectedLanguage = 'Português';

  final List<String> languages = ['Português', 'Inglês', 'Espanhol'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF26A69A),
        title: const Text(
          'Definições',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notificações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SwitchListTile(
                title: const Text('Ativar Notificações'),
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Vibração',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SwitchListTile(
                title: const Text('Ativar Vibração'),
                value: vibrationEnabled,
                onChanged: (bool value) {
                  setState(() {
                    vibrationEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Idioma',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: languages.map<DropdownMenuItem<String>>((String lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

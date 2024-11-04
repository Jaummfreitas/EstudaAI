import 'package:flutter/material.dart';
import '../Service/db_helper_amigos.dart';

class AddFriendsPage extends StatelessWidget {
  const AddFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF26A69A),
        title: const Text(
          'Adicionar Amigos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Nome',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite o nome do amigo',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;

                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, preencha todos os campos.'),
                      ),
                    );
                    return; 
                  }

                  final amigosDB = AmigosDatabaseHelper.instance;
                  final amigo = Amigos(
                    userId1: 1, 
                    userId2: 2, 
                    dataInicio: DateTime.now().toIso8601String(), 
                  );
                  await amigosDB.insertFriend(amigo);
                  nameController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Amigo $name adicionado com sucesso!'),
                    ),
                  );
                },
                child: const Text('Adicionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A), 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), 
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

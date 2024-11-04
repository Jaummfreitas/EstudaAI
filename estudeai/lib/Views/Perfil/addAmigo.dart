import 'package:flutter/material.dart';

class AddFriendsPage extends StatelessWidget {
  const AddFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

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
        color: Colors.white, // Cor de fundo igual às outras páginas
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
            const SizedBox(height: 16),
            const Text(
              'Email',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite o e-mail do amigo',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String email = emailController.text;

                  // Aqui você pode adicionar a lógica para adicionar o amigo,
                  // como chamar um método para salvar no banco de dados ou na lista.

                  // Exemplo:
                  // addFriend(name, email);

                  // Limpar os campos após adicionar
                  nameController.clear();
                  emailController.clear();

                  // Você pode adicionar lógica adicional aqui, se necessário
                },
                child: const Text('Adicionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A), // Cor do botão
                  foregroundColor: Colors.white, // Cor do texto do botão
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding do botão
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

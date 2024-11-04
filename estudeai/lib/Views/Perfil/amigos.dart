import 'package:flutter/material.dart';

class Friend {
  final String name;
  final String email;
  final String photoUrl;

  Friend({required this.name, required this.email, required this.photoUrl});
}

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de amigos
    final List<Friend> friends = [
      Friend(name: 'Amigo 1', email: 'amigo1@example.com', photoUrl: 'assets/images/friend1.jpg'),
      Friend(name: 'Amigo 2', email: 'amigo2@example.com', photoUrl: 'assets/images/friend2.jpg'),
      Friend(name: 'Amigo 3', email: 'amigo3@example.com', photoUrl: 'assets/images/friend3.jpg'),
      Friend(name: 'Amigo 4', email: 'amigo4@example.com', photoUrl: 'assets/images/friend4.jpg'),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF26A69A),
        title: const Text(
          'Lista de Amigos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white, // Cor de fundo igual à ProfilePage
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Espaçamento entre os amigos
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30, // Aumenta o tamanho da imagem
                    backgroundImage: AssetImage(friends[index].photoUrl), // Adiciona a foto do amigo
                  ),
                  const SizedBox(width: 16), // Espaço entre a imagem e o texto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinha o texto à esquerda
                    children: [
                      Text(
                        friends[index].name,
                        style: const TextStyle(fontSize: 20), // Aumenta o tamanho da fonte do nome
                      ),
                      Text(
                        friends[index].email,
                        style: const TextStyle(fontSize: 16, color: Colors.grey), // Aumenta o tamanho da fonte do e-mail
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

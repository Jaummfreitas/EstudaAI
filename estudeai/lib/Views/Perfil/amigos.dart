import 'package:flutter/material.dart';
import '../Service/db_helper_amigos.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  late Future<List<Amigos>> friendsFuture;

  @override
  void initState() {
    super.initState();
    friendsFuture = AmigosDatabaseHelper.instance.fetchFriends();
  }

  Future<void> _removeFriend(int id) async {
    await AmigosDatabaseHelper.instance.deleteFriend(id);
    setState(() {
      friendsFuture = AmigosDatabaseHelper.instance.fetchFriends();
    });
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
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
        color: Colors.white, 
        child: FutureBuilder<List<Amigos>>(
          future: friendsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum amigo encontrado.'));
            } else {
              final friends = snapshot.data!;
              return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/friend.png'), 
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'ID do Amigo: ',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '${friends[index].id}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text('Data de Início: ${_formatDate(friends[index].dataInicio)}', style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), 
                          onPressed: () {
                            _removeFriend(friends[index].id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

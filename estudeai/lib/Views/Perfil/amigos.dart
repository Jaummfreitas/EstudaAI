import 'package:flutter/material.dart';
import '../Service/db_helper_amigos.dart';
import '../Service/UsuarioService.dart';
import '../Service/SessionManager.dart';

class FriendsListPage extends StatefulWidget {
const FriendsListPage({super.key});

@override
_FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
late Future<List<FriendInfo>> friendsFuture;
final usuarioService = UsuarioService.instance;

@override
void initState() {
  super.initState();
  friendsFuture = _loadFriendsWithInfo();
}

Future<List<FriendInfo>> _loadFriendsWithInfo() async {
  final currentUserId = SessionManager().userId;
  if (currentUserId == null) return [];

  final friends = await AmigosDatabaseHelper.instance.fetchFriends();
  List<FriendInfo> friendsInfo = [];

  for (var friend in friends) {
    // Determina qual ID é o do amigo (não o do usuário atual)
    final friendId = friend.userId1 == currentUserId 
        ? friend.userId2 
        : friend.userId1;
    
    // Obtém o nome do amigo
    final friendName = await usuarioService.obterNomePorId(friendId);
    
    friendsInfo.add(FriendInfo(
      id: friend.id!,
      name: friendName,
      dataInicio: friend.dataInicio,
      friendId: friendId,
    ));
  }

  return friendsInfo;
}

Future<void> _removeFriend(int id) async {
  try {
    await AmigosDatabaseHelper.instance.deleteFriend(id);
    setState(() {
      friendsFuture = _loadFriendsWithInfo();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Amigo removido com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao remover amigo: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
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
      child: FutureBuilder<List<FriendInfo>>(
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
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF26A69A),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      friends[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Amigos desde: ${_formatDate(friends[index].dataInicio)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar Remoção'),
                              content: Text(
                                'Deseja remover ${friends[index].name} da sua lista de amigos?'
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _removeFriend(friends[index].id);
                                  },
                                  child: const Text(
                                    'Remover',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
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
class FriendInfo {
final int id;
final String name;
final String dataInicio;
final int friendId;

FriendInfo({
  required this.id,
  required this.name,
  required this.dataInicio,
  required this.friendId,
});
}
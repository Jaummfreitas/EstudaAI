import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:flutter/material.dart';
import '../Service/db_helper_amigos.dart';
import '../Service/UsuarioService.dart';
import '../Service/SessionManager.dart';

class AddFriendsPage extends StatefulWidget {
const AddFriendsPage({super.key});

@override
State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
final TextEditingController searchController = TextEditingController();
final usuarioService = UsuarioService.instance;
Map<String, dynamic>? searchResult;
bool isSearching = false;
bool isAdding = false;

Future<void> searchUser(String name) async {
  if (name.isEmpty) {
    setState(() {
      searchResult = null;
      isSearching = false;
    });
    return;
  }

  setState(() {
    isSearching = true;
  });

  try {
    final result = await usuarioService.buscarAmigo(name);
    if (result != null) {
      setState(() {
        searchResult = result;
      });
    } else {
      setState(() {
        searchResult = null;
      });
    }
  } catch (e) {
    setState(() {
      searchResult = null;
    });
  } finally {
    setState(() {
      isSearching = false;
    });
  }
}

Future<void> addFriend(int friendId) async {
  if (isAdding) return;

  setState(() {
    isAdding = true;
  });

  try {
    final currentUserId = SessionManager().userId;

    if (currentUserId == null) {
      throw Exception('Usuário não logado');
    }

    if (currentUserId == friendId) {
      throw Exception('Você não pode adicionar a si mesmo como amigo');
    }

    final existingFriend = await AmigosDatabaseHelper.instance.checkFriendship(
      currentUserId,
      friendId,
    );

    if (existingFriend) {
      throw Exception('Este usuário já é seu amigo');
    }

    final amigo = Amigos(
      userId1: currentUserId,
      userId2: friendId,
      dataInicio: DateTime.now().toIso8601String(),
    );

    final result = await AmigosDatabaseHelper.instance.insertFriend(amigo);

    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amigo adicionado com sucesso!')),
      );

      setState(() {
        searchResult = null;
        searchController.clear();
      });
    } else {
      throw Exception('Erro ao adicionar amigo');
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceAll('Exception:', ''))),
    );
  } finally {
    setState(() {
      isAdding = false;
    });
  }
}

@override
Widget build(BuildContext context) {
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
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar usuário',
              hintText: 'Digite o nome do usuário',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchResult = null;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              searchUser(value);
            },
          ),
          const SizedBox(height: 20),
          if (isSearching)
            const Center(child: CircularProgressIndicator())
          else if (searchResult != null)
            Card(
              elevation: 2,
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(searchResult!['user_name'] as String),
                trailing: ElevatedButton(
                  onPressed: isAdding
                      ? null
                      : () => addFriend(searchResult!['user_id'] as int),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    foregroundColor: Colors.white,
                  ),
                  child: isAdding
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Adicionar'),
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
                  final userDB = UsuarioService.instance;
                  final id = SessionManager().userId as int;
                  final amigo = Amigos(
                    userId1: id,
                    userId2: await userDB.obterIDporNome(name),
                    dataInicio: DateTime.now().toIso8601String(),
                    nome1: await userDB.obterNomePorId(id),
                    nome2: name,
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

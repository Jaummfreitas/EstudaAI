import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:estudeai/Views/Service/UsuarioService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:estudeai/Views/Home/home.dart';
import 'package:estudeai/Views/Calendario/calendario.dart';
import 'package:estudeai/Views/Quiz/quiz.dart';
import 'package:estudeai/Views/TelaInicial/TelaInicial.dart';
import 'package:estudeai/Views/Perfil/meuPerfil.dart';
import 'package:estudeai/Views/Perfil/configuracoes.dart';
import 'package:estudeai/Views/Perfil/addAmigo.dart';
import 'package:estudeai/Views/Perfil/amigos.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  final usuarioService = UsuarioService.instance;
  final userId = SessionManager().userId as int;
  String? imagemUrl;

  @override
  void initState() {
    super.initState();
    _initializeProfilePage();
    _fetchUserName();
  }

  void _initializeProfilePage() async {
    String? url = await retrieveImageFromFirebase(userId.toString());
    setState(() {
      imagemUrl = url;
    });
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final userId = SessionManager().userId as int;

    final String name = await usuarioService.obterNomePorId(userId);
    setState(() {
      userName = name;
    });
  }

  Future<String?> retrieveImageFromFirebase(String userId) async {
    try {
      // Referência ao arquivo no bucket
      final storageRef =
          FirebaseStorage.instance.ref().child("images/$userId.png");

      // Obtém a URL de download
      String downloadUrl = await storageRef.getDownloadURL();
      print("Image URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("Error retrieving image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final backgroundImage = imagemUrl != null
        ? NetworkImage(imagemUrl!)
        : const AssetImage('assets/images/default.png') as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF26A69A),
        title: const Text(
          'PERFIL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Calendário'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Quiz'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Adicionar Amigos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFriendsPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.teal[700]!.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: backgroundImage,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName.isNotEmpty ? userName : 'Carregando...',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          height: 24.0,
                          child: Image.asset("assets/images/verified.png"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsListPage()),
                  );
                },
                child: Text(
                  'Amigos',
                  style: TextStyle(
                    color: Colors.black.withOpacity(.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: size.height * .4,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                        _fetchUserName();
                      },
                      child: const ProfileWidget(
                        icon: Icons.person,
                        title: 'Meu Perfil',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddFriendsPage(),
                          ),
                        );
                      },
                      child: const ProfileWidget(
                        icon: Icons.person_add,
                        title: 'Adicionar Amigos',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DefinicoesPage(),
                          ),
                        );
                      },
                      child: const ProfileWidget(
                        icon: Icons.info_outline,
                        title: 'Sobre o app',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaInicial(),
                          ),
                        );
                      },
                      child: const ProfileWidget(
                        icon: Icons.logout,
                        title: 'Logout',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.teal[700]!.withOpacity(.7),
                size: 24.0,
              ),
              const SizedBox(width: 16.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.teal[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.teal[700]!.withOpacity(.4),
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

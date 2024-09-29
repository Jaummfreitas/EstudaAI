import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A), 
        title: Stack(
          alignment: Alignment.center, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white), 
                  onPressed: () {
                  },
                ),
                const Text(
                  'ESTUDAI',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const Text(
              'Perfil',
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
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
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: ExactAssetImage('assets/images/profile.jpg'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width * .8, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        const Text(
                          'João Vítor',
                          style: TextStyle(
                            color: Colors.black, 
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
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
              Text(
                'jvitorfreitas2004@gmail.com',
                style: TextStyle(
                  color: Colors.black.withOpacity(.8),
                ),
              ),
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                      },
                      child: const ProfileWidget(
                        icon: Icons.person,
                        title: 'Meu Perfil',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                      },
                      child: const ProfileWidget(
                        icon: Icons.settings,
                        title: 'Configurações',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                      },
                      child: const ProfileWidget(
                        icon: Icons.notifications,
                        title: 'Notificações',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                      },
                      child: const ProfileWidget(
                        icon: Icons.logout,
                        title: 'Logout',
                      ),
                    ),
                  ],
                ),
              )
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
              const SizedBox(
                width: 16.0,
              ),
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

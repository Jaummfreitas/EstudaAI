import 'package:flutter/material.dart';

import '../TelaInicial/TelaInicial.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoginFocused = false;
  bool _isSenhaFocused = false;
  bool _isButtonPressed = false;

  void _onLoginButtonPressed() {
    setState(() {
      _isButtonPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isButtonPressed = false;
      });

      // Navegação para a próxima tela, se necessário
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TelaInicial()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(  // Centralizando o conteúdo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(  // Envolva o texto com GestureDetector
              onTap: () {
                // Navegue para a TelaInicial ao clicar no texto
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInicial()),
                );
              },
              child: const Text(
                'ESTUDE.AI',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 300, // Definindo a largura dos campos
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isLoginFocused = hasFocus;
                  });
                },
                child: TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: 'Login',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isLoginFocused ? Colors.teal : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.teal[800]!,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 300, // Definindo a largura dos campos
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isSenhaFocused = hasFocus;
                  });
                },
                child: TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: _isSenhaFocused ? Colors.teal : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.teal[800]!,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _onLoginButtonPressed,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 300, // Definindo a largura do botão
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: _isButtonPressed ? Colors.teal[900] : Colors.teal[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'ENTRAR',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

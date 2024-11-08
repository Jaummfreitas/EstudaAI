import 'package:flutter/material.dart';
import '../Login/Login.dart';
import '../Service/UsuarioService.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<Cadastro> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  bool _isNomeFocused = false;
  bool _isEmailFocused = false;
  bool _isSenhaFocused = false;
  bool _isConfirmarSenhaFocused = false;
  bool _isButtonPressed = false;
  bool _aceitaPoliticas = false;
  bool _receberConteudo = false;

  void _onCadastrarButtonPressed() async {
    setState(() {
      _isButtonPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () async {
      setState(() {
        _isButtonPressed = false;
      });

      // Captura os valores dos campos Nome e Senha
      String nome = _nomeController.text;
      String senha = _senhaController.text;

      // Imprime ou usa o objeto User conforme necessário
      final userHelper = UsuarioService.instance;
      await userHelper.createUser(nome, senha);

      // Navegação para a tela de Login após cadastro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ESTUDE.AI',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    controller: _nomeController,
                    label: 'Nome',
                    isFocused: _isNomeFocused,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isNomeFocused = hasFocus;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    isFocused: _isEmailFocused,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isEmailFocused = hasFocus;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _senhaController,
                    label: 'Senha',
                    obscureText: true,
                    isFocused: _isSenhaFocused,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isSenhaFocused = hasFocus;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmarSenhaController,
                    label: 'Confirmar Senha',
                    obscureText: true,
                    isFocused: _isConfirmarSenhaFocused,
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isConfirmarSenhaFocused = hasFocus;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _aceitaPoliticas,
                        onChanged: (value) {
                          setState(() {
                            _aceitaPoliticas = value!;
                          });
                        },
                      ),
                      const Text(
                        'Li e aceito as Políticas de Privacidade',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _receberConteudo,
                        onChanged: (value) {
                          setState(() {
                            _receberConteudo = value!;
                          });
                        },
                      ),
                      const Text(
                        'Quero receber conteúdo no meu email',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _onCadastrarButtonPressed,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 300, // Definindo a largura do botão
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _isButtonPressed
                            ? Colors.teal[900]
                            : Colors.teal[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'CADASTRAR',
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    required bool isFocused,
    required Function(bool) onFocusChange,
  }) {
    return Container(
      width: 300, // Definindo a largura dos campos
      child: Focus(
        onFocusChange: onFocusChange,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isFocused ? Colors.teal : Colors.transparent,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import '../Cadastro/Cadastro.dart';
import '../Login/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  bool carregou = false;

  @override
  void initState() {
    super.initState();
    _iniciarLoading();
  }

  // Função que cria o delay de 2 segundos
  Future<void> _iniciarLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      carregou = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      body: Center(
        child: carregou ? _buildMainContent(context) : _buildLoading(),
      ),
    );
  }

  // Widget para a tela de loading
  Widget _buildLoading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ESTUDE.AI',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ESTUDE.AI',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text(
            'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Cadastro()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[700],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text(
            'CADASTRE-SE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _showPrivacyPolicyModal(context);
              },
              child: const Text(
                'POLÍTICAS DE PRIVACIDADE | CONTATO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Função para mostrar o modal de políticas de privacidade
  void _showPrivacyPolicyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const Text('Políticas de Privacidade', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(_gerarPoliticasPrivacidade()),
            const SizedBox(height: 20),
          ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

String _gerarPoliticasPrivacidade() {
  return "Lorem ipsum odor amet, consectetuer adipiscing elit. Suscipit aliquet nostra fames lacinia diam magna tempor ad. Volutpat proin lacus commodo donec luctus montes varius? Bibendum eu maecenas facilisis dignissim class non. Nullam nunc donec, placerat vel mus feugiat in. Inceptos at scelerisque felis netus scelerisque ad enim ut.Inceptos rhoncus ac porta est sagittis libero viverra adipiscing laoreet. Sem facilisi ex; morbi rhoncus rhoncus maximus. Arcu conubia velit turpis erat tincidunt sed vulputate nascetur pellentesque. Cursus arcu gravida vitae leo suscipit euismod tincidunt interdum. Quam cursus conubia condimentum orci condimentum ipsum. In duis magnis habitant ridiculus potenti gravida dolor? Luctus ullamcorper varius; fames ridiculus quisque congue odio.Maximus dapibus posuere amet phasellus sagittis hac parturient tortor. Sociosqu inceptos nulla aptent tempor tortor libero maecenas. Vulputate sagittis curae magna libero sapien curabitur. Habitasse est placerat dis tellus vestibulum tellus malesuada justo. Eu scelerisque ad proin dolor platea habitant quisque sapien. Sodales nibh facilisi tincidunt interdum ridiculus fringilla dictum orci. Vitae ante eu augue est condimentum interdum non malesuada.";
}

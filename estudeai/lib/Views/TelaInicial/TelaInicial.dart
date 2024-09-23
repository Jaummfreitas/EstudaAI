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
        const Text(
          //TODO: Ao clicar em contato, abrir discagem automatica com numero de "contato"
          //TODO: Ao clicar em politicas, abrir txt com texto aleatorio
          'CONTATO | POLÍTICAS DE PRIVACIDADE',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

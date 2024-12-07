import 'dart:io';

import 'package:estudeai/Views/Service/db_helper.dart';
import 'package:estudeai/Views/Service/openai-api-helper.dart';
import 'package:estudeai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Views/TelaInicial/TelaInicial.dart';
import 'Views/Login/Login.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isWindows &&
      !Platform.isLinux &&
      !Platform.isMacOS &&
      !Platform.isAndroid &&
      !Platform.isIOS) {
    throw UnsupportedError(
        'A execução da aplicação não é suportada no navegador com sqflite.');
  } else {
    // Inicializa o databaseFactory corretamente para plataformas suportadas
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper.instance.database;
  print('Firebase foi inicializado com sucesso!');
  printDatabasePath();
  await testConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaInicial(),
    );
  }
}

void printDatabasePath() async {
  final dbPath = await getDatabasesPath();
  print('Database path: $dbPath/my_database.db');
}

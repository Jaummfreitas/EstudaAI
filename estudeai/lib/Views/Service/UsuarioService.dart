import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:estudeai/Views/Service/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioService {
static final UsuarioService instance = UsuarioService._init();

UsuarioService._init();

Future<void> createUser(String nome, String senha, String email) async {
  final db = await DatabaseHelper.instance.database;

  await db.insert(
    'User',
    {
      'user_name': nome,
      'user_password': senha,
      'user_email': email,
      'user_status': 1,
    },
  );
}

Future<Map<String, dynamic>?> obterPorNome(String nome, {bool isSearch = false}) async {
  final db = await DatabaseHelper.instance.database;

  try {
    final result = await db.query(
      'User',
      where: 'user_name = ?',
      whereArgs: [nome],
    );

    if (result.isNotEmpty) {
      final user = result.first;
      
      if (!isSearch) {
        SessionManager().userId = user['user_id'] as int?;
      }
      
      return user;
    }
    return null;

  } catch (e) {
    print('Erro ao obter usuário: $e');
    return null;
  }
}

// Função específica para busca de amigos
Future<Map<String, dynamic>?> buscarAmigo(String nome) async {
  return await obterPorNome(nome, isSearch: true);
}

Future<String> obterNomePorId(int id) async {
  final db = await DatabaseHelper.instance.database;

  final result = await db.query(
    'User',
    where: 'user_id = ?',
    whereArgs: [id],
  );

  if (result.isNotEmpty) {
    final user = result.first;
    return user['user_name'] as String;
  } else {
    return '';
  }
}

Future<String> obterEmailPorId(int id) async {
  final db = await DatabaseHelper.instance.database;

  final result = await db.query(
    'User',
    where: 'user_id = ?',
    whereArgs: [id],
  );

  if (result.isNotEmpty) {
    final user = result.first;
    return user['user_email'] as String? ?? '';
  } else {
    return '';
  }
}

Future<void> atualizarNome(int userId, String novoNome) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    'User',
    {'user_name': novoNome},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

Future<void> atualizarEmail(int userId, String novoEmail) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    'User',
    {'user_email': novoEmail},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

Future<void> atualizarSenha(int userId, String novaSenha) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    'User',
    {'user_password': novaSenha},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}
}
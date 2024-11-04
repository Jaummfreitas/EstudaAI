import 'package:estudeai/Views/Service/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioService {
  static final UsuarioService instance = UsuarioService._init();

  UsuarioService._init();

  Future<void> createUser(String nome, String senha) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'User',
      {
        'user_name': nome,
        'user_password': senha,
        'user_status': 1,
      },
    );
  }

  Future<Map<String, dynamic>?> obterPorNome(String nome) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'User',
      where: 'user_name = ?',
      whereArgs: [nome],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
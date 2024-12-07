import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:flutter/foundation.dart';
import 'db_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../Perfil/amigos.dart';

class Amigos {
  final int? id;
  final int userId1;
  final int userId2;
  final String dataInicio;
  final String nome1;
  final String nome2;

  Amigos({
    this.id,
    required this.userId1,
    required this.userId2,
    required this.dataInicio,
    required this.nome1,
    required this.nome2
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'data_inicio': dataInicio,
      'nome_1': nome1,
      'nome_2': nome2
    };
  }

  static Amigos fromMap(Map<String, dynamic> map) {
    return Amigos(
      id: map['id'] as int?,
      userId1: map['user_id_1'] as int,
      userId2: map['user_id_2'] as int,
      dataInicio: map['data_inicio'] as String,
      nome1: map['nome_1'] as String,
      nome2: map['nome_2'] as String
    );
  }
}

class AmigosDatabaseHelper {
static final AmigosDatabaseHelper instance = AmigosDatabaseHelper._init();

AmigosDatabaseHelper._init();

Future<Database> get database async {
  return await DatabaseHelper.instance.database;
}

Future<int> insertFriend(Amigos amigo) async {
  final db = await database;
  return await db.insert('Amigos', amigo.toMap());
}

  Future<List<Amigos>> fetchFriends() async {
    final db = await database;
    int userId = SessionManager().userId as int;
    final result = await db.query(
      'Amigos',
      where: 'user_id_1 = ? OR user_id_2 = ?',
      whereArgs: [userId, userId],
      );
    return result.map((json) => Amigos.fromMap(json)).toList();
  }

Future<int> deleteFriend(int id) async {
  final db = await database;
  return await db.delete(
    'Amigos',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> updateFriend(Amigos amigo) async {
  final db = await database;
  await db.update(
    'Amigos',
    amigo.toMap(),
    where: 'id = ?',
    whereArgs: [amigo.id],
  );
}

Future<bool> checkFriendship(int userId1, int userId2) async {
  final db = await database;

  // Verifica em ambas as direções (userId1 -> userId2 e userId2 -> userId1)
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM Amigos 
    WHERE (user_id_1 = ? AND user_id_2 = ?) 
    OR (user_id_1 = ? AND user_id_2 = ?)
  ''', [userId1, userId2, userId2, userId1]);

  return result.isNotEmpty;
}
}
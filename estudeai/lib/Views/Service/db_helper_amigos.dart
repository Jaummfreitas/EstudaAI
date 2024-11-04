import 'db_helper.dart'; 
import 'package:sqflite/sqflite.dart';
import '../Perfil/amigos.dart'; 
class Amigos {
  final int? id;
  final int userId1;
  final int userId2;
  final String dataInicio;

  Amigos({
    this.id,
    required this.userId1,
    required this.userId2,
    required this.dataInicio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'data_inicio': dataInicio,
    };
  }

  static Amigos fromMap(Map<String, dynamic> map) {
    return Amigos(
      id: map['id'] as int?,
      userId1: map['user_id_1'] as int,
      userId2: map['user_id_2'] as int,
      dataInicio: map['data_inicio'] as String,
    );
  }
}

class AmigosDatabaseHelper {
  static final AmigosDatabaseHelper instance = AmigosDatabaseHelper._init();

  AmigosDatabaseHelper._init();

  Future<Database> get database async {
    return await _initDB('amigos.db'); 
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(
      filePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Amigos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id_1 INTEGER,
        user_id_2 INTEGER,
        data_inicio TEXT
      )
    ''');
  }

  Future<int> insertFriend(Amigos amigo) async {
    final db = await database; 
    return await db.insert('Amigos', amigo.toMap());
  }

  Future<List<Amigos>> fetchFriends() async {
    final db = await database;
    final result = await db.query('Amigos');
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
}
import 'db_helper.dart'; // Importa sua classe geral de banco de dados
import 'package:sqflite/sqflite.dart';
import '../Calendario/calendario.dart'; // Certifique-se de importar a classe Event que você criou

class CalendarDatabaseHelper {
  static final CalendarDatabaseHelper instance = CalendarDatabaseHelper._init();

  CalendarDatabaseHelper._init();

  Future<int> insertEvent(Event event) async {
    final db = await DatabaseHelper.instance.database; // Chama a instância do seu DB geral
    return await db.insert('Evento', event.toMap());
  }

  Future<List<Event>> fetchEvents() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('Evento');
    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> deleteEvent(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('Evento',
        where: 'evento_id = ?',
        whereArgs: [id]);
  }
  Future<void> updateEvent(Event event) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'Evento', // Nome da tabela
      event.toMap(), // Converte o evento para um mapa de colunas e valores
      where: 'evento_id = ?', // Condição para garantir que só o evento correto seja atualizado
      whereArgs: [event.id], // Argumento para a condição
    );
  }
}

import 'package:estudeai/Views/Home/home.dart';
import 'package:estudeai/Views/Perfil/perfil.dart';
import 'package:estudeai/Views/Quiz/quiz.dart';
import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Service/db_helper_calendario.dart';

class Event {
  int? id;
  String nome;
  String horario;
  String descricao;
  String data;
  int user_id; // Torna obrigatório

  Event({
    this.id,
    required this.nome,
    required this.horario,
    required this.descricao,
    required this.data,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'evento_id': id,
      'evento_name': nome,
      'evento_time': horario,
      'evento_descricao': descricao,
      'evento_date': data,
      'user_id': user_id, // Inclui user_id no map
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['evento_id'],
      nome: map['evento_name'],
      horario: map['evento_time'],
      descricao: map['evento_descricao'],
      data: map['evento_date'],
      user_id: map['user_id'],
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<String, List<Event>> _events = {};

  @override
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents(); // Carrega eventos do banco de dados ao iniciar
  }

  List<Event> _getEventsForDay(DateTime date) {
    return _events[date.toString()] ?? [
    ]; // Retorna a lista de eventos ou uma lista vazia se não houver eventos
  }

  Future<void> _loadEvents() async {
    final events = await CalendarDatabaseHelper.instance
        .fetchEvents(); // Chama a nova classe
    setState(() {
      for (var event in events) {
        String eventDate = event.data;
        int? id = event.id;
        _addEvent(eventDate, event, loadFromDb: true);
      }
    });
  }

void _addEvent(String day, Event event, {bool loadFromDb = false}) async {
  if (!loadFromDb) {
    // Define o `user_id` do usuário atual ao salvar um novo evento
    event.user_id = SessionManager().userId as int;

    // Inserir evento no banco de dados e obter o ID gerado
    final newId = await CalendarDatabaseHelper.instance.insertEvent(event);
    event.id = newId; // Atualiza o ID do evento com o valor gerado
  }

  setState(() {
    final events = _events.putIfAbsent(day, () => []);
    events.add(event);
  });
}



  void _deleteEvent(Event event) async {
    if (event.id != null) {
      await CalendarDatabaseHelper.instance.deleteEvent(
          event.id!); // Usa a nova classe
      setState(() {
        _events[_selectedDay!.toString()]!.remove(event);
      });
    }
    else {
      print("ID NULO");
    }
  }
  void _updateEvent(Event event, String newName, String newTime, String newDescription) async {
    // Atualiza os dados do evento
    final updatedEvent = Event(
      id: event.id,
      nome: newName,
      horario: newTime,
      descricao: newDescription,
      data: event.data,
      user_id: event.user_id
    );

    // Atualiza o banco de dados
    if (updatedEvent.id != null) {
      await CalendarDatabaseHelper.instance.updateEvent(updatedEvent);
    }

    // Atualiza o mapa de eventos
    setState(() {
      final events = _events[updatedEvent.data];
      if (events != null) {
        final index = events.indexWhere((e) => e.id == updatedEvent.id);
        if (index != -1) {
          events[index] = updatedEvent; // Substitui o evento atualizado
        }
      }
    });
  }


  // Exibe caixa de diálogo para adicionar eventos
  void _showAddEventDialog() {
    String eventName = '';
    String eventTime = '';
    String eventDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (text) {
                  eventName = text;
                },
                decoration: InputDecoration(hintText: 'Nome do evento'),
              ),
              TextField(
                onChanged: (text) {
                  eventTime = text;
                },
                decoration:
                InputDecoration(hintText: 'Horário do evento (ex: 14:00)'),
              ),
              TextField(
                onChanged: (text) {
                  eventDescription = text;
                },
                decoration: InputDecoration(hintText: 'Descrição do evento'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (eventName.isNotEmpty && eventTime.isNotEmpty) {
                  _addEvent(
                      _selectedDay!.toString(),
                      Event(
                          nome: eventName,
                          horario: eventTime,
                          descricao: eventDescription,
                          user_id: SessionManager().userId as int,
                          data: _selectedDay.toString()));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal, // Define a cor primária como Teal
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal, // Cor da AppBar
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal, // Cor do FloatingActionButton
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'CALENDÁRIO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: Text('Home Page'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              ListTile(
                title: Text('Quizzes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                // Define a circunferência completamente preenchida com teal
                selectedDecoration: BoxDecoration(
                  color: Colors.teal, // Preenche o dia selecionado com teal
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.5), // Cor para o dia atual
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.white, // Garante que o número fique visível
                  fontWeight: FontWeight.bold, // Deixa o número em negrito
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEventDialog(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showUpdateEventDialog(Event event) {
    String eventName = event.nome;
    String eventTime = event.horario;
    String eventDescription = event.descricao;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atualizar Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (text) {
                  eventName = text;
                },
                decoration: InputDecoration(hintText: 'Nome do evento'),
                controller: TextEditingController(text: eventName), // Preenche com o valor existente
              ),
              TextField(
                onChanged: (text) {
                  eventTime = text;
                },
                decoration: InputDecoration(hintText: 'Horário do evento (ex: 14:00)'),
                controller: TextEditingController(text: eventTime),
              ),
              TextField(
                onChanged: (text) {
                  eventDescription = text;
                },
                decoration: InputDecoration(hintText: 'Descrição do evento'),
                controller: TextEditingController(text: eventDescription),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                if (eventName.isNotEmpty && eventTime.isNotEmpty) {
                  _updateEvent(
                    event,
                    eventName,
                    eventTime,
                    eventDescription,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.nome),
          subtitle: Text(
              'Horário: ${event.horario}\nDescrição: ${event.descricao}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showUpdateEventDialog(event); // Abre o modal de atualização
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteEvent(event); // Chama a função de exclusão
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

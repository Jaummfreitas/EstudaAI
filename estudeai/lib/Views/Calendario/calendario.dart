import 'package:estudeai/Views/Home/home.dart';
import 'package:estudeai/Views/Perfil/perfil.dart';
import 'package:estudeai/Views/Quiz/quiz.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String nome;
  String horario;
  String descricao;

  Event({required this.nome, required this.horario, required this.descricao});
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Event>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Retorna eventos para o dia selecionado
  List<Event> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = _normalizeDate(day); // Normaliza a data
    return _events[normalizedDay] ?? [];
  }

  // Normaliza a data para remover a hora, minuto, segundo
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Função para adicionar evento (mais tarde será melhorado para CRUD)
  void _addEvent(DateTime day, Event event) {
    setState(() {
      DateTime normalizedDay = _normalizeDate(day); // Normaliza a data
      if (_events[normalizedDay] != null) {
        _events[normalizedDay]!.add(event);
      } else {
        _events[normalizedDay] = [event];
      }
      print('Eventos no dia $normalizedDay: ${_events[normalizedDay]}');
    });
  }

  DateTime _getEndOfWeek(DateTime day) {
    int daysUntilSunday = DateTime.sunday - day.weekday;
    return day.add(Duration(days: daysUntilSunday));
  }

  List<Event> _getEventsForCurrentWeek(DateTime day) {
    List<Event> eventsForWeek = [];
    DateTime endOfWeek = _getEndOfWeek(day);

    for (DateTime currentDay = day;
        currentDay.isBefore(endOfWeek) || isSameDay(currentDay, endOfWeek);
        currentDay = currentDay.add(Duration(days: 1))) {
      if (_events[currentDay] != null) {
        eventsForWeek.addAll(_events[currentDay]!);
      }
    }

    return eventsForWeek;
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
                      _selectedDay!,
                      Event(
                          nome: eventName,
                          horario: eventTime,
                          descricao: eventDescription));
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

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.nome),
          subtitle:
              Text('Horário: ${event.horario}\nDescrição: ${event.descricao}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                events.removeAt(index);
                if (events.isEmpty) {
                  _events.remove(_selectedDay);
                }
              });
            },
          ),
        );
      },
    );
  }
}

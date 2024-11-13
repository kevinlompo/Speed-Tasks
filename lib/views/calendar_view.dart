import 'package:flutter/material.dart';
import 'package:speed_task/constant/string.dart';
import 'package:speed_task/constant/task_list.dart';
import 'package:speed_task/controllers/services/notification_service.dart';
import 'package:speed_task/models/task.dart';
import 'package:speed_task/views/add_task_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final List<Task> tasks;

  const CalendarView({
    Key? key,
    required this.tasks,
  }) : super(key: key);
  
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  final Map<CalendarFormat, String> _availableFormats = {
    CalendarFormat.month: month,
    CalendarFormat.twoWeeks: twoWeeks,
    CalendarFormat.week: week,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();  // Initialise le jour sélectionné
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier'),
        elevation: 0, // Supprime l'ombre sous l'AppBar
      ),
      body: SafeArea(  // Ajoute un espace sûr autour du contenu
        child: Column(
          children: [
            const SizedBox(height: 16), // Ajoute de l'espace en haut
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Ajoute des marges horizontales
              child: Card(  // Entoure le calendrier d'une carte
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),  // Ajoute du padding interne
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2024, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    //locale: 'fr_FR',
                    //availableCalendarFormats: _availableFormats,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    // Personnalisation du style du calendrier
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16), // Ajoute de l'espace entre le calendrier et la liste
            if (_selectedDay != null) ...[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 4,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: widget.tasks
                          .where((task) => isSameDay(task.date, _selectedDay))
                          .length,
                      itemBuilder: (context, index) {
                        final filteredTasks = widget.tasks
                            .where((task) => isSameDay(task.date, _selectedDay))
                            .toList()
                          ..sort((a, b) => a.startTime.compareTo(b.startTime));  // Tri par heure

                        print('Filtered tasks length: ${filteredTasks.length}');  // Debug print
                        print('Selected day: $_selectedDay');  // Debug print
                        final task = filteredTasks[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.content),
                                const SizedBox(height: 4),
                                if (task.notifyEnabled)
                                  const Icon(Icons.notifications_active,
                                      size: 16,
                                      color: Colors.blue
                                  ),
                              ],
                            ),
                            trailing: Text(
                              '${task.startTime.hour.toString().padLeft(2, '0')}:${task.startTime.minute.toString().padLeft(2, '0')} - '
                                  '${task.endTime.hour.toString().padLeft(2, '0')}:${task.endTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        selectedDate: _selectedDay ?? DateTime.now(),
        onTaskAdded: (task) async {
          setState(() {
            widget.tasks.add(task);
          });

          if (task.notifyEnabled) {
            final notificationService = NotificationService();
            await notificationService.scheduleNotification(task);
          }
        },
      ),
    );
  }
}
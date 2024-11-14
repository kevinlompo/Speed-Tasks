import 'package:flutter/material.dart';
import 'package:speed_task/constant/string.dart';
import 'package:speed_task/controllers/services/notification_service.dart';
import 'package:speed_task/models/task.dart';
import 'package:speed_task/views/add_task_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

/// CalendarView est un widget qui affiche un calendrier interactif avec une liste de tâches.
/// Il permet de visualiser et d'ajouter des tâches pour des dates spécifiques, avec support
/// pour les notifications.
///
/// Cette vue utilise le package table_calendar pour l'affichage du calendrier et gère
/// l'affichage des tâches pour chaque jour sélectionné.
class CalendarView extends StatefulWidget {
  /// Liste des tâches à afficher dans le calendrier
  final List<Task> tasks;

  /// Constructeur qui initialise la vue avec une liste de tâches requise
  ///
  /// [tasks] : Liste des tâches à afficher dans le calendrier
  /// [key] : Clé optionnelle pour le widget
  const CalendarView({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  /// Format d'affichage actuel du calendrier (mois, deux semaines, semaine)
  CalendarFormat _calendarFormat = CalendarFormat.month;

  /// Jour actuellement focalisé dans le calendrier
  DateTime _focusedDay = DateTime.now();

  /// Jour sélectionné par l'utilisateur
  DateTime? _selectedDay;

  /// Formats disponibles pour l'affichage du calendrier avec leurs traductions
  final Map<CalendarFormat, String> _availableFormats = {
    CalendarFormat.month: month,
    CalendarFormat.twoWeeks: twoWeeks,
    CalendarFormat.week: week,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 16),
            if (_selectedDay != null) _buildTasksList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  /// Construit le widget du calendrier avec sa personnalisation
  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: _onFormatChanged,
            calendarStyle: _buildCalendarStyle(),
            headerStyle: _buildHeaderStyle(),
          ),
        ),
      ),
    );
  }

  /// Style personnalisé du calendrier
  CalendarStyle _buildCalendarStyle() {
    return const CalendarStyle(
      todayDecoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Style personnalisé de l'en-tête du calendrier
  HeaderStyle _buildHeaderStyle() {
    return const HeaderStyle(
      formatButtonVisible: true,
      titleCentered: true,
      formatButtonShowsNext: false,
    );
  }

  /// Construit la liste des tâches pour le jour sélectionné
  Widget _buildTasksList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 4,
          child: _buildTaskListView(),
        ),
      ),
    );
  }

  /// Construit la vue liste des tâches avec leur mise en forme
  Widget _buildTaskListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _getFilteredTasks().length,
      itemBuilder: (context, index) => _buildTaskCard(_getFilteredTasks()[index]),
    );
  }

  /// Récupère la liste des tâches filtrées pour le jour sélectionné
  List<Task> _getFilteredTasks() {
    return widget.tasks
        .where((task) => isSameDay(task.date, _selectedDay))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Construit une carte pour une tâche individuelle
  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildTaskSubtitle(task),
        trailing: _buildTaskTime(task),
      ),
    );
  }

  /// Construit le sous-titre d'une tâche avec l'icône de notification si activée
  Widget _buildTaskSubtitle(Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.content),
        const SizedBox(height: 4),
        if (task.notifyEnabled)
          const Icon(
            Icons.notifications_active,
            size: 16,
            color: Colors.blue,
          ),
      ],
    );
  }

  /// Formate et affiche l'horaire de la tâche
  Widget _buildTaskTime(Task task) {
    return Text(
      '${_formatTime(task.startTime)} - ${_formatTime(task.endTime)}',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.blue,
      ),
    );
  }

  /// Formate une heure au format HH:mm
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Gère la sélection d'un jour dans le calendrier
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  /// Gère le changement de format du calendrier
  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  /// Affiche le dialogue d'ajout de tâche
  ///
  /// Cette méthode gère également la programmation des notifications
  /// si elles sont activées pour la tâche
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        selectedDate: _selectedDay ?? DateTime.now(),
        onTaskAdded: _handleTaskAdded,
      ),
    );
  }

  /// Gère l'ajout d'une nouvelle tâche
  ///
  /// [task] : La nouvelle tâche à ajouter
  Future<void> _handleTaskAdded(Task task) async {
    setState(() {
      widget.tasks.add(task);
    });

    if (task.notifyEnabled) {
      final notificationService = NotificationService();
      await notificationService.scheduleNotification(task);
    }
  }
}
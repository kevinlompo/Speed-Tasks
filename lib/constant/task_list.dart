// Liste initiale de tâches
import '../models/task.dart';

final List<Task> tasksList = [
  Task(
    title: 'Réunion d\'équipe',
    content: 'Discussion sur le projet mobile',
    date: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 1)),
    endTime: DateTime.now().add(const Duration(hours: 2)),
    notifyEnabled: true,
  ),
  Task(
    title: 'Pause déjeuner',
    content: 'Restaurant avec les collègues',
    date: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 4)),
    endTime: DateTime.now().add(const Duration(hours: 5)),
    notifyEnabled: false,
  ),
  Task(
    title: 'Révision code',
    content: 'Revoir le code du sprint',
    date: DateTime.now(),
    startTime: DateTime.now().add(const Duration(hours: 6)),
    endTime: DateTime.now().add(const Duration(hours: 7)),
    notifyEnabled: true,
  ),
];
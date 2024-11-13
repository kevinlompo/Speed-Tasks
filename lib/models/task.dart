class Task {
  final String title;
  final String content;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime date;
  final bool notifyEnabled;

  Task({
    required this.title,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.notifyEnabled,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'date': date.toIso8601String(),
    'notifyEnabled': notifyEnabled,
  };
}
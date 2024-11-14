/// Task représente une tâche planifiée avec ses détails et ses paramètres de notification.
///
/// Cette classe est utilisée pour stocker et gérer les informations d'une tâche,
/// y compris son timing et les préférences de notification.
class Task {
  /// Le titre de la tâche
  final String title;

  /// Le contenu ou la description détaillée de la tâche
  final String content;

  /// L'heure de début de la tâche
  /// Format: DateTime incluant la date et l'heure
  final DateTime startTime;

  /// L'heure de fin de la tâche
  /// Format: DateTime incluant la date et l'heure
  final DateTime endTime;

  /// La date à laquelle la tâche est prévue
  /// Cette date peut différer des dates de startTime/endTime
  /// pour la gestion du calendrier
  final DateTime date;

  /// Indique si les notifications sont activées pour cette tâche
  final bool notifyEnabled;

  /// Crée une nouvelle instance de Task
  ///
  /// [title] : Le titre de la tâche
  /// [content] : La description de la tâche
  /// [startTime] : L'heure de début
  /// [endTime] : L'heure de fin
  /// [date] : La date de la tâche
  /// [notifyEnabled] : État des notifications
  ///
  /// Tous les paramètres sont requis pour créer une tâche valide.
  Task({
    required this.title,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.notifyEnabled,
  }) {
    // Validation des paramètres temporels
    assert(!startTime.isAfter(endTime),
    'L\'heure de début doit être antérieure à l\'heure de fin');
  }

  /// Convertit la tâche en Map pour la sérialisation JSON
  ///
  /// Returns une Map<String, dynamic> contenant toutes les propriétés
  /// de la tâche avec les dates formatées en ISO 8601
  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'date': date.toIso8601String(),
    'notifyEnabled': notifyEnabled,
  };

  /// Crée une copie de la tâche avec des modifications optionnelles
  ///
  /// Permet de créer une nouvelle instance de Task en modifiant
  /// certaines propriétés tout en conservant les autres
  Task copyWith({
    String? title,
    String? content,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? date,
    bool? notifyEnabled,
  }) {
    return Task(
      title: title ?? this.title,
      content: content ?? this.content,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      notifyEnabled: notifyEnabled ?? this.notifyEnabled,
    );
  }

  /// Crée une instance de Task à partir d'une Map
  ///
  /// [map] : Map contenant les données de la tâche
  /// Returns une nouvelle instance de Task
  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      content: map['content'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      date: DateTime.parse(map['date'] as String),
      notifyEnabled: map['notifyEnabled'] as bool,
    );
  }

  @override
  String toString() {
    return 'Task{title: $title, date: $date, startTime: $startTime, endTime: $endTime}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.title == title &&
        other.content == content &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.date == date &&
        other.notifyEnabled == notifyEnabled;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    content.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    date.hashCode ^
    notifyEnabled.hashCode;
  }
}
import 'package:flutter/material.dart';
import '../models/task.dart';

/// AddTaskDialog est un widget qui affiche une boîte de dialogue permettant
/// d'ajouter une nouvelle tâche avec ses détails (titre, description, horaires)
/// et la possibilité d'activer des notifications.
class AddTaskDialog extends StatefulWidget {
  /// Date sélectionnée pour la tâche
  final DateTime selectedDate;

  /// Callback appelé lorsqu'une nouvelle tâche est ajoutée
  final Function(Task) onTaskAdded;

  /// Constructeur du dialogue d'ajout de tâche
  ///
  /// [selectedDate] : Date pour laquelle la tâche est créée
  /// [onTaskAdded] : Fonction callback appelée lors de l'ajout d'une tâche
  /// [key] : Clé optionnelle pour le widget
  const AddTaskDialog({
    Key? key,
    required this.selectedDate,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  /// Clé globale pour le formulaire permettant la validation
  final _formKey = GlobalKey<FormState>();

  /// Contrôleur pour le champ du titre
  final _titleController = TextEditingController();

  /// Contrôleur pour le champ de description
  final _contentController = TextEditingController();

  /// Heure de début de la tâche
  TimeOfDay _startTime = TimeOfDay.now();

  /// Heure de fin de la tâche
  TimeOfDay _endTime = TimeOfDay.now();

  /// État d'activation des notifications pour la tâche
  bool _notifyEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle tâche'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitleField(),
              _buildDescriptionField(),
              const SizedBox(height: 16),
              _buildTimeSelectionRow(context, true),
              _buildTimeSelectionRow(context, false),
              _buildNotificationToggle(),
            ],
          ),
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }

  /// Construit le champ de saisie du titre
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(labelText: 'Titre'),
      validator: _validateTitle,
    );
  }

  /// Construit le champ de saisie de la description
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _contentController,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      validator: _validateDescription,
    );
  }

  /// Construit une ligne de sélection d'heure (début ou fin)
  ///
  /// [context] : Contexte de build
  /// [isStartTime] : True pour l'heure de début, False pour l'heure de fin
  Widget _buildTimeSelectionRow(BuildContext context, bool isStartTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(isStartTime ? 'Heure de début:' : 'Heure de fin:'),
        TextButton(
          onPressed: () => _selectTime(context, isStartTime),
          child: Text(isStartTime
              ? _startTime.format(context)
              : _endTime.format(context)),
        ),
      ],
    );
  }

  /// Construit le toggle pour activer/désactiver les notifications
  Widget _buildNotificationToggle() {
    return SwitchListTile(
      title: const Text('Activer les notifications'),
      value: _notifyEnabled,
      onChanged: (bool value) {
        setState(() {
          _notifyEnabled = value;
        });
      },
    );
  }

  /// Construit les boutons d'action du dialogue
  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Annuler'),
      ),
      ElevatedButton(
        onPressed: _handleSubmit,
        child: const Text('Ajouter'),
      ),
    ];
  }

  /// Valide le titre de la tâche
  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un titre';
    }
    return null;
  }

  /// Valide la description de la tâche
  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une description';
    }
    return null;
  }

  /// Affiche le sélecteur d'heure et met à jour l'état
  ///
  /// [context] : Contexte pour afficher le sélecteur
  /// [isStartTime] : True pour l'heure de début, False pour l'heure de fin
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  /// Convertit un TimeOfDay en DateTime en utilisant la date sélectionnée
  ///
  /// [timeOfDay] : L'heure à convertir
  /// Retourne un DateTime combinant la date sélectionnée et l'heure fournie
  DateTime _timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = widget.selectedDate;
    return DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  /// Gère la soumission du formulaire
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        title: _titleController.text,
        content: _contentController.text,
        startTime: _timeOfDayToDateTime(_startTime),
        endTime: _timeOfDayToDateTime(_endTime),
        date: widget.selectedDate,
        notifyEnabled: _notifyEnabled,
      );
      widget.onTaskAdded(task);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Libération des ressources
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
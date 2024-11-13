// views/profile_view.dart
import 'package:flutter/material.dart';
import '../controllers/services/api_service.dart';
import '../models/task.dart';

class ProfileView extends StatelessWidget {
  final ApiService _apiService = ApiService();
  final List<Task> tasks;

  ProfileView({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Nombre de tâches: ${tasks.length}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Synchronisation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Synchronisation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _syncTasks(context),
                      child: const Text('Synchroniser les tâches'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _syncTasks(BuildContext context) async {
    try {
      // Dans un vrai cas, vous récupéreriez le token stocké
      const token = 'fake_token';

      // Afficher un indicateur de chargement
      _showLoadingDialog(context);

      await _apiService.syncTasks(tasks, token);

      // Fermer l'indicateur de chargement
      Navigator.pop(context);

      // Afficher un message de succès
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâches synchronisées avec succès')),
        );
      }
    } catch (e) {
      // Fermer l'indicateur de chargement
      Navigator.pop(context);

      // Afficher un message d'erreur
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la synchronisation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
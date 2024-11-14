import 'package:flutter/material.dart';
import '../controllers/services/api_service.dart';
import '../models/task.dart';

/// ProfileView est un widget qui affiche le profil utilisateur et permet la synchronisation des tâches.
/// Il présente les informations sur les tâches de l'utilisateur et offre une fonctionnalité
/// de synchronisation avec le serveur distant.
///
/// Cette vue nécessite une liste de tâches [Task] pour être initialisée.
class ProfileView extends StatelessWidget {
  /// Service pour gérer les appels API
  final ApiService _apiService = ApiService();

  /// Liste des tâches à afficher et à synchroniser
  final List<Task> tasks;

  /// Constructeur qui initialise la vue avec une liste de tâches requise
  ///
  /// [tasks] : Liste des tâches à afficher et potentiellement synchroniser
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
            _buildInfoSection(),
            const SizedBox(height: 16),
            _buildSyncSection(context),
          ],
        ),
      ),
    );
  }

  /// Construit la section d'informations contenant les statistiques des tâches
  Widget _buildInfoSection() {
    return Card(
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
    );
  }

  /// Construit la section de synchronisation avec le bouton de synchronisation
  Widget _buildSyncSection(BuildContext context) {
    return Card(
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
    );
  }

  /// Synchronise les tâches avec le serveur distant
  ///
  /// Cette méthode :
  /// 1. Affiche un indicateur de chargement
  /// 2. Tente de synchroniser les tâches via l'API
  /// 3. Affiche un message de succès ou d'erreur
  ///
  /// Une gestion des erreurs est implémentée pour informer l'utilisateur
  /// en cas d'échec de la synchronisation.
  ///
  /// [context] : BuildContext nécessaire pour les dialogues et les snackbars
  Future<void> _syncTasks(BuildContext context) async {
    try {
      // TODO: Implémenter une vraie gestion de token
      const token = 'fake_token';

      _showLoadingDialog(context);

      await _apiService.syncTasks(tasks, token);

      // Ferme le dialogue de chargement
      Navigator.pop(context);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tâches synchronisées avec succès')),
        );
      }
    } catch (e) {
      Navigator.pop(context);

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

  /// Affiche un dialogue de chargement non annulable
  ///
  /// [context] : BuildContext nécessaire pour afficher le dialogue
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
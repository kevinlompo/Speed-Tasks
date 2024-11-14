/// Point d'entrée principal de l'application de gestion de tâches.
/// Configure les services nécessaires et lance l'application.


import 'package:flutter/material.dart';
import 'package:speed_task/constant/task_list.dart';
import 'package:speed_task/controllers/services/notification_service.dart';
import 'package:speed_task/models/task.dart';
import 'package:speed_task/views/calendar_view.dart';
import 'package:speed_task/views/profile_view.dart';
import 'package:speed_task/views/login_view.dart';

/// Initialise l'application et les services nécessaires
///
/// Configure le service de notification et lance l'application
Future<void> main() async {
  // Assure que les widgets Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise le service de notification
  final notificationService = NotificationService();
  await notificationService.initNotification();

  // Lance l'application
  runApp(const MyApp());
}

/// Widget racine de l'application
///
/// Configure le thème et la navigation initiale de l'application
class MyApp extends StatelessWidget {
  /// Constructeur de l'application principale
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestionnaire de Tâches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginView(), // Écran de connexion comme point d'entrée
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Écran principal de l'application après authentification
///
/// Gère la navigation entre les différentes vues (Calendrier et Profil)
/// et maintient l'état des tâches
class MainScreen extends StatefulWidget {
  /// Constructeur de l'écran principal
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

/// État de l'écran principal gérant la navigation et les tâches
class MainScreenState extends State<MainScreen> {
  /// Index de la vue actuellement sélectionnée
  /// 0 = Calendrier, 1 = Profil
  int _selectedIndex = 0;

  /// Liste des tâches de l'utilisateur
  /// Initialisée avec la liste par défaut depuis task_list.dart
  final List<Task> _tasks = tasksList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  /// Construit le corps principal de l'application
  ///
  /// Utilise IndexedStack pour maintenir l'état des vues
  /// lors de la navigation
  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        CalendarView(tasks: _tasks),
        ProfileView(tasks: _tasks),
      ],
    );
  }

  /// Construit la barre de navigation inférieure
  ///
  /// Permet la navigation entre les différentes vues
  Widget _buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavigationItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendrier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  /// Gère la sélection d'un élément dans la barre de navigation
  ///
  /// [index] : Index de l'élément sélectionné
  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
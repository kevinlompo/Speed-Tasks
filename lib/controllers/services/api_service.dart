import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speed_task/models/task.dart';

class ApiService {
  static const String baseUrl = 'https://example.com/api';

  Future<void> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup/'),
        body: {'email': email, 'password': password},
      );
      // Gérer la réponse
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        body: {'email': email, 'password': password},
      );
      //String token = json.decode(response.body)['token'];
      // Retourner le token
      return 'token';
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<void> syncTasks(List<Task> tasks, String token) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/todo/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'tasks': tasks.map((t) => t.toJson()).toList()}),
      );
    } catch (e) {
      throw Exception('Erreur de synchronisation: $e');
    }
  }
}
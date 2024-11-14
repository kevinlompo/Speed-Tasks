import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:speed_task/models/task.dart';

/// ApiService gère toutes les interactions avec l'API backend.
/// Cette classe fournit des méthodes pour l'authentification
/// et la synchronisation des tâches avec le serveur.
class ApiService {
  /// URL de base de l'API
  /// TODO: À configurer selon l'environnement (dev, prod)
  static const String baseUrl = 'https://example.com/api';

  /// Crée un nouveau compte utilisateur
  ///
  /// [email] : L'adresse email de l'utilisateur
  /// [password] : Le mot de passe choisi
  ///
  /// Throws [Exception] si l'inscription échoue
  Future<void> signup(String email, String password) async {
    try {
      final response = await _performRequest(
        endpoint: '/signup/',
        method: HttpMethod.post,
        body: {'email': email, 'password': password},
      );

      _validateResponse(response, 'inscription');

      // TODO: Implémenter le traitement de la réponse
    } catch (e) {
      throw Exception('Erreur d\'inscription: $e');
    }
  }

  /// Authentifie un utilisateur et récupère son token
  ///
  /// [email] : L'adresse email de l'utilisateur
  /// [password] : Le mot de passe de l'utilisateur
  ///
  /// Returns un token d'authentification
  /// Throws [Exception] si la connexion échoue
  Future<String> login(String email, String password) async {
    try {
      final response = await _performRequest(
        endpoint: '/login/',
        method: HttpMethod.post,
        body: {'email': email, 'password': password},
      );

      _validateResponse(response, 'connexion');

      // TODO: Décommenter et implémenter la récupération du vrai token
      //return json.decode(response.body)['token'];
      return 'token'; // Token temporaire pour le développement
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Synchronise une liste de tâches avec le serveur
  ///
  /// [tasks] : Liste des tâches à synchroniser
  /// [token] : Token d'authentification de l'utilisateur
  ///
  /// Throws [Exception] si la synchronisation échoue
  Future<void> syncTasks(List<Task> tasks, String token) async {
    try {
      final response = await _performRequest(
        endpoint: '/todo/',
        method: HttpMethod.post,
        body: {'tasks': tasks.map((t) => t.toJson()).toList()},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        useJsonEncoding: true,
      );

      _validateResponse(response, 'synchronisation');
    } catch (e) {
      throw Exception('Erreur de synchronisation: $e');
    }
  }

  /// Effectue une requête HTTP vers l'API
  ///
  /// [endpoint] : Point d'entrée de l'API à appeler
  /// [method] : Méthode HTTP à utiliser
  /// [body] : Corps de la requête (optionnel)
  /// [headers] : En-têtes de la requête (optionnel)
  /// [useJsonEncoding] : Indique si le corps doit être encodé en JSON
  ///
  /// Returns la réponse HTTP
  Future<http.Response> _performRequest({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool useJsonEncoding = false,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = headers ?? {};
    final encodedBody = useJsonEncoding ? json.encode(body) : body;

    switch (method) {
      case HttpMethod.get:
        return await http.get(uri, headers: requestHeaders);
      case HttpMethod.post:
        return await http.post(uri, headers: requestHeaders, body: encodedBody);
      case HttpMethod.put:
        return await http.put(uri, headers: requestHeaders, body: encodedBody);
      case HttpMethod.delete:
        return await http.delete(uri, headers: requestHeaders);
    }
  }

  /// Valide la réponse de l'API
  ///
  /// [response] : Réponse HTTP à valider
  /// [operation] : Nom de l'opération pour le message d'erreur
  ///
  /// Throws [Exception] si la réponse n'est pas valide
  void _validateResponse(http.Response response, String operation) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      //throw Exception('Erreur lors de l\'$operation: ${response.statusCode}');
    }
  }
}

/// Énumération des méthodes HTTP supportées
enum HttpMethod {
  get,
  post,
  put,
  delete,
}
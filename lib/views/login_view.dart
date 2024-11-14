import 'package:flutter/material.dart';
import '../controllers/services/api_service.dart';
import '../main.dart';

/// LoginView est un widget qui gère l'authentification des utilisateurs.
/// Il fournit une interface pour la connexion et l'inscription,
/// avec possibilité de basculer entre les deux modes.
class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /// Clé globale pour le formulaire permettant la validation
  final _formKey = GlobalKey<FormState>();

  /// Contrôleur pour le champ email
  final _emailController = TextEditingController();

  /// Contrôleur pour le champ mot de passe
  final _passwordController = TextEditingController();

  /// Service pour gérer les appels API d'authentification
  final ApiService _apiService = ApiService();

  /// Détermine si l'utilisateur est en mode connexion (true) ou inscription (false)
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Connexion' : 'Inscription'),
      ),
      body: _buildLoginForm(),
    );
  }

  /// Construit le formulaire de connexion/inscription
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            _buildToggleButton(),
          ],
        ),
      ),
    );
  }

  /// Construit le champ de saisie pour l'email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  /// Construit le champ de saisie pour le mot de passe
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Mot de passe'),
      obscureText: true,
      validator: _validatePassword,
    );
  }

  /// Construit le bouton de soumission du formulaire
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      child: Text(_isLogin ? 'Se connecter' : 'S\'inscrire'),
    );
  }

  /// Construit le bouton pour basculer entre connexion et inscription
  Widget _buildToggleButton() {
    return TextButton(
      onPressed: _toggleAuthMode,
      child: Text(_isLogin
          ? 'Pas de compte ? S\'inscrire'
          : 'Déjà un compte ? Se connecter'),
    );
  }

  /// Valide le format de l'email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    // Possibilité d'ajouter une validation plus poussée du format email
    return null;
  }

  /// Valide le mot de passe
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    // Possibilité d'ajouter des règles de validation du mot de passe
    return null;
  }

  /// Bascule entre les modes connexion et inscription
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  /// Gère la soumission du formulaire
  ///
  /// Cette méthode :
  /// 1. Valide les champs du formulaire
  /// 2. Effectue la connexion ou l'inscription selon le mode
  /// 3. Gère la navigation et les messages de retour
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isLogin) {
          await _handleLogin();
        } else {
          await _handleSignup();
        }
      } catch (e) {
        _showErrorMessage(e.toString());
      }
    }
  }

  /// Gère le processus de connexion
  Future<void> _handleLogin() async {
    final token = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  /// Gère le processus d'inscription
  Future<void> _handleSignup() async {
    await _apiService.signup(
      _emailController.text,
      _passwordController.text,
    );

    if (context.mounted) {
      _showSuccessMessage('Inscription réussie !');
      setState(() {
        _isLogin = true;
      });
    }
  }

  /// Affiche un message d'erreur
  void _showErrorMessage(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  /// Affiche un message de succès
  void _showSuccessMessage(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  void dispose() {
    // Libération des ressources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
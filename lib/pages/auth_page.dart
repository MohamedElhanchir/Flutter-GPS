import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final String validUsername = 'admin';
  final String validPassword = 'admin';

  void _login() {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;
    if (enteredUsername == validUsername && enteredPassword == validPassword) {
      // Authentification réussie, naviguez vers la page de la carte
      Navigator.pushReplacementNamed(context, '/image_selection');
    } else {
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _login,
                icon: Icon(Icons.login), // Ajoutez l'icône ici
                label: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

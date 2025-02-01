import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In',
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _sendTokenToBackend();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("Error en Google Sign-In: $error");
    }
  }

  Future<void> _sendTokenToBackend() async {
    final GoogleSignInAuthentication? googleAuth =
        await _currentUser?.authentication;
    if (googleAuth?.idToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/google-signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": googleAuth?.idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Usuario autenticado con éxito: $responseData");
      } else {
        print("Error al autenticar en el backend: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Sign-In")),
      body: Center(
        child: _currentUser == null
            ? ElevatedButton(
                onPressed: _handleSignIn,
                child: Text("Continuar con Google"),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bienvenido, ${_currentUser!.displayName}"),
                  ElevatedButton(
                    onPressed: () async {
                      await _googleSignIn.signOut();
                      setState(() {
                        _currentUser = null;
                      });
                    },
                    child: Text("Cerrar sesión"),
                  ),
                ],
              ),
      ),
    );
  }
}

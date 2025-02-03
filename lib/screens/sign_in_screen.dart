import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import '../theme/app_buttons.dart';
import '../widgets/error_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  GoogleSignInAccount? _currentUser;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        _validateInstitutionalEmail(account);
      } else {
        setState(() {
          _currentUser = null;
        });
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _validateInstitutionalEmail(account);
      }
    } catch (error) {
      print("Error en Google Sign-In: $error");
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
      _errorMessage = null;
    });
  }

  void _validateInstitutionalEmail(GoogleSignInAccount account) async {
    if (!account.email.endsWith("@continental.edu.pe")) {
      setState(() {
        _errorMessage = "Debes iniciar sesión con tu correo institucional.";
        _currentUser = null;
      });
      _googleSignIn.signOut();
    } else {
      setState(() {
        _currentUser = account;
        _errorMessage = null;
      });
      
      // Enviar token a backend y obtener datos del usuario
      UserModel? user = await AuthService.sendTokenToBackend(account);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: user, isFirstLogin: true),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo_app.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground.withOpacity(0.80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo_universidad_blanco.png', height: 68),
                  const SizedBox(height: 15),
                  const Text("¡Estamos ContiGO!", style: AppStyles.titleStyle),
                  const SizedBox(height: 10),
                  const Text("Inicia sesión con tu correo institucional", style: AppStyles.subtitleStyle),
                  const SizedBox(height: 30),

                  if (_currentUser != null) ...[
                    Text(
                      "Bienvenido, ${_currentUser!.displayName}",
                      style: AppStyles.titleStyle.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleSignOut,
                        child: Text("Cerrar sesión", style: AppStyles.buttonTextStyle),
                      ),
                    ),
                  ] else ...[
                    GoogleSignInButton(onPressed: _handleSignIn),
                  ],

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 20),
                    ErrorMessage(message: _errorMessage!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
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

  void _validateInstitutionalEmail(GoogleSignInAccount account) {
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
      AuthService.sendTokenToBackend(account);
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground.withOpacity(0.80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo_universidad_blanco.png', height: 75),
                  const SizedBox(height: 15),
                  const Text("¡Estamos ContiGO!", style: AppStyles.titleStyle),
                  const SizedBox(height: 10),
                  const Text("Inicia sesión con tu correo institucional", style: AppStyles.subtitleStyle),
                  const SizedBox(height: 30),

                  // Si el usuario está autenticado, mostramos su nombre y los botones
                  if (_currentUser != null) ...[
                    Text(
                      "Bienvenido, ${_currentUser!.displayName}",
                      style: AppStyles.titleStyle.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Botón para ir a la Home
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                        },
                        child: Text("Ir a la Home", style: AppStyles.buttonTextStyle),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Botón para cerrar sesión
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _handleSignOut,
                        child: Text("Cerrar sesión", style: AppStyles.buttonTextStyle),
                      ),
                    ),
                  ] else ...[
                    // Si el usuario no ha iniciado sesión, mostramos el botón de Google
                    GoogleSignInButton(onPressed: _handleSignIn),
                  ],

                  // Mostrar mensaje de error si hay
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

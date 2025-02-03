import 'package:flutter/material.dart';
import 'screens/sign_in_screen.dart';
import 'screens/profile_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      // onGenerateRoute para manejar la navegación y pasar argumentos
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => SignInScreen());
          case '/profile':
            // Se espera que se envíe un UserModel a través de settings.arguments
            final user = settings.arguments as UserModel;
            return MaterialPageRoute(
                builder: (_) => ProfileScreen(user: user, isFirstLogin: true));
          default:
            return MaterialPageRoute(builder: (_) => SignInScreen());
        }
      },
    );
  }
}

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<void> sendTokenToBackend(GoogleSignInAccount user) async {
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    
    if (googleAuth.idToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/google-signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": googleAuth.idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Usuario autenticado con éxito: $responseData");
      } else {
        print("Error al autenticar en el backend: ${response.body}");
      }
    }
  }
}

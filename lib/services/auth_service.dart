import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:3000/auth"; // Host

  // Enviar token de Google al backend
  static Future<UserModel?> sendTokenToBackend(GoogleSignInAccount user) async {
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    
    if (googleAuth.idToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/google-signin'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": googleAuth.idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return UserModel.fromJson(responseData['usuario']); // Se convierte la respuesta a UserModel
      } else {
        print("Error al autenticar en el backend: ${response.body}");
        return null;
      }
    }
    return null;
  }

  // Método para actualizar el perfil del usuario en el backend
  static Future<bool> updateUserProfile(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-profile'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": user.id,
        "telefono": user.telefono,
        "sede": user.sede,
        "ciclo": user.rol == "estudiante" ? user.ciclo : null,
        "carrera": user.rol == "estudiante" ? user.carrera : null,
        "modalidad": user.rol == "estudiante" ? user.modalidad?.toLowerCase().replaceAll(' ', '_') : null,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error al actualizar perfil: ${response.body}");
      return false;
    }
  }

  // Método para cerrar sesión
  static Future<void> signOut() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
  }
}
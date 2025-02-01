class UserModel {
  final String id;
  final String nombre;
  final String correo;
  final String rol;

  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      rol: json['rol'],
    );
  }
}

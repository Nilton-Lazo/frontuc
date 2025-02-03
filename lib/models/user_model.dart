class UserModel {
  final int id;
  final String nombre;
  final String correo;
  final String? telefono;
  final String? rol;
  final String? codigo;
  final String? ciclo;
  final String? carrera;
  final String? modalidad;
  final String? sede;
  final String? foto;

  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    this.telefono,
    this.rol,
    this.codigo,
    this.ciclo,
    this.carrera,
    this.modalidad,
    this.sede,
    this.foto,
  });

  // Método para convertir un JSON a UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      telefono: json['telefono'],
      rol: json['rol'],
      codigo: json['codigo'],
      ciclo: json['ciclo'] != null ? json['ciclo'].toString() : null, // Convertir a String
      carrera: json['carrera'],
      modalidad: json['modalidad'],
      sede: json['sede'],
      foto: json['foto'],
    );
  }

  // Método copyWith para actualizar solo algunos valores sin perder los existentes
  UserModel copyWith({
    String? telefono,
    String? sede,
    String? ciclo,
    String? carrera,
    String? modalidad,
  }) {
    return UserModel(
      id: id,
      nombre: nombre,
      correo: correo,
      telefono: telefono ?? this.telefono,
      rol: rol,
      codigo: codigo,
      ciclo: ciclo ?? this.ciclo,
      carrera: carrera ?? this.carrera,
      modalidad: modalidad ?? this.modalidad,
      sede: sede ?? this.sede,
      foto: foto,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/app_styles.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../widgets/error_message.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final bool isFirstLogin;

  const ProfileScreen({Key? key, required this.user, required this.isFirstLogin})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController telefonoController;
  late TextEditingController cicloController;
  bool isEditing = false;
  String? selectedSede;
  String? selectedCarrera;
  String? selectedModalidad;
  String? errorMessage;

  final List<String> sedes = ['Huancayo', 'Arequipa', 'Cusco', 'Lima - Los Olivos'];
  final List<String> carreras = [
    'Administración',
    'Administración y Finanzas',
    'Administración y Gestión Pública',
    'Administración y Gestión del Talento Humano',
    'Administración y Marketing',
    'Administración y Negocios Digitales',
    'Administración y Negocios Internacionales',
    'Arquitectura',
    'Arquitectura y Diseño de Interiores',
    'Ciencia de la Computación',
    'Ciencias de la Comunicación',
    'Contabilidad y Finanzas',
    'Derecho',
    'Economía',
    'Educación con especialidad en innovación y aprendizaje digital',
    'Enfermería',
    'Farmacia y Bioquímica',
    'Ingeniería Ambiental',
    'Ingeniería Civil',
    'Ingeniería Eléctrica',
    'Ingeniería Empresarial',
    'Ingeniería Industrial',
    'Ingeniería Mecánica',
    'Ingeniería Mecatrónica',
    'Ingeniería de Minas',
    'Ingeniería de Sistemas e Informática',
    'Medicina Humana',
    'Nutrición y Dietética',
    'Odontología',
    'Psicología',
    'Tecnología Médica – Especialidad en Terapia Física y Rehabilitación',
    'Tecnología Médica - Radiología',
    'Tecnología Médica – Laboratorio Clínico y Anatomía Patológica'
  ];
  final List<String> modalidades = ['Presencial', 'Semipresencial', 'A distancia'];

  // Estilos comunes para contenido y hint
  final TextStyle fieldTextStyle = const TextStyle(fontSize: 16, color: Colors.black);
  final TextStyle fieldHintStyle = TextStyle(fontSize: 16, color: Colors.grey[600]);

  @override
  void initState() {
    super.initState();
    telefonoController = TextEditingController(text: widget.user.telefono ?? '');
    cicloController = TextEditingController(
        text: widget.user.rol == "estudiante" ? widget.user.ciclo ?? '' : '');
    selectedSede = widget.user.sede;
    selectedCarrera = widget.user.carrera;
    selectedModalidad = widget.user.modalidad;

    telefonoController.addListener(_validateFields);
    cicloController.addListener(_validateFields);

    if (widget.isFirstLogin) {
      isEditing = true;
    }
  }

  @override
  void dispose() {
    telefonoController.dispose();
    cicloController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      String telefono = telefonoController.text;
      String cicloText = cicloController.text;
      int? ciclo = int.tryParse(cicloText);

      List<String> errors = [];

      if (telefono.isNotEmpty && telefono.length != 9) {
        errors.add("Ingrese un número de celular válido.");
      }
      if (widget.user.rol == "estudiante" &&
          cicloText.isNotEmpty &&
          (ciclo == null || ciclo < 1 || ciclo > 14)) {
        errors.add("El ciclo debe estar entre 1 y 14.");
      }

      errorMessage = errors.isNotEmpty ? errors.join("\n") : null;
    });
  }

  bool _isValid() {
    if (telefonoController.text.isEmpty || selectedSede == null) return false;
    if (widget.user.rol == "estudiante") {
      if (cicloController.text.isEmpty ||
          selectedCarrera == null ||
          selectedModalidad == null) {
        return false;
      }
    }
    return errorMessage == null;
  }

  Future<void> _saveProfile() async {
    if (!_isValid()) return;

    UserModel updatedUser = widget.user.copyWith(
      telefono: telefonoController.text,
      sede: selectedSede,
      ciclo: widget.user.rol == "estudiante" ? cicloController.text : null,
      carrera: widget.user.rol == "estudiante" ? selectedCarrera : null,
      modalidad: widget.user.rol == "estudiante" ? selectedModalidad : null,
    );

    bool success = await AuthService.updateUserProfile(updatedUser);
    if (success) {
      setState(() {
        isEditing = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        errorMessage = "Error interno del servidor.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Mi Perfil",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: AppColors.secondaryBackground.withOpacity(0.9),
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.user.foto ?? ''),
                ),
                const SizedBox(height: 10),
                Text(widget.user.nombre ?? 'Usuario',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Orden de campos: Correo, Teléfono, Ciclo, Carrera, Modalidad, Sede
                _buildTextField(
                    "Correo",
                    TextEditingController(
                        text: widget.user.correo ?? 'No disponible'),
                    false),
                _buildTextField("Teléfono", telefonoController, isEditing,
                    TextInputType.number),
                if (widget.user.rol == "estudiante") ...[
                  _buildTextField("Ciclo", cicloController, isEditing,
                      TextInputType.number),
                  _buildDropdown("Carrera", selectedCarrera, carreras, isEditing,
                      (value) => setState(() => selectedCarrera = value)),
                  _buildDropdown("Modalidad", selectedModalidad, modalidades, isEditing,
                      (value) => setState(() => selectedModalidad = value)),
                ],
                _buildDropdown("Sede", selectedSede, sedes, isEditing,
                    (value) => setState(() => selectedSede = value)),
                const SizedBox(height: 10),
                if (errorMessage != null)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ErrorMessage(message: errorMessage!),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isValid() ? _saveProfile : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: AppColors.primaryColor.withOpacity(0.9),
                  ),
                  child: const Text("Guardar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// TextField uniforme con contenido alineado a la izquierda
  Widget _buildTextField(String label, TextEditingController controller, bool isEditable,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextField(
          controller: controller,
          enabled: isEditable,
          keyboardType: keyboardType,
          style: fieldTextStyle,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: fieldHintStyle,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  /// Dropdown uniforme que muestra el hint dentro del campo, tiene una altura fija en el botón,
  /// y limita la altura máxima del menú desplegable con "maxHeight".
  Widget _buildDropdown(String label, String? selectedValue, List<String> options,
      bool editable, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: DropdownButtonFormField2<String>(
          value: selectedValue,
          hint: Text(
            label,
            style: fieldHintStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          isExpanded: true,
          onChanged: editable ? onChanged : null,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          buttonStyleData: ButtonStyleData(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            maxHeight: 200,
          ),
          style: fieldTextStyle,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                height: 56,
                alignment: Alignment.centerLeft,
                child: Text(
                  option,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fieldTextStyle,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

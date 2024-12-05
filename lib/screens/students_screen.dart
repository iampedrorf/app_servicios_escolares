

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/student.dart';

class StudentsScreen extends StatefulWidget {
  final Estudiante? estudiante;
  final Function(Estudiante) onStudentUpdated; // Callback

  StudentsScreen(
      {this.estudiante,
      required this.onStudentUpdated}); // Recibe un estudiante para editarlo

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController birthDateController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController gradeController;
  late TextEditingController enrollmentController;
  late TextEditingController groupController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores del estudiante
    nameController =
        TextEditingController(text: widget.estudiante?.nombre ?? '');
    lastNameController =
        TextEditingController(text: widget.estudiante?.apellidos ?? '');
    birthDateController = TextEditingController(
        text: widget.estudiante?.fechaNacimiento?.toString() ?? '');
    emailController =
        TextEditingController(text: widget.estudiante?.correo ?? '');
    phoneController =
        TextEditingController(text: widget.estudiante?.telefono ?? '');
    addressController =
        TextEditingController(text: widget.estudiante?.direccion ?? '');
    gradeController =
        TextEditingController(text: widget.estudiante?.grado ?? '');
    enrollmentController =
        TextEditingController(text: widget.estudiante?.matricula ?? '');
    groupController =
        TextEditingController(text: widget.estudiante?.grupo ?? '');
  }

  void updateStudent() {
    if (widget.estudiante != null) {
      setState(() {
        widget.estudiante!.nombre = nameController.text;
        widget.estudiante!.apellidos = lastNameController.text;
        widget.estudiante!.fechaNacimiento =
            DateTime.parse(birthDateController.text);
        widget.estudiante!.correo = emailController.text;
        widget.estudiante!.telefono = phoneController.text;
        widget.estudiante!.direccion = addressController.text;
        widget.estudiante!.grado = gradeController.text;
        widget.estudiante!.matricula = enrollmentController.text;
        widget.estudiante!.grupo = groupController.text;
      });
    }

    widget.onStudentUpdated(widget.estudiante!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text(
          "¡Alumno actualizado exitosamente!",
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context); // Regresar a la lista de estudiantes
  }

  void addStudent() {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        gradeController.text.isEmpty ||
        enrollmentController.text.isEmpty ||
        groupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "¡Porfavor completa todos los campos!",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return; // No continuar con el registro
    }

    final nuevoEstudiante = Estudiante(
      id: '${estudiantesRegistrados.length + 1}',
      nombre: nameController.text,
      apellidos: lastNameController.text,
      fechaNacimiento: DateTime.parse(birthDateController.text),
      correo: emailController.text,
      telefono: phoneController.text,
      direccion: addressController.text,
      grado: gradeController.text,
      matricula: enrollmentController.text,
      grupo: groupController.text,
      materias: [],
      urlFotoPerfil: '',
    );

    setState(() {
      estudiantesRegistrados.add(nuevoEstudiante);
    });

    // Limpiar campos después de registrar
    nameController.clear();
    lastNameController.clear();
    birthDateController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    gradeController.clear();
    enrollmentController.clear();
    groupController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text(
          "¡Alumno registrado exitosamente!",
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        birthDateController.text =
            '${pickedDate.toLocal()}'.split(' ')[0]; // Formato 'YYYY-MM-DD'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Alumnos',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, 'Nombre'),
              _buildTextField(lastNameController, 'Apellidos'),
              _buildDateField(
                  context, birthDateController, 'Fecha de Nacimiento'),
              _buildTextField(emailController, 'Correo Electrónico',
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(phoneController, 'Teléfono',
                  keyboardType: TextInputType.phone),
              _buildTextField(addressController, 'Dirección'),
              _buildTextField(gradeController, 'Grado'),
              _buildTextField(enrollmentController, 'Matrícula'),
              _buildTextField(groupController, 'Grupo'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.estudiante == null
                    ? addStudent
                    : updateStudent, // Llama a updateStudent si estamos editando
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // Mismo color que el AppBar
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  widget.estudiante == null
                      ? 'Registrar Alumno'
                      : 'Actualizar Alumno',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }
}
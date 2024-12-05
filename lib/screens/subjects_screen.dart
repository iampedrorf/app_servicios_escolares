import 'package:flutter/material.dart';
import '../main.dart';
import '../models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  final Subject? subject;
  final Function(Subject)
      onSubjectUpdated; // Callback para actualizar la lista de materias

  SubjectsScreen({this.subject, required this.onSubjectUpdated});

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController descriptionController;
  late TextEditingController professorController;
  late TextEditingController creditsController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores de la materia si se está editando
    nameController = TextEditingController(text: widget.subject?.nombre ?? '');
    codeController = TextEditingController(text: widget.subject?.codigo ?? '');
    descriptionController =
        TextEditingController(text: widget.subject?.descripcion ?? '');
    professorController =
        TextEditingController(text: widget.subject?.profesor ?? '');
    creditsController =
        TextEditingController(text: widget.subject?.creditos.toString() ?? '');
  }

  void updateSubject() {
    if (widget.subject != null) {
      // Crear un nuevo objeto Subject con los valores actualizados
      final updatedSubject = Subject(
        id: widget.subject!.id, // Mantén el mismo ID
        nombre: nameController.text,
        codigo: codeController.text,
        descripcion: descriptionController.text,
        profesor: professorController.text,
        creditos: int.tryParse(creditsController.text) ?? 0,
      );

      // Llama a la función onSubjectUpdated con el nuevo objeto Subject
      widget.onSubjectUpdated(updatedSubject);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.teal,
          content: Text(
            "¡Materia actualizada exitosamente!",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Regresar a la lista de materias
    }
  }

  void addSubject() {
    if (nameController.text.isEmpty ||
        codeController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        professorController.text.isEmpty ||
        creditsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "¡Por favor completa todos los campos!",
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newSubject = Subject(
      id: '${materiasRegistradas.length + 1}', // Suponiendo que tienes una lista de materias
      nombre: nameController.text,
      codigo: codeController.text,
      descripcion: descriptionController.text,
      profesor: professorController.text,
      creditos: int.tryParse(creditsController.text) ?? 0,
    );

    setState(() {
      materiasRegistradas.add(newSubject);
    });

    // Limpiar campos después de registrar
    nameController.clear();
    codeController.clear();
    descriptionController.clear();
    professorController.clear();
    creditsController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.teal,
        content: Text(
          "¡Materia registrada exitosamente!",
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Materias',
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
              _buildTextField(codeController, 'Código'),
              _buildTextField(descriptionController, 'Descripción'),
              _buildTextField(professorController, 'Profesor'),
              _buildTextField(creditsController, 'Créditos',
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.subject == null
                    ? addSubject
                    : updateSubject, // Llama a updateSubject si estamos editando
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // Mismo color que el AppBar
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  widget.subject == null
                      ? 'Registrar Materia'
                      : 'Actualizar Materia',
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
}

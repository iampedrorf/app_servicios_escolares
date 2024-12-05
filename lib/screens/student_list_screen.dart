

import 'package:flutter/material.dart';
import '../models/student.dart';
import 'students_screen.dart'; // Para navegar hacia la pantalla de editar

class StudentsListScreen extends StatefulWidget {
  final List<Estudiante> estudiantesRegistrados;

  StudentsListScreen({required this.estudiantesRegistrados});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  void deleteStudent(int index, BuildContext context) {
    setState(() {
      widget.estudiantesRegistrados.removeAt(index); // Eliminar el estudiante
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "¡Estudiante Eliminado Exitosamente!",
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void updateStudentInList(Estudiante updatedStudent) {
    setState(() {
      int index = widget.estudiantesRegistrados.indexWhere(
        (estudiante) => estudiante.id == updatedStudent.id,
      );
      if (index != -1) {
        widget.estudiantesRegistrados[index] = updatedStudent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Alumnos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: widget.estudiantesRegistrados.isEmpty
          ? Center(
              child: Text(
                'No hay estudiantes registrados.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.estudiantesRegistrados.length,
              itemBuilder: (context, index) {
                final estudiante = widget.estudiantesRegistrados[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        estudiante.nombre.substring(0, 1).toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${estudiante.nombre} ${estudiante.apellidos}'),
                    subtitle: Text(
                      'Grado: ${estudiante.grado}, Grupo: ${estudiante.grupo}\n'
                      'Matrícula: ${estudiante.matricula}\n'
                      'Teléfono: ${estudiante.telefono}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteStudent(index, context),
                    ),
                    onTap: () {
                      // Navegar a la pantalla de edición
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentsScreen(
                            estudiante: estudiante,
                            onStudentUpdated: updateStudentInList,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
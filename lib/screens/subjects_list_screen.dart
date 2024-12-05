import 'package:app_servicio_escolar/screens/subjects_screen.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart'; // Asegúrate de tener el modelo de Materia en esta ruta

class SubjectsListScreen extends StatefulWidget {
  final List<Subject> subjectsRegistradas;

  SubjectsListScreen({required this.subjectsRegistradas});

  @override
  State<SubjectsListScreen> createState() => _SubjectsListScreenState();
}

class _SubjectsListScreenState extends State<SubjectsListScreen> {
  void deleteSubject(int index, BuildContext context) {
    setState(() {
      widget.subjectsRegistradas.removeAt(index); // Eliminar la materia
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "¡Materia Eliminada Exitosamente!",
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void updateSubjectsInList(Subject updatedSubject) {
    setState(() {
      int index = widget.subjectsRegistradas.indexWhere(
        (subject) => subject.id == updatedSubject.id,
      );
      if (index != -1) {
        widget.subjectsRegistradas[index] = updatedSubject;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Materias Registradas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: widget.subjectsRegistradas.isEmpty
          ? Center(
              child: Text(
                'No hay materias registradas.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.subjectsRegistradas.length,
              itemBuilder: (context, index) {
                final subject = widget.subjectsRegistradas[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ListTile(
                      title: Text(
                        '${subject.nombre} (${subject.codigo})',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Profesor: ${subject.profesor}\n'
                        'Créditos: ${subject.creditos}\n'
                        'Descripción: ${subject.descripcion}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteSubject(index, context),
                      ),
                      onTap: () {
                        // Navegar a la pantalla de edición y pasar la materia seleccionada
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectsScreen(
                              subject: subject,
                              onSubjectUpdated: updateSubjectsInList,
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
    );
  }
}

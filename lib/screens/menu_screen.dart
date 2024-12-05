import 'package:app_servicio_escolar/screens/student_list_screen.dart';
import 'package:app_servicio_escolar/screens/subjects_list_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/student.dart';
import '../models/subject.dart';
import 'login_screen.dart';
import 'students_screen.dart';
import 'subjects_screen.dart';
import 'enrollment_screen.dart';
import 'grades_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void updateStudentInList(Estudiante updatedStudent) {
    setState(() {
      int index = estudiantesRegistrados.indexWhere(
        (estudiante) => estudiante.id == updatedStudent.id,
      );
      if (index != -1) {
        estudiantesRegistrados[index] = updatedStudent;
      }
    });
  }

  void updateSubjectsInList(Subject updatedSubject) {
    setState(() {
      int index = materiasRegistradas.indexWhere(
        (estudiante) => estudiante.id == updatedSubject.id,
      );
      if (index != -1) {
        materiasRegistradas[index] = updatedSubject;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú Principal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white, // Cambié el color del ícono a blanco
              size: 30.0, // Asegúrate de que el tamaño sea adecuado
            ),
            onPressed: () {
              // Navegar a la pantalla de Login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos Cards por fila
          crossAxisSpacing: 16.0, // Espacio horizontal entre las Cards
          mainAxisSpacing: 16.0, // Espacio vertical entre las Cards
        ),
        itemCount: 6, // Número de items
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
            ),
            elevation: 6.0, // Sombra para dar profundidad
            color: _getCardColor(index), // Color dinámico para cada Card
            child: InkWell(
              onTap: () {
                _onCardTap(context, index);
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _getIcon(index),
                      size: 50.0,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _getTitle(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Función para obtener el color de cada Card
  Color _getCardColor(int index) {
    switch (index) {
      case 0:
        return Colors.lightBlue[300]!;
      case 1:
        return Colors.green[300]!;
      case 2:
        return Colors.orange[300]!;
      case 3:
        return Colors.purple[300]!;
      case 4:
        return Colors.pink[300]!;
      case 5:
        return Colors.teal[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  // Función para obtener el icono correspondiente
  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.group;
      case 1:
        return Icons.list_alt;
      case 2:
        return Icons.library_books;
      case 3:
        return Icons.check_circle;
      case 4:
        return Icons.assignment;
      case 5:
        return Icons.grade;
      default:
        return Icons.help;
    }
  }

  // Función para obtener el título de cada Card
  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Gestión de Alumnos';
      case 1:
        return 'Alumnos Registrados';
      case 2:
        return 'Gestión de Materias';
      case 3:
        return 'Materias Registradas';
      case 4:
        return 'Inscripción de Alumnos';
      case 5:
        return 'Captura de Calificaciones';
      default:
        return 'Opción Desconocida';
    }
  }

  // Función para manejar la acción de clic en cada Card
  void _onCardTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentsScreen(
                    onStudentUpdated: updateStudentInList,
                  )),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentsListScreen(
                estudiantesRegistrados: estudiantesRegistrados),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubjectsScreen(
                    onSubjectUpdated: updateSubjectsInList,
                  )),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubjectsListScreen(
                    subjectsRegistradas: materiasRegistradas,
                  )),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EnrollmentScreen()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GradesScreen()),
        );
        break;
      default:
        break;
    }
  }
}

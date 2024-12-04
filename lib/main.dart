import 'package:flutter/material.dart';
import 'models/student.dart';
import 'models/subject.dart';
import 'screens/login_screen.dart';

final List<Estudiante> estudiantesRegistrados = [];
final List<Subject> materiasRegistradas = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión Escolar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
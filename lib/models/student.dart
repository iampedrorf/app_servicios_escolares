import 'subject.dart';

class Estudiante {
  String id;
  String nombre;
  String apellidos;
  DateTime fechaNacimiento;
  String correo;
  String telefono;
  String direccion;
  String grado;
  String matricula;
  String grupo;
  List<Subject> materias;
  String urlFotoPerfil;
  bool activo;
  DateTime fechaRegistro;

  Estudiante({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.correo,
    required this.telefono,
    required this.direccion,
    required this.grado,
    required this.matricula,
    required this.grupo,
    required this.materias,
    required this.urlFotoPerfil,
    this.activo = true,
    DateTime? fechaRegistro,
  }) : this.fechaRegistro = fechaRegistro ?? DateTime.now();
}
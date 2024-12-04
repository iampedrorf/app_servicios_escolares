class Subject {
  final String id;
  late final String nombre;
  late final String codigo;
  late final String descripcion;
  late final String profesor;
  late final int creditos;
  late final double? calificacion;

  Subject(
      {required this.id,
      required this.nombre,
      required this.codigo,
      required this.descripcion,
      required this.profesor,
      required this.creditos,
      this.calificacion});
}
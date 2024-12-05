import 'package:flutter/material.dart';
import '../main.dart';
import '../models/student.dart';
import '../models/subject.dart';

class EnrollmentScreen extends StatefulWidget {
  @override
  _EnrollmentScreenState createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  // Estudiante seleccionado
  Estudiante? selectedStudent;

  // Materias seleccionadas
  List<Subject> selectedSubjects = [];

  // Método para mostrar el ModalBottomSheet con búsqueda
  void showSearchModal<T>({
    required BuildContext context,
    required List<T> items,
    required String title,
    required String Function(T) getItemName,
    required void Function(T) onItemSelected,
    required List<T> selectedItems,
    bool isMultiSelect = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final TextEditingController searchController = TextEditingController();
        List<T> filteredItems = items;

        return FractionallySizedBox(
            heightFactor: 0.4, // Ocupa el 60% de la altura de la pantalla
            widthFactor: 0.95,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: searchController,
                        onChanged: (query) {
                          setModalState(() {
                            filteredItems = items
                                .where((item) => getItemName(item)
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = selectedItems.contains(item);

                            return ListTile(
                              title: Text(getItemName(item)),
                              trailing: isMultiSelect
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        setModalState(() {
                                          if (value == true) {
                                            selectedItems.add(item);
                                          } else {
                                            selectedItems.remove(item);
                                          }
                                        });
                                      },
                                    )
                                  : null,
                              onTap: isMultiSelect
                                  ? null
                                  : () {
                                      onItemSelected(item);
                                      Navigator.pop(context);
                                    },
                            );
                          },
                        ),
                      ),
                      if (isMultiSelect)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Confirmar Selección",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inscripción de Alumnos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de alumno
            Text(
              'Selecciona un Alumno:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showSearchModal<Estudiante>(
                  context: context,
                  items: estudiantesRegistrados,
                  title: 'Selecciona un Alumno',
                  getItemName: (item) => item.nombre,
                  selectedItems: [],
                  onItemSelected: (selected) {
                    setState(() {
                      selectedStudent = selected;
                      selectedSubjects = selectedStudent?.materias ?? [];
                    });
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal),
                ),
                child: Text(
                  selectedStudent?.nombre ?? 'Seleccionar Alumno',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Mostrar materias disponibles
            Text(
              'Selecciona las Materias:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showSearchModal<Subject>(
                  context: context,
                  items: materiasRegistradas,
                  title: 'Selecciona las Materias',
                  getItemName: (item) => item.nombre,
                  selectedItems: selectedSubjects,
                  isMultiSelect: true,
                  onItemSelected: (selected) {},
                );
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedSubjects.isNotEmpty
                        ? '${selectedSubjects.length} Materia(s) seleccionada(s)'
                        : 'Seleccionar Materias',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            Spacer(),

            // Botón para guardar la inscripción
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedStudent != null && selectedSubjects.isNotEmpty) {
                    setState(() {
                      selectedStudent!.materias = List.from(selectedSubjects);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          "¡Materias inscritas exitosamente!",
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          "¡Por favor selecciona un alumno y/o materias!",
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(
                  'Registrar Inscripción',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

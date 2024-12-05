import 'package:flutter/material.dart';

import '../main.dart';
import '../models/student.dart';

class GradesScreen extends StatefulWidget {
  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  Estudiante? selectedStudent;

  void showSearchModal<T>({
    required BuildContext context,
    required List<T> items,
    required String title,
    required String Function(T) getItemName,
    required void Function(T) onItemSelected,
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
          heightFactor: 0.6,
          widthFactor: 0.9,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          return ListTile(
                            title: Text(getItemName(item)),
                            onTap: () {
                              onItemSelected(item);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Captura de Calificaciones',
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
                  onItemSelected: (selected) {
                    setState(() {
                      selectedStudent = selected;
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
            if (selectedStudent != null)
              Expanded(
                child: ListView.builder(
                  itemCount: selectedStudent!.materias.length,
                  itemBuilder: (context, index) {
                    final materia = selectedStudent!.materias[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              materia.nombre,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0-10',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  materia.calificacion = double.tryParse(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (selectedStudent != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Calificaciones de ${selectedStudent!.nombre} guardadas exitosamente.',
                            style: TextStyle(color: Colors.white),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // Botón en color teal
                    onPrimary: Colors.white, // Texto en blanco
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Guardar Calificaciones',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

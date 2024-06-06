import 'package:flutter/material.dart';
import 'package:proyecto_gestion/screens/logout_screen.dart';
import 'package:proyecto_gestion/screens/welcome_screen.dart';
import 'package:proyecto_gestion/screens/login_screen.dart';
import 'package:proyecto_gestion/screens/qr_scan_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/qr_scan_page': (context) => const QrScanPage(),
      },
    );
  }
}

class InventoryScreen extends StatelessWidget {
  final String roomType;
  final bool isEmployee;
  final String roomNumber;

  const InventoryScreen({
    super.key,
    required this.roomType,
    required this.isEmployee,
    required this.roomNumber,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, String>> productQuantities = {
      'Individual': {
        'Cafetera': '1',
        'Manteles': '1',
        'Mantas': '1',
        'Fundas': '3',
        'Almohadas': '3',
        'Sabanas': '2',
        'Toallas': '4',
        'Toalla mano': '3',
        'Tapete bano': '1',
        'Secador': '1',
        'Control Rem': '1',
        'Bata': '1',
      },
      'Doble': {
        'Cafetera': '1',
        'Manteles': '1',
        'Mantas': '1',
        'Fundas': '6',
        'Almohadas': '6',
        'Sabanas': '4',
        'Toallas': '6',
        'Toalla mano': '3',
        'Tapete bano': '1',
        'Secador': '1',
        'Control Rem': '1',
        'Bata': '2',
      },
      'Familiar': {
        'Cafetera': '1',
        'Manteles': '2',
        'Mantas': '1',
        'Fundas': '8',
        'Almohadas': '8',
        'Sabanas': '6',
        'Toallas': '8',
        'Toalla mano': '5',
        'Tapete bano': '1',
        'Secador': '1',
        'Control Rem': '1',
        'Bata': '5',
      },
      'Suite': {
        'Cafetera': '2',
        'Manteles': '2',
        'Mantas': '1',
        'Fundas': '6',
        'Almohadas': '6',
        'Sabanas': '2',
        'Toallas': '5',
        'Toalla mano': '3',
        'Tapete bano': '1',
        'Secador': '1',
        'Control Rem': '1',
        'Bata': '3',
      },
    };

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 103, 74, 239),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 40),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habitación $roomType',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Número $roomNumber',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, size: 40),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QrScanPage(),
                  ),
                );
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Código escaneado: $result')),
                  );
                }
              },
            ),
            if (!isEmployee)
              IconButton(
                icon: const Icon(Icons.more_vert, size: 40),
                onPressed: () {
                  _showAddProductDialog(context);
                },
              ),
            if (isEmployee)
              IconButton(
                icon: const Icon(Icons.warning, size: 40),
                onPressed: () {
                  _showWarningDialog(context);
                },
                color: Colors.red, // Color del botón
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(thickness: 2),
          const SizedBox(height: 30.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: productQuantities[roomType]?.entries.map((entry) {
                    return _buildProductCard(
                      entry.key,
                      'assets/${entry.key}.png',
                      entry.value,
                      context,
                      isEmployee,
                    );
                  }).toList() ??
                  [],
            ),
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 24.0),
          Container(
            color: const Color.fromARGB(255, 103, 74, 239),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isEmployee
                          ? 'Información empleado:'
                          : 'Información jefa:',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      isEmployee ? 'Juan Perez' : 'Ana Lopez',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LogoutScreen(isEmployee: isEmployee),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      isEmployee ? 'assets/empleado.png' : 'assets/jefa.png',
                    ),
                    radius: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String productName, String imagePath,
      String quantity, BuildContext context, bool isEmployee) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            productName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cantidad: ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                quantity,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(width: 8.0),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                child: IconButton(
                  icon: const Icon(Icons.more_horiz, size: 20.0),
                  onPressed: () {
                    if (isEmployee) {
                      _showAddNoteDialog(context, productName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Sólo los empleados pueden agregar notas')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Función para mostrar el cuadro de diálogo para agregar notas
  void _showAddNoteDialog(BuildContext context, String productName) {
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nota al Producto'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(labelText: 'Nota'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String note = noteController.text.trim();
                if (note.isNotEmpty) {
                  // Guardar la nota en Firestore
                  FirebaseFirestore.instance.collection('notas').add({
                    'producto': productName,
                    'nota': note,
                    'fecha': Timestamp.now(),
                  });

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('La nota no puede estar vacía')),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el cuadro de diálogo para reportar incidentes o daños
  void _showWarningDialog(BuildContext context) {
    TextEditingController incidentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reportar Incidentes o Daños'),
          content: TextField(
            controller: incidentController,
            decoration:
                const InputDecoration(labelText: 'Descripción del Incidente'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String incident = incidentController.text.trim();
                if (incident.isNotEmpty) {
                  // Guardar el incidente en Firestore
                  FirebaseFirestore.instance.collection('incidentes').add({
                    'descripcion': incident,
                    'fecha': Timestamp.now(),
                  });

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'La descripción del incidente no puede estar vacía')),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Color del texto del botón
              ),
              child: const Text('Reportar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el cuadro de diálogo para agregar un nuevo producto
  void _showAddProductDialog(BuildContext context) {
    TextEditingController productNameController = TextEditingController();

    TextEditingController quantityController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Producto'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: imageController,
                decoration:
                    const InputDecoration(labelText: 'Ruta de la Imagen'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String productName = productNameController.text.trim();
                String quantity = quantityController.text.trim();

                String imagePath = imageController.text.trim();

                if (productName.isNotEmpty &&
                    quantity.isNotEmpty &&
                    imagePath.isNotEmpty) {
                  // Guardar el producto en Firestore
                  FirebaseFirestore.instance.collection('productos').add({
                    'nombre': productName,
                    'cantidad': quantity,
                    'imagen': imagePath,
                    'fecha': Timestamp.now(),
                  });

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Todos los campos son obligatorios')),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}

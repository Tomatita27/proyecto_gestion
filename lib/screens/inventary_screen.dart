import 'package:flutter/material.dart';
import 'package:proyecto_gestion/data/app_user.dart';
import 'package:proyecto_gestion/data/product.dart';
import 'package:proyecto_gestion/data/room.dart';
import 'package:proyecto_gestion/screens/logout_screen.dart';
import 'package:proyecto_gestion/screens/welcome_screen.dart';
import 'package:proyecto_gestion/screens/login_screen.dart';
import 'package:proyecto_gestion/screens/qr_scan_page.dart';
import 'package:proyecto_gestion/data/firebase_operations.dart';
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

class InventoryScreen extends StatefulWidget {
  final Room room;
  final AppUser user;

  const InventoryScreen({super.key, required this.room, required this.user});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Map<String, TextEditingController> _quantityControllers;

  @override
  void initState() {
    super.initState();
    _quantityControllers = {
      for (var product in widget.room.products ?? [])
        product.id: TextEditingController(text: product.quantity.toString())
    };
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showAddNoteDialog(BuildContext context, String productId, String productName) {
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
              onPressed: () async {
                String note = noteController.text.trim();
                if (note.isNotEmpty) {
                  try {
                    await addNote(widget.room.id, widget.room.number, note, productId, productName, Timestamp.now());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nota agregada correctamente')),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al agregar la nota: $error')),
                    );
                  }

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La nota no puede estar vacía')),
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

  void _showWarningDialog(BuildContext context) {
    TextEditingController incidentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reportar Incidentes o Daños'),
          content: TextField(
            controller: incidentController,
            decoration: const InputDecoration(labelText: 'Descripción del Incidente'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String incident = incidentController.text.trim();
                if (incident.isNotEmpty) {
                  // // Guardar el incidente en Firestore
                  // FirebaseFirestore.instance.collection('incidentes').add({
                  //   'descripcion': incident,
                  //   'fecha': Timestamp.now(),
                  // });

                  try {
                    await addIncident(widget.room.id, widget.room.number, incident, Timestamp.now());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Incidente reportado correctamente')),
                    );
                    Navigator.pop(context);
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al reportar el incidente: $error')),
                    );
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La descripción del incidente no puede estar vacía')),
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
                decoration: const InputDecoration(labelText: 'Nombre del Producto'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Ruta de la Imagen'),
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
              onPressed: () async {
                String productName = productNameController.text.trim();
                String quantity = quantityController.text.trim();
                String imagePath = imageController.text.trim();

                await addProductToRoom(widget.room.id, productName, int.parse(quantity), imagePath).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Producto $productName agregado correctamente')),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al agregar el producto: $error')),
                  );
                });
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(String productId, String productName, String imagePath, String quantity, BuildContext context, bool isEmployee) {
    TextEditingController quantityController = _quantityControllers[productId] ?? TextEditingController(text: quantity);

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
              Container(
                width: 50,
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0',
                    isDense: true,
                    contentPadding: EdgeInsets.all(5),
                  ),
                  readOnly: isEmployee,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                constraints: const BoxConstraints(maxWidth: 30),
                child: IconButton(
                  icon: const Icon(Icons.more_horiz, size: 20.0),
                  onPressed: () {
                    if (isEmployee) {
                      _showAddNoteDialog(context, productId, productName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sólo los empleados pueden agregar notas')),
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

  @override
  Widget build(BuildContext context) {
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
                'Habitación ${widget.room.type}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Número ${widget.room.number}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
            if (widget.user.isBoss)
              IconButton(
                icon: const Icon(Icons.more_vert, size: 40),
                onPressed: () {
                  _showAddProductDialog(context);
                },
              ),
            if (!widget.user.isBoss)
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
              crossAxisCount: 2,
              children: widget.room.products
                      ?.map((product) => _buildProductCard(
                          product.id,
                          product.name,
                          product.imageRoute,
                          product.quantity.toString(),
                          context,
                          !widget.user.isBoss))
                      .toList() ??
                  [],
            ),
          ),
          const Divider(thickness: 2),
          // const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              List<Product> productList = [];
              try {
                for (var product in widget.room.products ?? []) {
                  productList.add(Product(id: product.id, name: product.name, imageRoute: product.imageRoute, quantity: int.parse(_quantityControllers[product.id]?.text ?? '0')));
                }
                updateProductsQuantity(productList, widget.room.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Productos guardados correctamente')),
                );
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al guardar los productos: $error')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 178, 239, 74),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Guardar Cantidades'),
          ),
          // const SizedBox(height: 20),
          const SizedBox(height: 20),
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
                      !widget.user.isBoss ? 'Información empleado:' : 'Información jefa:',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "${widget.user.firstName} ${widget.user.lastName}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoutScreen(user: widget.user),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.user.photoRoute),
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
}

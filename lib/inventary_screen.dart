import 'package:flutter/material.dart';
import 'package:proyecto_gestion/logout_screen.dart';
import 'package:proyecto_gestion/qr_scan_page.dart';
import 'package:image_picker/image_picker.dart';


class InventoryScreen extends StatelessWidget {
  final String roomType;
  final bool isEmployee;

  const InventoryScreen({
    Key? key,
    required this.roomType,
    required this.isEmployee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String roomNumber = "120";
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
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 103, 74, 239),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 40),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Número $roomNumber',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner, size: 40),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScanPage(),
                  ),
                );
                if (result != null) {
                  // Haz algo con el resultado del escaneo QR, por ejemplo, mostrar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Código escaneado: $result')),
                  );
                }
              },
            ),
            if (!isEmployee)
              IconButton(
                icon: Icon(Icons.more_vert, size: 40),
                onPressed: () {
                  _showAddProductDialog(context);
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(thickness: 2),
          SizedBox(height: 30.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: productQuantities[roomType]?.entries.map((entry) {
                return _buildProductCard(
                  entry.key,
                  'assets/${entry.key}.png', // Asegúrate de que estos nombres coincidan con los archivos de imagen exactos
                  entry.value,
                  context,
                );
              }).toList() ?? [],
            ),
          ),
          Divider(thickness: 2),
          SizedBox(height: 24.0),
          Container(
            color: Color.fromARGB(255, 103, 74, 239),
            padding: EdgeInsets.all(16.0),
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
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      isEmployee ? 'Juan Perez' : 'Ana Lopez',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 16),
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
                      isEmployee
                          ? 'assets/empleado.png'
                          : 'assets/jefa.png',
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
      String quantity, BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 1),
          Text(
            productName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cantidad: ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                quantity,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              SizedBox(width: 8.0),
              Container(
                constraints: BoxConstraints(maxWidth: 30),
                child: IconButton(
                  icon: Icon(Icons.more_horiz, size: 20.0),
                  onPressed: () {
                    _showAddProductDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nuevo Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Imagen'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Add logic to add product here
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}

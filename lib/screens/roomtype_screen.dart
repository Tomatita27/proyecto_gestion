import 'package:flutter/material.dart';
import 'package:proyecto_gestion/data/room.dart';
import 'package:proyecto_gestion/screens/inventary_screen.dart';

class RoomType extends StatelessWidget {
  final bool isEmployee;
  final String userType;

  const RoomType({super.key, required this.isEmployee, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 103, 74, 239),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tipo de habitaciones',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, size: 40),
            onPressed: () {
              Navigator.pushNamed(context, '/screens/qr_scan_page');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(thickness: 2),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 10.0,
              children: [
                _buildRoomTypeCard('Individual', 'assets/individual.png', context, 1, 10),
                _buildRoomTypeCard('Doble', 'assets/doble.png', context, 11, 20),
                _buildRoomTypeCard('Familiar', 'assets/familiar.png', context, 21, 26),
                _buildRoomTypeCard('Suite', 'assets/suite.png', context, 27, 30),
              ],
            ),
          ),
          const Divider(thickness: 2),
          Container(
            color: const Color.fromARGB(255, 103, 74, 239),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEmployee ? 'Información empleado:' : 'Información jefa:',
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
                CircleAvatar(
                  backgroundImage: AssetImage(isEmployee ? 'assets/empleado.png' : 'assets/jefa.png'),
                  radius: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTypeCard(String roomType, String imagePath, BuildContext context, int start, int end) {
    return GestureDetector(
      onTap: () {
        _showRoomNumberDialog(context, roomType, start, end);
      },
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Card(
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
                'Habitación $roomType',
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoomNumberDialog(BuildContext context, String roomType, int start, int end) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona el número de habitación'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: end - start + 1,
              itemBuilder: (BuildContext context, int index) {
                int roomNumber = start + index;
                return ListTile(
                  title: Text('Habitación $roomNumber'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // TODO: OBTENER DE LA BASE DE DATOS LA HABITACION
                          Room room = roomMap[roomType]?.elementAt(index) ?? Room(id: "", number: 0, type: "", imageRoute: "");
                          return InventoryScreen(room: room, isEmployee: isEmployee);
                        }
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

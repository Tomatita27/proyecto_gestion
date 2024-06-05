import 'package:flutter/material.dart';
import 'package:proyecto_gestion/inventary_screen.dart';

class RoomType extends StatelessWidget {
  final bool isEmployee;
  final String userType;

  const RoomType({Key? key, required this.isEmployee, required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 103, 74, 239),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tipo de habitaciones',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, size: 40),
            onPressed: () {
              Navigator.pushNamed(context, '/qr_scan_page');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(thickness: 2),
          SizedBox(height: 30),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 10.0,
              children: [
                _buildRoomTypeCard('Individual', 'assets/individual.png', context),
                _buildRoomTypeCard('Doble', 'assets/doble.png', context),
                _buildRoomTypeCard('Familiar', 'assets/familiar.png', context),
                _buildRoomTypeCard('Suite', 'assets/suite.png', context),
              ],
            ),
          ),
          Divider(thickness: 2),
          Container(
            color: Color.fromARGB(255, 103, 74, 239),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEmployee ? 'Información empleado:' : 'Información jefa:',
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
                CircleAvatar(
                  backgroundImage:
                      AssetImage(isEmployee ? 'assets/empleado.png' : 'assets/jefa.png'),
                  radius: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTypeCard(String roomType, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Clicked on $roomType');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InventoryScreen(roomType: roomType, isEmployee: isEmployee),
          ),
        );
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
              SizedBox(height: 1),
              Text(
                'Habitación $roomType',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

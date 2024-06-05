import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutScreen extends StatelessWidget {
  final bool isEmployee; // Nueva propiedad para determinar si es empleado o jefa

  const LogoutScreen({Key? key, required this.isEmployee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 103, 74, 239),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Cambiar a center
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          isEmployee
                              ? 'Información del empleado:'
                              : 'Información de la jefa:',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrar el Row
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Cambiar a center
                        children: [
                          Text(
                            isEmployee ? 'Juan Perez' : 'Ana Lopez',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Horario:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '8:00 a.m a 17:00 p.m',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage(isEmployee
                          ? 'assets/empleado.png'
                          : 'assets/jefa.png'),
                      radius: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HISTORIAL DE MOVIMIENTOS:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Realizo cambio de inventario: Habitación Individual Número 120',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Realizo cambio de inventario: Habitación Doble Número 101',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Realizo cambio de inventario: Habitación Familiar Número 202',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  'Realizo cambio de inventario: Habitación Suite Número 303',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'INFORMACIÓN GUARDADA',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/welcome_screen');
                },
                child: Text('CERRAR SESIÓN', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

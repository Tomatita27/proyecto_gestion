import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_gestion/data/firebase_operations.dart';
import 'package:proyecto_gestion/data/firebase_options.dart';
import 'package:proyecto_gestion/data/room.dart';
import 'package:proyecto_gestion/screens/welcome_screen.dart';
import 'package:proyecto_gestion/screens/login_screen.dart';
import 'package:proyecto_gestion/screens/qr_scan_page.dart'; // Importa la nueva pantalla

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await generateRoomMap();

  // addProductToFirebase('Producto 1', 10, 'https://via.placeholder.com/150');
  // addIncident('Incidente 1', Timestamp.now());
  // addNote('Nota 1', 'producto_id', Timestamp.now());
  var roomList = await getRooms();
  for (var room in roomList) {
    print('ID: ${room.id}');
    print('Habitación: ${room.number} - Tipo: ${room.type}');
    print('Productos:');
    for (var product in room.products!) {
      print('Nombre: ${product.name} - Cantidad: ${product.quantity}');
    }
  }

  runApp(const MyApp());
}

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
        '/qr_scan_page': (context) => const QrScanPage(), // Añade la nueva ruta
      },
    );
  }
}


/*
//importa paquetes para construir interfaces de usuario.
import 'package:flutter/material.dart';
//importa paquetes para trabajar con Firebase.
import 'package:firebase_core/firebase_core.dart';
//importa las opciones de configuracion de firebase
import 'package:flutter_application_1/firebase_options.dart';
//importacion de pantallas
import 'package:flutter_application_1/welcome_screen.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/qr_scan_page.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //inicio de firebase con las opciones por defecto
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //ejecuta la aplicacion
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //constructor de la clase
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Desactiva el banner de debug
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      //Pantalla inicial de la aplicacion
      home: WelcomeScreen(),
      routes: {
        '/welcome_screen': (context) => WelcomeScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/qr_scan_page': (context) => QrScanPage(), // Añade la nueva ruta
      },
    );
  }
}

*/
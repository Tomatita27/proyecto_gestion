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
  
  await initializeRoomMap();

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
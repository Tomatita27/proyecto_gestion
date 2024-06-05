import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_gestion/firebase_options.dart';
import 'package:proyecto_gestion/welcome_screen.dart';
import 'package:proyecto_gestion/login_screen.dart';
import 'package:proyecto_gestion/qr_scan_page.dart'; // Importa la nueva pantalla

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: WelcomeScreen(),
      routes: {
        '/welcome_screen': (context) => WelcomeScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/qr_scan_page': (context) => QrScanPage(), // Añade la nueva ruta
      },
    );
  }
}

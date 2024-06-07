import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_gestion/data/app_user.dart';
import 'package:proyecto_gestion/data/firebase_operations.dart';
import 'roomtype_screen.dart';
import 'qr_scan_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de id y contraseña
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  // Variables para almacenar errores de id y autenticación
  String _idError = '';
  String _authError = '';

  void _validateId() {
    setState(() {
      _idError = _idController.text.isEmpty ? 'ID no existe' : '';
    });
  }

  void _translateAndShowAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Correo no existe.';
        break;
      case 'wrong-password':
        message = 'Contraseña incorrecta.';
        break;
      case 'invalid-email':
        message = 'Correo no es válido.';
        break;
      case 'user-disabled':
        message = 'Usuario está deshabilitado.';
        break;
      default:
        message = 'Error desconocido. Por favor, inténtalo de nuevo.';
    }

    setState(() {
      _authError = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 40,
          onPressed: () {
            // Navega de regreso a la pantalla anterior al presionar el botón de retroceso
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 35,
            fontFamily: 'Roboto',
          ),
        ),
        // Centra el título en la AppBar
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 103, 74, 239),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('ID', style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Ingresa tu ID',
                errorText: _idError.isEmpty ? null : _idError,
              ),
              onChanged: (text) {
                _validateId();
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Contraseña', style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingresa tu contraseña',
              ),
              obscureText: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  bool isValid = true;

                  if (_idController.text.isEmpty) {
                    setState(() {
                      _idError = 'ID no existe';
                    });
                    isValid = false;
                  }

                  if (_passwordController.text.isEmpty) {
                    _showMessage('Por favor ingresa tu contraseña');
                    isValid = false;
                  }

                  if (isValid) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: _idController.text,
                        password: _passwordController.text,
                      );

                      String userId = userCredential.user!.uid;
                      AppUser user = await getUser(userId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomType(user: user),
                        ),
                      );
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        _translateAndShowAuthError(e);
                      } else {
                        _showMessage('Error desconocido: $e');
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Expanded(child: Divider(thickness: 3)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'o',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                Expanded(child: Divider(thickness: 3)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Ingresar tu QR', style: TextStyle(fontSize: 25)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner, size: 30),
                label: const Text('Escanear QR', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  final qrCode = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrScanPage()),
                  );
                  if (qrCode != null) {
                    _idController.text = qrCode;
                    _showMessage('QR escaneado correctamente');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  minimumSize: const Size(double.infinity, 70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

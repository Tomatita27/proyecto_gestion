import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  //variable para almacenar errores de id
  String _idError = '';

  void _validateId() {
    setState(() {
      _idError = _idController.text.isEmpty ? 'ID no existe' : '';
    });
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
                  if (_idController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: _idController.text,
                        password: _passwordController.text,
                      );

                      String userType = '';
                      if (userCredential.user != null) {
                        String userEmail = userCredential.user!.email ?? '';
                        if (userEmail == 'l21170453@hotel.com') {
                          userType = 'Empleado';
                        } else if (userEmail == 'jefe@hotel.com') {
                          userType = 'Jefa';
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoomType(
                                isEmployee: userType == 'Empleado',
                                userType: userType)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error de autenticación: $e')),
                      );
                    }
                  } else {
                    setState(() {
                      if (_idController.text.isEmpty) {
                        _idError = 'ID no existe';
                      }
                    });
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

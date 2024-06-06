import 'package:flutter/material.dart';
import 'package:proyecto_gestion/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            const TextField(
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              decoration: const BoxDecoration(
                color: Color(0xFF674AEF),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(70)),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height /
                  10, // Adjust the position as needed
              left: 0,
              right: 0,
              child: const Center(
                child: Text(
                  "BIENVENIDO A",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 135, // Adjust the position as needed
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width:
                      300.0, // Adjust width and height to control the size of the border
                  height: 300.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 250, 252,
                          253), // Adjust the color of the border as needed
                      width: 4.0, // Adjust the width of the border as needed
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/logo.png",
                      scale: 0.8,
                      width:
                          300, // Adjust width and height to match the container's size
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 460, // Adjust the position as needed
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "HOTEL STOCKMASTER",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                decoration: const BoxDecoration(
                  color: Color(0xFF674AEF),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10), // Moved inside the Column
                    Material(
                      color: const Color(0xFF674AEF),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

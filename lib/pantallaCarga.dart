import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemonapp/main.dart';

void main() {
  runApp(const pantallaCarga());
}

class pantallaCarga extends StatelessWidget {
  const pantallaCarga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokemonAPP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Mostrar SplashScreen como pantalla inicial
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay de 5 segundos antes de navegar a la página principal
    Timer(Duration(seconds: 3), () {
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
    });
  }

  @override
  Widget build(BuildContext context) {
    // En la SplashScreen, mostrar la imagen de carga.png
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/carga.png',
                fit: BoxFit.cover, // Ajustar la imagen para que cubra toda la pantalla
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Margen en la parte inferior
              child: CircularProgressIndicator(), // Barra de progreso de carga
            ),// Barra de progreso de carga
          ],
        ),
      ),
    );
  }
}
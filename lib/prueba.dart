import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemonapp/incubadora.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Contador extends StatefulWidget {
  @override
  _Contador createState() => _Contador();
}

class _Contador extends State<Contador> {
  late Timer _timer;
  late DateTime _fechaApertura;
  late Duration _duration = Duration(hours: 24, minutes: 0, seconds: 0);

@override
void initState() {
  super.initState();
  _inicializarTemporizador();
}

Future<void> _inicializarTemporizador() async {
  try {
    // Supongamos que el ID del usuario es 1. Puedes cambiarlo según necesites.
    int idUsuario = 1;
    _fechaApertura = await obtenerFechaApertura(idUsuario);
    print(_fechaApertura);
    _duration = Duration(hours: 24);

    // Configurar el temporizador para que se actualice cada segundo
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Calcular el tiempo restante restando la fecha actual de la fecha de apertura
        var difference = DateTime.now().difference(_fechaApertura);
        // Si el tiempo restante es menor o igual a cero, detener el temporizador
        if (difference >= _duration) {
          _timer.cancel();
          _duration = Duration(); // Establecer la duración en cero
        } else {
          // Actualizar la duración restante del temporizador
          _duration = Duration(hours: 24) - difference;
        }
      });
    });
  } catch (e) {
    print('Error al inicializar el temporizador: $e');
  }
}

  Future<void> actualizarFechaApertura(int idUsuario) async {
    final url = 'http://20.162.113.208:5000/api/usuario/actualizar_fecha_apertura/$idUsuario';
    final response = await http.put(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Fecha de apertura actualizada correctamente');
      // Actualizar la fecha de apertura en el cliente
      setState(() {
        _fechaApertura = DateTime.now();
      });
      // Reiniciar el temporizador después de actualizar la fecha de apertura
      _inicializarTemporizador();
    } else {
      throw Exception('Error al actualizar la fecha de apertura');
    }
  }

String getTimerString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}


  @override
  void dispose() {
    // Detener el temporizador cuando se elimina el widget
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     bool activate = _duration.inSeconds > 0;
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mi Aplicación'),
        ),
        body: Center(
          child: _buildButtonContador(
            activate == true  ? "READY IN" : "COLLECT",
            activate == true  ? "assets/incubadoraOFF.png" : "assets/incubadora.png",
            Incubadora(),
            activate,
            context,
            topLeftRadius: 20,
            topRightRadius: 20,
            bottomLeftRadius: 20,
            bottomRightRadius: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContador(
    String text,
    String imagePath,
    Widget screen,
    bool activate,
    BuildContext context, {
    double? topLeftRadius,
    double? topRightRadius,
    double? bottomLeftRadius,
    double? bottomRightRadius,
  }) {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 148,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius ?? 25),
              topRight: Radius.circular(topRightRadius ?? 25),
              bottomLeft: Radius.circular(bottomLeftRadius ?? 25),
              bottomRight: Radius.circular(bottomRightRadius ?? 25),
            ),
            border: Border.all(
              color: Colors.black,
              width: 1.5,
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(207, 72, 72, 1),
                Color.fromRGBO(224, 17, 17, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 113,
                left: 10,
                right: 10,
                height: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 4,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 35,
                child: Image.asset(
                  imagePath,
                  width: 67,
                  height: 75,
                ),
              ),
              Positioned(
                bottom: 110,
                child: Text(
                  // Mostrar la duración restante del temporizador
                  '${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeftRadius ?? 25),
                topRight: Radius.circular(topRightRadius ?? 25),
                bottomLeft: Radius.circular(bottomLeftRadius ?? 25),
                bottomRight: Radius.circular(bottomRightRadius ?? 25),
              ),
            onTap: () async {
                if (activate == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Vuelve más tarde para abrir la incubadora.'),
                    ),
                  );
                } else {
                  int idUsuario = 1; // Supongamos que el ID del usuario es 1. Puedes cambiarlo según necesites.
                  try {
                    await actualizarFechaApertura(idUsuario);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen),
                    );
                  } catch (e) {
                    print('Error al actualizar la fecha de apertura: $e');
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTime> obtenerFechaApertura(int idUsuario) async {
  final url = 'http://20.162.113.208:5000/api/usuario/fecha_apertura/$idUsuario';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DateTime.parse(data['fecha_apertura']);
  } else {
    throw Exception('Error al obtener la fecha de apertura');
  }
}






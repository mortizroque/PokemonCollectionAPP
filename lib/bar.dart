import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokemonapp/usuario_provider.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomNavBar(
      {required this.currentIndex, required this.onTap, required int coins});

  @override
  Widget build(BuildContext context) {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;
    int Usuarioxp = usuario?.xp ?? 0;
    double XpLevel = 100.0; // Inicialmente, el valor de XpLevel es 100.0
    double XpPer;
    int level = 1;
    final int coins; // Agrega esta línea
    int _currentIndex = 0;

    while (Usuarioxp >= XpLevel) {
      // Mientras el usuario alcance el nivel actual, actualizamos XpLevel multiplicándolo por 2.25
      XpLevel *= 2.25;
      level += 1;
    }

// Calculamos el progreso del usuario como un porcentaje
    XpPer = Usuarioxp / XpLevel;
    late final Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: 100, // Establece una altura específica para el CustomNavBar
      child: AppBar(
        backgroundColor:
            Colors.transparent, // Establece el color de fondo transparente
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width /
                    3, // Ancho del Stack ajustado
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: screenSize.height * 0.051,
                      left: (screenSize.width - 360) / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ), // Define el borde negro
                          borderRadius: BorderRadius.circular(
                              25.0), // Define el radio del borde
                        ),
                        child: new LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width / 4,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: XpPer,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: const Color.fromRGBO(229, 166, 94, 1),
                          backgroundColor:
                              const Color.fromRGBO(217, 217, 217, 1),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Positioned(
                        top: 0,
                        left:
                            0, // Puedes ajustar esta posición según tus necesidades
                        child: Stack(
                          children: [
                            Image.asset(
                              alignment: Alignment.centerLeft,
                              'assets/xpStar.png',
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.height * 0.13,
                            ),
                            Positioned(
                              top: screenSize.height * 0.053,
                              left: screenSize.height *
                                  ((level.toString().length == 1)
                                      ? 0.0108
                                      : 0.007),
                              child: Text(
                                level.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenSize.height * 0.005,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/barramoneda.png',
                    width: screenSize.width * 0.27,
                    height: screenSize.height * 0.13,
                  ),
                  Positioned(
                    top: screenSize.height * 0.053,
                    left: screenSize.width * 0.109,
                    child: FutureBuilder<Map<String, int>>(
                      future: obtenerMonedas(
                          context), // Llama a la función asíncrona aquí
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Muestra un indicador de carga mientras espera
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Muestra un mensaje de error si algo sale mal
                        } else {
                          // Aquí puedes devolver el Text widget con el valor obtenido
                          return Text(
                            formatMonedasEspeciales(snapshot.data!['monedasNormales']),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenSize.height * 0.005,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/barrapremium.png',
                    width: screenSize.width * 0.27,
                    height: screenSize.height * 0.13,
                  ),
                  Positioned(
                    top: screenSize.height * 0.055,
                    left: screenSize.width * 0.103,
                    child: FutureBuilder<Map<String, int>>(
                      future: obtenerMonedas(
                          context), // Llama a la función asíncrona aquí
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Muestra un indicador de carga mientras espera
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Muestra un mensaje de error si algo sale mal
                        } else {
                          // Aquí puedes devolver el Text widget con el valor obtenido
                          return Text(
                            formatMonedasEspeciales(snapshot.data!['monedasEspeciales']),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, int>> obtenerMonedas(BuildContext context) async {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;
    int idUsuario = usuario?.idUsuario ?? 0;

    try {
      Map<String, dynamic> data = await fetchUserCoins(idUsuario);
      int monedasNormales = data['monedas'] ?? 0;
      int monedasEspeciales = data['cantidad_pokecoins'] ?? 0;

      return {
        'monedasNormales': monedasNormales,
        'monedasEspeciales': monedasEspeciales,
      };
    } catch (error) {
      print(error);
      return {
        'monedasNormales': 0,
        'monedasEspeciales': 0,
      };
    }
  }

String formatMonedasEspeciales(int? monedas) {
  if (monedas == null) {
    return "0"; // O cualquier valor por defecto que prefieras
  } else if (monedas >= 1000000) {
    double mValue = monedas / 1000000;
    return monedas >= 10000000 ? "${mValue.toStringAsFixed(0)}M" : "${mValue.toStringAsFixed(1)}M";
  } else if (monedas >= 1000) {
    double kValue = monedas / 1000;
    return monedas >= 100000 ? "${kValue.toStringAsFixed(0)}k" : "${kValue.toStringAsFixed(1)}k";
  } else {
    return monedas.toString();
  }
}



double calculateLeftPosition(int? monedas, double defaultLeft) {
  if (monedas != null && monedas >= 10000) {
    return defaultLeft + 10; // Ajusta este valor según tus necesidades
  }
  return defaultLeft;
}


  Future<Map<String, dynamic>> fetchUserCoins(int userId) async {
    final response = await http
        .get(Uri.parse('http://20.162.113.208:5000/api/tienda/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user coins');
    }
  }
}

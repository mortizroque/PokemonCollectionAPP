import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokemonapp/bar.dart';
import 'package:pokemonapp/incubadora.dart';
import 'package:pokemonapp/main_ocr.dart';
import 'package:pokemonapp/nav_bar.dart';
import 'package:pokemonapp/pokedex.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:pokemonapp/usuario.dart';
import 'packs.dart';
import 'usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pokemonapp/botonContador.dart';
import 'package:pokemonapp/game/main.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [Color.fromRGBO(255, 22, 22, 1), Colors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paintFill = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill
      ..strokeWidth = 0
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final path = Path()
      ..moveTo(0 * 0.3762500, 0 * 0.4020000)
      ..lineTo(650 * 0.7487500, 0 * 0.3020000)
      ..lineTo(650 * 0.7487500, 550 * 0.7040000)
      ..lineTo(470 * 0.5637500, 550 * 0.9040000)
      ..lineTo(0 * 0.3762500, 550 * 0.7020000);

    canvas.drawPath(path, paintFill);

    final paintStroke = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RPSCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double offsetY = 12.0;
    final path = Path()
      ..moveTo(size.width * 0, size.height * 0.3116667 + offsetY)
      ..lineTo(size.width * 0.5, size.height * 0.51)
      ..lineTo(size.width * 1, size.height * 0.316667 + offsetY)
      ..lineTo(size.width * 1, size.height * 1.25)
      ..lineTo(size.width * 0, size.height * 1.25);

    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(179, 179, 179, 1),
          Color.fromARGB(255, 255, 255, 255),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late String _selectedProfileImage = '';
  late AnimationController _animationController;
  late Animation<double> _animator;
  bool _drawerVisible = false;
  double _extraHeight = 0.0;
  late Size _screen;
  double _maxSlide = 200.0;
  double _startingPos = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animator = _animationController.drive(
      CurveTween(curve: Curves.easeInOut),
    );
    _animationController.addListener(() {
      setState(() {
        _extraHeight = (_screen.height - _screen.width) * _animator.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screen = MediaQuery.of(context).size; // Inicialización de _screen
  }

  @override
  Widget build(BuildContext context) {
    bool activate = true;
    late final Size screenSize = MediaQuery.of(context).size;
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;
    int Usuarioxp = usuario?.xp ?? 0;
    int idusuario = usuario?.idUsuario ?? 0;
    DateTime _fechaApertura = usuario?.fecha_apertura ?? DateTime.now();

    double XpLevel = 100.0; // Inicialmente, el valor de XpLevel es 100.0
    double XpPer;
    int level = 1;
    int userId = 0;
    int _currentIndex = 0;

    while (Usuarioxp >= XpLevel) {
      // Mientras el usuario alcance el nivel actual, actualizamos XpLevel multiplicándolo por 2.25
      XpLevel *= 2.25;
      level += 1;
    }

// Calculamos el progreso del usuario como un porcentaje
    XpPer = Usuarioxp / XpLevel;

    // Calcula el tamaño de la imagen del fondo
    double backgroundWidth = screenSize.width * 1.2;
    double backgroundHeight = screenSize.height * 1.2;

    // Calcula el tamaño y la posición de otros elementos
    double imageWidth = screenSize.width * 0.25;
    double imageHeight = screenSize.width * 0.25;
    double buttonWidth = screenSize.width * 0.35;
    double buttonHeight = screenSize.height * 0.1;
    double iconSize = screenSize.width * 0.1;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            // Tu scaffold actual aquí
            drawer: NavBar(
              // Pasa una función que actualice _selectedProfileImage a NavBar
              onProfileImageSelected: (String imagePath) {
                setState(() {
                  _selectedProfileImage = imagePath;
                });
              },
              xpPer: XpPer,
              level: level,
              idusuario: idusuario,
            ),
            body: Builder(builder: (BuildContext context) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RPSCustomPainter(),
                    ),
                  ),
                  Positioned(
                    left: -backgroundWidth * 0.05,
                    bottom: screenSize.height * 0.06,
                    child: Image.asset(
                      _selectedProfileImage.isNotEmpty
                          ? _selectedProfileImage
                          : 'assets/grow.png',
                      width: backgroundWidth,
                      height: backgroundHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    right: screenSize.width * 0.0,
                    bottom: screenSize.height * 0.15,
                    child: CustomPaint(
                      size: Size(screenSize.width, screenSize.width * 1.5),
                      painter: RPSCustomPainter2(),
                    ),
                  ),
                  Positioned(
                    right: screenSize.width * 0.0,
                    bottom: screenSize.height * 0.44,
                    child: Transform.rotate(
                      angle: 65 * math.pi / 180,
                      child: Container(
                        width: screenSize.width * 0.065,
                        height: screenSize.height * 0.316,
                        color: Color.fromRGBO(29, 30, 29, 1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenSize.width * 0.0,
                    bottom: screenSize.height * 0.44,
                    child: Transform.rotate(
                      angle: -65 * math.pi / 180,
                      child: Container(
                        width: screenSize.width * 0.065,
                        height: screenSize.height * 0.316,
                        color: Color.fromRGBO(29, 30, 29, 1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 20,
                    child: CustomNavBar(
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      coins: 0,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 510),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: screenSize.height * 0.05),
                                    child: _buildButton(
                                        "PACKS",
                                        "assets/pack.png",
                                        Packs(),
                                        activate = true,
                                        context,
                                        topLeftRadius: 0,
                                        bottomRightRadius: 0)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenSize.height * 0.07),
                                  child: BotonContador(idUsuario: idusuario),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: screenSize.height * 0.05),
                                  child: Stack(
                                    children: [
                                      // Botón POKEDEX
                                      Positioned(
                                        // Ajusta la posición horizontal del botón
                                        child: _buildButton(
                                          "POKEDEX",
                                          "assets/pokeball.png",
                                          Pokedex(),
                                          activate = true,
                                          context,
                                          topRightRadius: 0,
                                          bottomLeftRadius: 0,
                                        ),
                                      ),
                                      Positioned(
                                        // Posiciona la imagen dentro del Stack
                                        top:
                                            19, // Ajusta la posición vertical de la imagen según sea necesario
                                        left:
                                            55, // Ajusta la posición horizontal de la imagen según sea necesario
                                        child: Image.asset(
                                          "assets/CollectionCircle.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),

                                      Positioned(
                                        // Posiciona el texto encima de la imagen
                                        top:
                                            26, // Ajusta la posición vertical del texto según sea necesario
                                        left:
                                            66, // Ajusta la posición horizontal del texto según sea necesario
                                        child: FutureBuilder<String>(
                                          future: countUserCards(idusuario),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              // While waiting for the future to complete, you can return a placeholder or a loading indicator
                                              return CircularProgressIndicator(); // Placeholder widget
                                            } else {
                                              // When the future completes, you can use its result
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return Text(
                                                  snapshot
                                                      .data!, // Use the data from the future
                                                  style: TextStyle(
                                                    fontSize:
                                                        14, // Ajusta el tamaño de la fuente según tus necesidades
                                                    fontWeight: FontWeight
                                                        .bold, // Ajusta el peso de la fuente según tus necesidades
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Pokemon-Solid', // Ajusta el color del texto según tus necesidades
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.42,
                    top: MediaQuery.of(context).size.height * 0.9,
                    child: GestureDetector(
                      onTap: () {
                        // Navegar a la otra pestaña al hacer clic en la imagen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      },
                      child: Image.asset(
                        'assets/OCR.png', // Reemplaza 'ruta/de/la/imagen.png' con la ruta de tu imagen
                      ),
                    ),
                  ),

                  // En tu widget donde quieres mostrar la medalla
                  Positioned(
                    left: (MediaQuery.of(context).size.width * 0.4) / 2,
                    top: (MediaQuery.of(context).size.height * 0.28) / 2,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchMedallasByUserId(idusuario),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Si está esperando la respuesta de la API, muestra un indicador de carga
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Si hay un error al obtener la medalla, muestra un mensaje de error
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // Si la respuesta de la API es exitosa, verifica si el usuario tiene la medalla de roca
                          // Itera sobre la lista de mapas para encontrar las medallas
                          final List<Map<String, dynamic>> medallas =
                              snapshot.data!;
                          bool tieneMedallaRoca = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Roca');
                          bool tieneMedallaCascada = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Cascada');
                          bool tieneMedallaTrueno = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Trueno');
                          bool tieneMedallaArcoiris = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Arcoiris');
                          bool tieneMedallaAlma = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Alma');
                          bool tieneMedallaPantano = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Pantano');
                          bool tieneMedallaTierra = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Tierra');
                          bool tieneMedallaVolcan = medallas.any((medalla) =>
                              medalla['medalla'] == 'Medalla Volcan');

                          // Repite este proceso para las demás medalla

                          return Stack(
                            children: [
                              Image.asset(
                                'assets/hexMedallas.png',
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.17,
                                top: MediaQuery.of(context).size.height * 0.21,
                                child: Image.asset(
                                  tieneMedallaRoca
                                      ? 'assets/MedallaRoca.png'
                                      : 'assets/medallaRocaOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.17,
                                top: MediaQuery.of(context).size.height * 0.35,
                                child: Image.asset(
                                  tieneMedallaAlma
                                      ? 'assets/MedallaVolcan.png'
                                      : 'assets/medallaVolcanOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.245,
                                top: MediaQuery.of(context).size.height * 0.25,
                                child: Image.asset(
                                  tieneMedallaVolcan
                                      ? 'assets/MedallaAlma.png'
                                      : 'assets/medallaAlmaout.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.4,
                                top: MediaQuery.of(context).size.height * 0.285,
                                child: Image.asset(
                                  tieneMedallaPantano
                                      ? 'assets/MedallaPantano.png'
                                      : 'assets/medallaPantanoOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.32,
                                top: MediaQuery.of(context).size.height * 0.21,
                                child: Image.asset(
                                  tieneMedallaCascada
                                      ? 'assets/MedallaCascada.png'
                                      : 'assets/medallaCascadaOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.25,
                                top: MediaQuery.of(context).size.height * 0.315,
                                child: Image.asset(
                                  tieneMedallaArcoiris
                                      ? 'assets/MedallaArcoiris.png'
                                      : 'assets/medallaArcoirisout.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.1,
                                top: MediaQuery.of(context).size.height * 0.285,
                                child: Image.asset(
                                  tieneMedallaTrueno
                                      ? 'assets/MedallaTrueno.png'
                                      : 'assets/medallaTruenoOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.32,
                                top: MediaQuery.of(context).size.height * 0.35,
                                child: Image.asset(
                                  tieneMedallaTierra
                                      ? 'assets/MedallaTierra.png'
                                      : 'assets/medallaTierraOut.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                  height:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                  Positioned(
                    left: screenSize.width * 0.23,
                    top: screenSize.height * 0.58,
                    child: _buildRectangularButton(context, MyAppGame()),
                    ),
                ],
              );
            })));
  }

  // Esta función genérica acepta cualquier tipo de pantalla como parámetro y navega a ella.
  void navigateToScreen<T>(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _buildButton(
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
              topLeft: Radius.circular(topLeftRadius ??
                  25), // Usar el valor proporcionado o el predeterminado
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
                  height: 90,
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
              onTap: () {
                if (activate == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Vuelve más tarde para abrir la incubadora.'),
                    ),
                  );
                } else {
                  navigateToScreen(context, screen);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRectangularButton(BuildContext context, Widget screen) {
    return SizedBox(
      width: 215,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla deseada
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => screen), // Llama a la pantalla aquí
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromRGBO(66, 9, 9, 1),
                const Color.fromRGBO(160, 0, 0, 1),
                const Color.fromRGBO(221, 19, 19, 1),
                const Color.fromRGBO(160, 0, 0, 1),
                const Color.fromRGBO(66, 9, 9, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(13.0),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Pokemon-Solid',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchUserCards(int userId) async {
  print("PRUEBA PARA SABER SI HACE LA LLAMADA");
  final response = await http
      .get(Uri.parse('http://20.162.113.208:5000/api/cartas/usuario/$userId'));
  print("TIENE RESPUESTA");

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    List<dynamic> userCards = json.decode(response.body);

    while (!json.encode(userCards).contains(']')) {
      await Future.delayed(Duration(
          seconds: 1)); // Esperar un segundo antes de verificar nuevamente
      final updatedResponse = await http.get(
          Uri.parse('http://20.162.113.208:5000/api/cartas/usuario/$userId'));
      print("TIENE RESPUESTA");

      if (updatedResponse.statusCode == 200) {
        print(json.decode(updatedResponse.body));
        userCards = json.decode(updatedResponse.body);
      } else {
        throw Exception('Failed to load user cards');
      }
    }

    return userCards;
  } else {
    throw Exception('Failed to load user cards');
  }
}

Future<String> countUserCards(int userId) async {
  try {
    final List<dynamic> userCards = await fetchUserCards(userId);
    return userCards.length.toString();
  } catch (e) {
    print('Error counting user cards: $e');
    return '0'; // Si ocurre un error, se devuelve 0
  }
}

Future<List<Map<String, dynamic>>> fetchMedallasByUserId(int userId) async {
  final response = await http.get(
      Uri.parse('http://20.162.113.208:5000/api/medallas/usuario/$userId'));

  if (response.statusCode == 200) {
    // Si la solicitud es exitosa, parsea el JSON y devuelve la lista de medallas como una lista de mapas de cadenas dinámicas
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else if (response.statusCode == 404) {
    // Si hay un error 404, devuelve una lista vacía
    return [];
  } else {
    // Si hay otro tipo de error, lanza una excepción
    throw Exception('Failed to load data');
  }
}


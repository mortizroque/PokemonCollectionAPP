import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pokemonapp/menu.dart';
import 'package:pokemonapp/register.dart';
import 'package:pokemonapp/usuario.dart';
import 'package:pokemonapp/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []); // Oculta la barra de navegación

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UsuarioProvider()), // Provider para UsuarioProvider
        // Puedes agregar más providers aquí si es necesario
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PokemonAPP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepPurple,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isKeyboardVisible = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return GestureDetector(
      onTap: () {
        // Ocultar el teclado cuando se toca en cualquier lugar que no sea un campo de texto
        FocusScope.of(context).requestFocus(FocusNode());
        _setKeyboardVisibility(false);
      },
      child: Scaffold(
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Center(
            child: Stack(
              children: [
                _buildBackground(screenWidth, screenHeight),
                _buildImage('assets/Charizard.png', 400, screenWidth),
                CustomPaint(
                  size: Size.infinite,
                  painter:
                      RectanguloPainter(isKeyboardVisible: _isKeyboardVisible),
                ),
                CustomPaint(
                  size: Size.infinite,
                  painter:
                      TrianglePainter(isKeyboardVisible: _isKeyboardVisible),
                ),
                _buildLoginForm(screenWidth),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _isKeyboardVisible
                      ? const SizedBox.shrink()
                      : Center(
                          key: const Key('center_key'),
                          child: _buildTitulo('assets/title.png', screenWidth),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color.fromRGBO(255, 22, 22, 1), Colors.black],
        ),
      ),
    );
  }

  Widget _buildLoginForm(double screenWidth) {
    return Positioned(
      left: screenWidth * 0.075,
      bottom: screenWidth * 0.05,
      child: Column(
        children: [
          SizedBox(height: screenWidth * 0.08),
          _buildTextField(
              'Email Address / Username', _usernameController, screenWidth),
          SizedBox(height: screenWidth * 0.05),
          _buildTextFieldContrasena('Password', _passwordController,
              obscureText: _isObscure, screenWidth: screenWidth),
          SizedBox(height: screenWidth * 0.1),
          _buildSignInButton(screenWidth),
          SizedBox(height: screenWidth * 0.02),
          _buildSignUpText(),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath, double size, double screenWidth) {
    return Positioned(
      top: -30,
      bottom: size == 200 ? screenWidth * 0.15 : screenWidth * 0.6,
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitulo(String imagePath, double screenWidth) {
    return Positioned(
      left: 0,
      top: -screenWidth * 0.3,
      right: 0,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.15,
      child: TextField(
        controller: controller,
        onTap: () {
          _setKeyboardVisibility(true);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
        ),
      ),
    );
  }

  Widget _buildTextFieldContrasena(
      String labelText, TextEditingController controller,
      {bool obscureText = false, required double screenWidth}) {
    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.15,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onTap: () {
          _setKeyboardVisibility(true);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
                right: 12.0), // Ajusta el espaciado a tu preferencia
            child: obscureText
                ? IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.85,
      height: screenWidth * 0.15,
      child: ElevatedButton(
        onPressed: _signIn,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(66, 9, 9, 1),
                Color.fromRGBO(160, 0, 0, 1),
                Color.fromRGBO(221, 19, 19, 1),
                Color.fromRGBO(160, 0, 0, 1),
                Color.fromRGBO(66, 9, 9, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontFamily: 'RubikOne',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpText() {
    return RichText(
      text: TextSpan(
        text: "I’m a new user. ",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: 'Roboto',
        ),
        children: [
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navegar a la nueva ventana
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    // Si el teclado está visible, ocultarlo y no mostrar el cuadro de diálogo
    if (_isKeyboardVisible) {
      _setKeyboardVisibility(false);
      return false;
    }
    // Si el teclado no está visible, mostrar el cuadro de diálogo de confirmación
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Desea salir de la aplicación?'),
        content: const Text('Presione "Salir" para salir de la aplicación'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    return value ?? false;
  }

  void _setKeyboardVisibility(bool isVisible) {
    setState(() {
      _isKeyboardVisible = isVisible;
    });
  }

  void _signIn() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Crear el cuerpo de la solicitud en formato JSON
    Map<String, String> requestBody = {
      'nombre_usuario': username,
      'contrasena': password,
    };

    // Realizar la solicitud HTTP al servidor
    Uri url = Uri.parse('http://20.162.113.208:5000/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    // Procesar la respuesta del servidor
    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, extraer los datos del usuario del JSON
      Map<String, dynamic> userData = jsonDecode(response.body)['usuario'];
      DateFormat format = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
      DateTime fechaApertura = format.parse(userData['fecha_apertura']);
      // Crear una instancia de Usuario con los datos recibidos del JSON
      Usuario usuario = Usuario(
        idUsuario: userData['id_usuario'],
        nombreUsuario: userData['nombre_usuario'],
        mail: userData['mail'],
        admin: userData['admin'],
        sobres: userData['sobres'],
        xp: userData['xp'],
        fecha_apertura: fechaApertura,
      );

      // Obtener el UsuarioProvider del contexto
      UsuarioProvider usuarioProvider =
          Provider.of<UsuarioProvider>(context, listen: false);

      // Establecer el usuario autenticado en el UsuarioProvider
      usuarioProvider.setUsuario(usuario);

      // Navegar a la pantalla del menú después del inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );

      // Mostrar un mensaje de éxito
      _showSnackBar('Inicio de sesión exitoso');
    } else {
      // Si la solicitud falló, mostrar un mensaje de error
      String errorMessage = jsonDecode(response.body)['mensaje'];
      _showSnackBar('Error al iniciar sesión: $errorMessage');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isKeyboardVisible;

  TrianglePainter({required this.isKeyboardVisible});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    if (isKeyboardVisible) {
      path_0.moveTo(size.width * 0, size.height * 0.42);
    } else {
      path_0.moveTo(size.width * 0, size.height * 0.59500);
    }
    path_0.lineTo(size.width * 1, size.height * 0.3);
    path_0.lineTo(size.width * 1, size.height * 3);
    path_0.lineTo(size.width * 0, size.height * 3);

    canvas.drawPath(path_0, paint_fill_0);

    Paint paint_stroke_0 = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(179, 179, 179, 1), // Rojo
          Color.fromARGB(255, 255, 255, 255), // Verde
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(path_0, paint_stroke_0); // Dibujar con el degradado
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RectanguloPainter extends CustomPainter {
  final bool isKeyboardVisible;

  RectanguloPainter({required this.isKeyboardVisible});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromRGBO(29, 30, 29, 1)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    if (isKeyboardVisible) {
      path_0.moveTo(size.width * 0, size.height * 0.39500);
    } else {
      path_0.moveTo(size.width * 0, size.height * 0.57000);
    }
    path_0.lineTo(size.width * 1, size.height * 0.275);
    path_0.lineTo(size.width * 1, size.height * 0.305);
    path_0.lineTo(size.width * 0, size.height * 0.6);

    canvas.drawPath(path_0, paint_fill_0);

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromRGBO(29, 30, 29, 1)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0); // Dibujar con el degradado
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:pokemonapp/menu.dart';
import 'package:pokemonapp/packs.dart';
import 'package:pokemonapp/usuario_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []); // Oculta la barra de navegación
}

class open_packPremium extends StatefulWidget {
  const open_packPremium({Key? key}) : super(key: key);

  @override
  State<open_packPremium> createState() => _StateOpen_packPremium();
}

class _StateOpen_packPremium extends State<open_packPremium> {
  double opacity = 1.0;
  bool _isVisible = true;
  bool _isVisible2 = true;
  bool _isVisible3 = true;
  bool _isVisible4 = true;
    bool _isVisible5= true;
      bool _isVisible6= true;
  bool showImages = false;
  int totalImages = 5; // Cambia esto al número total de imágenes que tienes
  List<String> cardImages = []; // Lista para almacenar las URLs de las imágenes de cartas
  bool showOverlayImage = false;
  String overlayImagePath = "assets/SobreAperturaEspecial.png"; // Ruta de la imagen para desaparecer
  int clickedImagesCount = 0;
  List<int> numerosGenerados = [];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    return WillPopScope(
      onWillPop: () async {
        // Devuelve false para evitar que la acción de retroceso tenga efecto
        return false;
      },
      child: GestureDetector(
      onTap: () {
        if (clickedImagesCount == totalImages) {
          // Navegar a otra pantalla cuando se hayan hecho clic en todas las imágenes
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Packs()),
          );
        } else {
          if (showOverlayImage) {
            // Ocultar la imagen cuando hagas clic
            setState(() {
              showOverlayImage = false;
            });
          } else {
            _handleIncubadoraTap(); // Llama a la función para manejar el tap si no se muestra la imagen de la portada
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            if (!showImages)
              _buildIncubadora('assets/SobreEspecial.png', 275, screenWidth),
            if (showImages)
              _buildIncubadora2('assets/SobreEspecial.png', 275, screenWidth, 0.5),
            if (showImages) _buildCardImages(screenWidth),
            if (showImages)
              _buildOverlayImage('assets/SobreAperturaEspecial.png', 200, screenWidth, screenWidth * 0.2, screenWidth * 0.510, 0),
            if (showImages)
              _buildOverlayImage2('assets/SobreAperturaEspecial.png', 200, screenWidth, screenWidth * 1.4, screenWidth * 0.510, 1),
            if (showImages)
              _buildOverlayImage3('assets/SobreAperturaEspecial.png', 200, screenWidth, screenWidth * 0.2, screenWidth * 0.533, 2),
            if (showImages)
              _buildOverlayImage4('assets/SobreAperturaEspecial.png', 200, screenWidth, screenWidth * 0.8, screenWidth * 0.27, 3),
            if (showImages)
              _buildOverlayImage5('assets/SobreAperturaEspecial.png', 200, screenWidth, screenWidth * 1.4, screenWidth * 0.533, 4),
            
          ],
        ),
      ),
    ));
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/fondoPack.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIncubadora(String imagePath, double size, double screenWidth) {
    return Positioned(
      top: screenWidth * 0.7,
      left: (screenWidth * 1 - size) / 2,
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildIncubadora2(String imagePath, double size, double screenWidth, double opacity) {
    return Positioned(
      top: screenWidth * 0.7,
      left: (screenWidth * 1 - size) / 2,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCardImages(double screenWidth) {
    return Stack(
      children: [
        for (int i = 0; i < totalImages; i++)
          Positioned(
            
            height:182,
            top: _getImageTopPosition(i, screenWidth),
            left: _getImageLeftPosition(i, screenWidth),
            child: _buildCardImage(i),
          ),
      ],
    );
  }

  Widget _buildOverlayImage(String imagePath, double size, double screenWidth, double top, double left, int index) {
    return Positioned(
      top: top, // Ajusta la posición vertical de la imagen
      left: left, // Centra la imagen horizontalmente
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible = false;
            clickedImagesCount++; // Cambia la visibilidad a false al hacer clic
          });
        },
        child: AnimatedSwitcher( // Usa AnimatedSwitcher en lugar de AnimatedOpacity
          duration: Duration(milliseconds: 500), // Duración de la animación
          child: _isVisible
              ? Image.asset(
                  imagePath,
                  key: ValueKey<int>(index), // Key para diferenciar entre las imágenes
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                )
              : SizedBox.shrink(), // Utiliza SizedBox.shrink() para hacer que la imagen desaparezca completamente
        ),
      ),
    );
  }

  Widget _buildOverlayImage2(String imagePath, double size, double screenWidth, double top, double left, int index) {
    return Positioned(
      top: top, // Ajusta la posición vertical de la imagen
      left: left, // Centra la imagen horizontalmente
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible2 = false;
            clickedImagesCount++; // Cambia la visibilidad a false al hacer clic
          });
        },
        child: AnimatedSwitcher( // Usa AnimatedSwitcher en lugar de AnimatedOpacity
          duration: Duration(milliseconds: 500), // Duración de la animación
          child: _isVisible2
              ? Image.asset(
                  imagePath,
                  key: ValueKey<int>(index), // Key para diferenciar entre las imágenes
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                )
              : SizedBox.shrink(), // Utiliza SizedBox.shrink() para hacer que la imagen desaparezca completamente
        ),
      ),
    );
  }

  Widget _buildOverlayImage3(String imagePath, double size, double screenWidth, double top, double left, int index) {
    return Positioned(
      top: top, // Ajusta la posición vertical de la imagen
      right: left, // Centra la imagen horizontalmente
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible3 = false;
            clickedImagesCount++; // Cambia la visibilidad a false al hacer clic
          });
        },
        child: AnimatedSwitcher( // Usa AnimatedSwitcher en lugar de AnimatedOpacity
          duration: Duration(milliseconds: 500), // Duración de la animación
          child: _isVisible3
              ? Image.asset(
                  imagePath,
                  key: ValueKey<int>(index), // Key para diferenciar entre las imágenes
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                )
              : SizedBox.shrink(), // Utiliza SizedBox.shrink() para hacer que la imagen desaparezca completamente
        ),
      ),
    );
  }

  Widget _buildOverlayImage4(String imagePath, double size, double screenWidth, double top, double left, int index) {
    return Positioned(
      top: top, // Ajusta la posición vertical de la imagen
      right: left, // Centra la imagen horizontalmente
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible4 = false;
            clickedImagesCount++; // Cambia la visibilidad a false al hacer clic
          });
        },
        child: AnimatedSwitcher( // Usa AnimatedSwitcher en lugar de AnimatedOpacity
          duration: Duration(milliseconds: 500), // Duración de la animación
          child: _isVisible4
              ? Image.asset(
                  imagePath,
                  key: ValueKey<int>(index), // Key para diferenciar entre las imágenes
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                )
              : SizedBox.shrink(), // Utiliza SizedBox.shrink() para hacer que la imagen desaparezca completamente
        ),
      ),
    );
  }

  Widget _buildOverlayImage5(String imagePath, double size, double screenWidth, double top, double left, int index) {
    return Positioned(
      top: top, // Ajusta la posición vertical de la imagen
      right: left, // Centra la imagen horizontalmente
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isVisible5 = false;
            clickedImagesCount++; // Cambia la visibilidad a false al hacer clic
          });
        },
        child: AnimatedSwitcher( // Usa AnimatedSwitcher en lugar de AnimatedOpacity
          duration: Duration(milliseconds: 500), // Duración de la animación
          child: _isVisible5
              ? Image.asset(
                  imagePath,
                  key: ValueKey<int>(index), // Key para diferenciar entre las imágenes
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                )
              : SizedBox.shrink(), // Utiliza SizedBox.shrink() para hacer que la imagen desaparezca completamente
        ),
      ),
    );
  }

  

  double _getImageTopPosition(int index, double screenWidth) {
    // Define la posición vertical de cada imagen basada en su índice
    switch (index) {
      case 0:
        return screenWidth * 0.21; // Ajusta estas posiciones según tu preferencia
      case 1:
        return screenWidth * 1.41;
      case 2:
        return screenWidth * 0.21;      
      case 3:
        return screenWidth * 0.81;
      case 4:
        return screenWidth * 1.41;
      default:
        return 0;
    }
  }

  double _getImageLeftPosition(int index, double screenWidth) {
    // Define la posición horizontal de cada imagen basada en su índice
    switch (index) {
      case 0:
        return screenWidth * 0.065; // Ajusta estas posiciones según tu preferencia
      case 1:
        return screenWidth * 0.595;
      case 2:
        return screenWidth * 0.595;      
      case 3:
        return screenWidth * 0.33;
      case 4:
        return screenWidth * 0.065;
      default:
        return 0;
    }
  }

  void _handleIncubadoraTap() async {
    if (!showImages) {
      // Cargar las imágenes de las cartas
      try {
        for (int i = 0; i < totalImages; i++) {
          final imageUrl = await fetchRandomCardImage();
          final completeUrl = 'http://20.162.113.208$imageUrl'; // Agregar la dirección base a la URL de la imagen
          cardImages.add(completeUrl);
        }
        setState(() {
          print(numerosGenerados);
          showImages = true; // Mostrar las imágenes cargadas
        });

        // Mostrar el diálogo de confirmación para guardar el Pokémon
        _showSaveConfirmation(context);
      } catch (e) {
        print("Error al cargar las imágenes de las cartas: $e");
      }
    } else {
      // Mostrar la imagen de la portada si ya se cargaron las imágenes
      setState(() {
        showOverlayImage = true;
      });
    }
  }

  Future<String> fetchRandomCardImage() async {
    final random = Random();
    final pokemonId = random.nextInt(144) + 1;
     numerosGenerados.add(pokemonId);
    final response = await http.get(Uri.parse('http://20.162.113.208:5000/api/cartas/$pokemonId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final fotoCarta = jsonData['foto_carta'];

      if (fotoCarta != null) {
        return fotoCarta;
      } else {
        throw Exception('La imagen de la carta no está disponible');
      }
    } else {
      throw Exception('Fallo al cargar la imagen de la carta: ${response.statusCode}');
    }
  }

  Widget _buildCardImage(int index) {
    if (index < cardImages.length) {
      return GestureDetector(
        onTap: () {
           // Sumamos 1 al índice para obtener el ID del Pokémon
          setState(() {
            // Incrementar el contador de imágenes clicadas
          });
          _showCenteredImage(context, cardImages[index]);
        },
        child: Image.network(cardImages[index], height: 195),
      );
    } else {
      return SizedBox(height: 400); // Placeholder si no hay suficientes imágenes
    }
  }

  void _showCenteredImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: 400,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  

  void _showSaveConfirmation(BuildContext context) async {
    try {
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final usuario = usuarioProvider.usuario;

      // Guardar los Pokémon en la base de datos
      for (int i = 0; i < totalImages; i++) {
        try {
          final apiUrl = 'http://20.162.113.208:5000/api/pokedex';
          final requestBody = jsonEncode({
            'id_usuario': usuario!.idUsuario,
            'id_pokemon': numerosGenerados[i], // Utiliza los valores de la lista numerosGenerados como ID del Pokémon
          });

          final response = await http.post(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: requestBody,
          );

          if (response.statusCode == 201) {
            print('Pokémon guardado');
          } else {
            print('Error al guardar el Pokémon$e');
          }
        } catch (e) {
          print('Error al guardar el Pokémon: $e');
        }
      }
    } catch (e) {
      print('Error al guardar los Pokémon automáticamente: $e');
      // Si ocurre un error, podrías mostrar un mensaje o manejarlo de otra manera aquí
    }
  }
}



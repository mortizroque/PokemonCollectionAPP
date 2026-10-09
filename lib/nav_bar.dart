import 'package:flutter/material.dart';
import 'package:pokemonapp/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokemonapp/menu.dart';
import 'package:pokemonapp/usuario.dart';
import 'usuario_provider.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final Function(String) onProfileImageSelected;
  final double xpPer; // Agregamos xpPer como un parámetro al constructor
  final int level;
  final int idusuario;

  NavBar(
      {required this.onProfileImageSelected,
      required this.xpPer,
      required this.level,
      required this.idusuario});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String _selectedImage = '';

  // Método para mostrar el pop-up con las imágenes de perfil y permitir la selección
  void _showProfilePhotosPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text("Choose Profile Photo"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Botón para seleccionar la primera imagen
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/grow.png'
                        ? Color.fromRGBO(179, 179, 179,
                            1) // Cambia el color del botón seleccionado a negro
                        : null,
                    elevation: _selectedImage == 'assets/grow.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la primera imagen
                    setState(() {
                      _selectedImage = 'assets/grow.png';
                    });
                    widget.onProfileImageSelected(
                        'assets/grow.png'); // Aquí pasas la ruta de la imagen seleccionada
                    Navigator.pop(context, 'assets/grow.png');
                  },
                  child: Image.asset('assets/grow.png'),
                ),
                SizedBox(height: 20), // Espacio vertical entre las imágenes
                // Botón para seleccionar la segunda imagen
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/meowth.png'
                        ? Color.fromRGBO(179, 179, 179, 1)
                        : null,
                    elevation: _selectedImage == 'assets/meowth.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la segunda imagen
                    setState(() {
                      _selectedImage = 'assets/meowth.png';
                    });
                    widget.onProfileImageSelected(
                        'assets/meowth.png'); // Aquí pasas la ruta de la imagen seleccionada
                    Navigator.pop(context, 'assets/meowth.png');
                  },
                  child: Image.asset('assets/meowth.png'),
                ),
                SizedBox(height: 20), // Espacio vertical entre las imágenes
                // Botón para seleccionar la tercera imagen
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/Slowbro.png'
                        ? Color.fromRGBO(179, 179, 179, 1)
                        : null,
                    elevation: _selectedImage == 'assets/Slowbro.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la tercera imagen
                    setState(() {
                      _selectedImage = 'assets/Slowbro.png';
                    });
                    widget.onProfileImageSelected('assets/Slowbro.png');
                    Navigator.pop(context, 'assets/Slowbro.png');
                  },
                  child: Image.asset('assets/Slowbro.png'),
                ),
                SizedBox(height: 20), // Espacio vertical entre las imágenes
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/nidoking.png'
                        ? Color.fromRGBO(179, 179, 179, 1)
                        : null,
                    elevation: _selectedImage == 'assets/nidoking.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la tercera imagen
                    setState(() {
                      _selectedImage = 'assets/nidoking.png';
                    });
                    widget.onProfileImageSelected('assets/nidoking.png');
                    Navigator.pop(context, 'assets/nidoking.png');
                  },
                  child: Image.asset('assets/nidoking.png'),
                ),
                SizedBox(height: 20), // Espacio vertical entre las imágenes
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/Blastoise.png'
                        ? Color.fromRGBO(179, 179, 179, 1)
                        : null,
                    elevation: _selectedImage == 'assets/Blastoise.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la tercera imagen
                    setState(() {
                      _selectedImage = 'assets/Blastoise.png';
                    });
                    widget.onProfileImageSelected('assets/Blastoise.png');
                    Navigator.pop(context, 'assets/Blastoise.png');
                  },
                  child: Image.asset('assets/Blastoise.png'),
                ),
                SizedBox(height: 20), // Espacio vertical entre las imágenes
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == 'assets/Marowak.png'
                        ? Color.fromRGBO(179, 179, 179, 1)
                        : null,
                    elevation: _selectedImage == 'assets/Marowak.png'
                        ? 8.0
                        : 0.0, // Añade elevación al botón seleccionado
                  ),
                  onPressed: () {
                    // Aquí puedes manejar la lógica cuando el usuario selecciona la tercera imagen
                    setState(() {
                      _selectedImage = 'assets/Marowak.png';
                    });
                    widget.onProfileImageSelected('assets/Marowak.png');
                    Navigator.pop(context, 'assets/Marowak.png');
                  },
                  child: Image.asset('assets/Marowak.png'),
                ),
                // Puedes agregar más botones para las otras imágenes según sea necesario
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double xpPer = widget.xpPer;
    int idusuario = widget.idusuario;
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height:
                250, // Ajusta la altura del DrawerHeader según sea necesario
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(224, 17, 17, 1),
                  Color.fromRGBO(224, 17, 17, 1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height:
                        20), // Ajusta el espacio entre el borde superior y el texto
                Text(
                  'POKEMON PROFILE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: "sarpanch",
                  ),
                  textAlign:
                      TextAlign.center, // Centra el texto horizontalmente
                ),
                Image.asset(
                  'assets/foto_entrenadores.png', // Ruta de la imagen de logout
                  width:
                      100, // Ajusta el tamaño de la imagen según sea necesario
                  height: 150,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Level :  ${widget.level}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 19,
                      fontFamily: "sarpanch",
                    ),
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    width: MediaQuery.of(context).size.width / 4,
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width / 1.6,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2500,
                      percent: xpPer,
                      center: Text(
                        '${(xpPer * 100).toStringAsFixed(0)}%', // Muestra el porcentaje en el centro de la barra
                        style: TextStyle(
                          color: Colors
                              .black, // Puedes ajustar el color del texto según sea necesario
                          fontSize:
                              16, // Puedes ajustar el tamaño de fuente según sea necesario
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: const Color.fromRGBO(229, 166, 94, 1),
                      backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'PokePhoto',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 19,
                      fontFamily: "sarpanch",
                    ),
                  ),
                  onTap: () {
                    // Llama al método para mostrar el pop-up de las imágenes de perfil
                    _showProfilePhotosPopup(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        'Collection ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 19,
                          fontFamily: "sarpanch",
                        ),
                      ),
                      FutureBuilder<String>(
                        future: countUserCards(
                            idusuario), // Llama a la función para obtener el número de cartas de usuario
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Si se obtiene el número de cartas de usuario, calcula el porcentaje
                            double collectionPercentage =
                                int.parse(snapshot.data!) / 151;
                            return Text(
                              ' (${(collectionPercentage * 100).toStringAsFixed(2)}%)', // Muestra el porcentaje de la colección en relación con 151 Pokémon
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 19,
                                fontFamily: "sarpanch",
                              ),
                            );
                          } else {
                            // Mientras se carga el número de cartas de usuario, muestra un indicador de carga
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Medals',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 19,
                      fontFamily: "sarpanch",
                    ),
                  ),
                ),
                // Agrega dos columnas paralelas con texto e imagen para cada medalla
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          10), // Margen vertical para ajustar el espacio
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        255, 220, 220, 0.5), // Color de fondo rojo claro
                    borderRadius:
                        BorderRadius.circular(15), // Bordes circulares
                  ),
                  padding:
                      EdgeInsets.all(10), // Espaciado interno para el contenido
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Rainbow Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaArcoiris.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Rainbow Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Cascade Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaCascada.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Cascade Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Thunder Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaTrueno.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Thunder Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Volcano Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaVolcan.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Volcano Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Boulder Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaRoca.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Boulder Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Earth Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaTierra.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Earth Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Soul Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaAlma.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Soul Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  9), // Ajusta el espacio entre las medallas
                          // Marsh Badge
                          Column(
                            children: [
                              Image.asset(
                                'assets/MedallaPantano.png', // Ruta de la imagen de la medalla
                                width:
                                    30, // Ajusta el tamaño de la imagen según sea necesario
                                height: 30,
                              ),
                              SizedBox(
                                  height:
                                      9), // Ajusta el espacio entre la imagen y el texto
                              Text(
                                '- Marsh Badge',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "sarpanch",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

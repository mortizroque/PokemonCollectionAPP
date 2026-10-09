//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemonapp/game/battle/components/battle_player_side.dart';
import 'package:pokemonapp/game/main.dart';
import 'package:pokemonapp/menu.dart';
import 'package:pokemonapp/usuario_provider.dart';

class YourClass {
  static int idLiderGimnasio = 0;
}

class BattleEnemySide extends StatelessWidget {
  final UsuarioProvider
      usuarioProvider; // Agrega un campo para el UsuarioProvider

  BattleEnemySide(
      {required this.usuarioProvider}); // Constructor que recibe el UsuarioProvider

  static int _pokemonEnemyDefense = 0;
  static int _currentEnemyPs = 0;
  static int _maxEnemyPs = 0;
  bool _pokemonEnemyDeath = false;
  static List<dynamic> _pokemonList = [];
  int _currentPokemonIndex = 0;
  BattlePlayerSide _battlePlayerSide = BattlePlayerSide();
  static bool _showVictoryDialog =
      false; // Variable para controlar la visibilidad del mensaje de victoria

  int get pokemonEnemyDefense => _pokemonEnemyDefense;
  set pokemonEnemyDefense(int value) {
    _pokemonEnemyDefense = value;
  }

  int get currentEnemyPs => _currentEnemyPs;
  set currentEnemyPs(int value) {
    _currentEnemyPs = value;
    _pokemonEnemyDeath = _currentEnemyPs <= 0;
    if (_currentEnemyPs <= 0) {
      _currentPokemonIndex++;
      if (_currentPokemonIndex < _pokemonList.length) {
        _currentEnemyPs = _pokemonList[_currentPokemonIndex]['ps'] as int;
        _maxEnemyPs = _pokemonList[_currentPokemonIndex]['ps'] as int;
        _pokemonEnemyDefense =
            _pokemonList[_currentPokemonIndex]['defensa'] as int;
      } else {
        // Aquí puedes manejar lo que sucede cuando no quedan más Pokémon en la lista
        print('No quedan más Pokémon en la lista');
      }
    }
  }

  int get maxEnemyPs => _maxEnemyPs;
  set maxEnemyPs(int value) {
    _maxEnemyPs = value;
  }

  bool get pokemonEnemyDeath => _pokemonEnemyDeath;

  Future<void> applyAttackDamage(int attackDamage, BuildContext context) async {
    print('Vida antes pelea del Pokémon enemigo: $currentEnemyPs');
    print('Defensa antes pelea del Pokémon enemigo: $pokemonEnemyDefense');
    print('Daño antes pelea del Pokémon enemigo: $attackDamage');
    int calculatedDamage = attackDamage - _pokemonEnemyDefense;
    print('Daño real del Pokémon enemigo: $calculatedDamage');
    if (calculatedDamage < 0) {
      calculatedDamage = 0;
    }
    _currentEnemyPs -= calculatedDamage;
    _pokemonEnemyDeath = _currentEnemyPs <= 0;
    print('Vida final del Pokémon enemigo: $_currentEnemyPs');
    print('El Pokémon enemigo está vivo: ${!_pokemonEnemyDeath}');
    print('Lista: $_pokemonList');
    if (_pokemonEnemyDeath) {
      //_currentPokemonIndex++;
      if (_pokemonEnemyDeath) {
        // No quedan más Pokémon en la lista
        print('No quedan más Pokémon en la lista');
        print('Lista: $_pokemonList');

        // Obtener datos del líder para obtener el nombre de la medalla
        final dataLider = await obtenerDatosLider(YourClass.idLiderGimnasio);
        final String medalla = dataLider['medalla'];
        final String nombreLider = dataLider['nombre_lider'];

        // Realizar la llamada a la API para agregar la medalla
        final idUsuario = usuarioProvider
            .usuario?.idUsuario; // Obtén el idUsuario del UsuarioProvider

        if (idUsuario != null) {
          final response = await http.post(
            Uri.parse('http://20.162.113.208:5000/api/medallas'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id_usuario': idUsuario,
              'medalla': medalla,
            }),
          );

          if (response.statusCode == 201) {
            // Medalla agregada correctamente
            print('Medalla agregada correctamente');
            _showVictoryDialog = true; // Mostrar el mensaje de victoria
            print('Medalla $_showVictoryDialog');
            if (_showVictoryDialog) {
              // Si _showVictoryDialog es true, mostrar el diálogo de victoria
              final data = _pokemonList.isNotEmpty ? _pokemonList.first : null;
              if (data != null) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  showVictoryDialog(context, nombreLider, medalla);
                  _showVictoryDialog =
                      false; // Restablecer la variable para futuros usos
                });
              }
            }
            // Navegar al menú
            // Llamada adicional para incrementar sobres, XP y monedas
            final incrementResponse = await http.post(
              Uri.parse('http://20.162.113.208:5000/api/medallas/incrementar'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'id_usuario': idUsuario,
              }),
            );

            if (incrementResponse.statusCode == 200) {
              print('Incrementos realizados correctamente');
            } else {
              print('Error al realizar los incrementos');
            }
          }
          if (response.statusCode == 409) {
            // Medalla agregada correctamente
            print('Medalla ya obtenida');
            _showVictoryDialog = true; // Mostrar el mensaje de victoria
            print('Medalla $_showVictoryDialog');
            // Navegar al menú
            if (_showVictoryDialog) {
              // Si _showVictoryDialog es true, mostrar el diálogo de victoria
              final data = _pokemonList.isNotEmpty ? _pokemonList.first : null;
              if (data != null) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  showVictoryDialog(context, nombreLider, medalla);
                  _showVictoryDialog =
                      false; // Restablecer la variable para futuros usos
                });
              }
            }
            // Llamada adicional para incrementar sobres, XP y monedas
            final incrementResponse = await http.post(
              Uri.parse('http://20.162.113.208:5000/api/medallas/incrementar'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'id_usuario': idUsuario,
              }),
            );

            if (incrementResponse.statusCode == 200) {
              print('Incrementos realizados correctamente');
            } else {
              print('Error al realizar los incrementos');
            }
          } else {
            // Error al agregar la medalla
            print('Error al agregar la medalla: ${response.statusCode}');
            print('medalla: $medalla');
            print('user: $idUsuario');
            _showVictoryDialog = true; // Mostrar el mensaje de victoria
          }
        } else {
          // Manejar el caso en que idUsuario es null
          print('Error: idUsuario es null');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showVictoryDialog) {
      // Si _showVictoryDialog es true, mostrar el diálogo de victoria
      final data = _pokemonList.isNotEmpty ? _pokemonList.first : null;
      if (data != null) {
        final String medalla = data['medalla'];
        final String nombreLider = data['nombre_lider'];
        WidgetsBinding.instance?.addPostFrameCallback((_) {


          showVictoryDialog(context, nombreLider, medalla);
          _showVictoryDialog =
              false; // Restablecer la variable para futuros usos
        });
      }
    }
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerDatosLider(YourClass.idLiderGimnasio),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          final List<dynamic> pokemonDataList = data['pokemons'];
          final String medalla = data['medalla'];
          final String nombreLider = data['nombre_lider'];
          final String medallaFoto = medalla.replaceAll(RegExp(r'\s+'), '');

          _pokemonList = pokemonDataList;
          final primerPokemon = _pokemonList[_currentPokemonIndex];
          pokemonEnemyDefense = primerPokemon['defensa'] as int;
          currentEnemyPs = primerPokemon['ps'] as int;
          maxEnemyPs = primerPokemon['ps'] as int;
          print('Vida del Pokémon enemigo: $primerPokemon');
          print('Vida del Pokémon enemigo: $_currentEnemyPs');
          print('Defensa del Pokémon enemigo: $_pokemonEnemyDefense');
          print('El Pokémon enemigo está vivo: ${!_pokemonEnemyDeath}');
          print('Lista pokemons: $_pokemonList');

          return Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              margin: EdgeInsets.only(left: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 279,
                        margin: EdgeInsets.only(left: kToolbarHeight),
                        child: Image.asset(
                          'assets/Game/enemy_ui.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.topRight,
                        ),
                      ),
                      Container(
                        width: 264,
                        margin: EdgeInsets.only(left: 60),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 15),
                              child: Text(
                                '${primerPokemon['nombre_pokemon']}',
                                style: TextStyle(
                                  fontFamily: 'PokemonFireRed',
                                  fontSize: 20,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 1.0,
                                      color: Color(0xffd8d0b0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 20,
                              margin: EdgeInsets.only(top: 12),
                              child: Image.asset(
                                'assets/Game/female.png',
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.topRight,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                      Container(
                        width: 134,
                        height: 10,
                        margin: EdgeInsets.only(top: 46, left: 163),
                        decoration: BoxDecoration(
                          color: _pokemonEnemyDeath
                              ? Colors.red
                              : Colors.grey[300], // Color base
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: 134 *
                                  (_currentEnemyPs /
                                      _maxEnemyPs), // Representa la cantidad actual de puntos de vida del Pokémon enemigo
                              height: 10,
                              decoration: BoxDecoration(
                                color: _pokemonEnemyDeath
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            Container(
                              width: 134 *
                                  ((_maxEnemyPs - _currentEnemyPs) /
                                      _maxEnemyPs), // Representa la cantidad perdida de puntos de vida del Pokémon enemigo
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors
                                    .red, // Color de puntos de vida perdidos
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 284,
                        child: Image.asset(
                          'assets/Game/grass-enemy.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                        height: 120,
                        margin: EdgeInsets.only(bottom: 25),
                        child: Image.network(
                          'http://20.162.113.208/${primerPokemon['foto_pokemon']}',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Función para mostrar el diálogo de victoria
 // Función para mostrar el diálogo de victoria
void showVictoryDialog(
    BuildContext context, String nombreLider, String medalla) {

    final String medallaFoto = medalla.replaceAll(RegExp(r'\s+'), '');
          print("Este es el nombre " + medallaFoto);
  showDialog(
    barrierDismissible: false, // El diálogo no se puede cerrar tocando fuera de él
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          width: 300.0,
          height: 260.0, // Ajusta la altura total del AlertDialog
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [
                const Color.fromRGBO(178, 168, 168, 1),
                const Color.fromRGBO(255, 255, 255, 1),
                const Color.fromRGBO(255, 255, 255, 1),
              ],
              stops: [0.0, 0.4, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(29, 30, 29, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(29, 30, 29, 1),
                      width: 1.0,
                    ),
                  ),
                ),
                height: 60,
                child: Center(
                  child: Text(
                    "¡Venciste a $nombreLider!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontFamily: 'sarpanch',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                height: 110,
                width: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color.fromRGBO(208, 56, 56, 1), // Color inicial
                      const Color.fromRGBO(255, 91, 91, 1), // Color final
                    ],
                  ),
                  border: Border.all(
                      color: Colors.black, width: 1.0), // Borde negro
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      // Texto
                      Text(
                        'Recibes:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'sarpanch',
                        ),
                      ),
                      // Espaciado entre el texto y las imágenes
                      SizedBox(height: 5.0),
                      // Fila de imágenes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                            child: Image.asset(
                              'assets/${medallaFoto}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          SizedBox(
                            height: 60,
                            child: Image.asset(
                              'assets/moneda.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 5.0),
                        ],
                      ),
                    ],
                  ),

                ),
              ),
              SizedBox(height: 15.0), // Espacio adicional si es necesario
              Container(
                width: 250,
                child: TextButton(
                  onPressed: () async {
                    // Código para continuar
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Menu()), // Cambia MyAppGame por Menu
                      (Route<dynamic> route) =>
                          false, // Elimina todas las rutas anteriores
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "TOCA PARA CONTINUAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'sarpanch',
                        ),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(29, 30, 29, 1),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      );
    },
  );
}


  Future<Map<String, dynamic>> obtenerDatosLider(int idLider) async {
    print('ID del líder de gimnasio: $idLider');
    final response = await http
        .get(Uri.parse('http://20.162.113.208:5000/api/lider/Battle/$idLider'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> pokemonDataList = data['pokemons'];
      final String medalla = data['medalla'];
      final String nombreLider = data['nombre_lider'];

      // Borra la lista de Pokémon existente antes de agregar los nuevos
      _pokemonList.clear();

      // Agregar cada Pokémon individualmente a la lista
      pokemonDataList.forEach((pokemon) {
        _pokemonList.add(pokemon);
      });

      print('Datos de la lista de Pokémon: $_pokemonList');
      final primerPokemon = _pokemonList[_currentPokemonIndex];
      pokemonEnemyDefense = primerPokemon['defensa'] as int;
      currentEnemyPs = primerPokemon['ps'] as int;
      maxEnemyPs = primerPokemon['ps'] as int;
      return {
        'pokemons': pokemonDataList,
        'medalla': medalla,
        'nombre_lider': nombreLider
      };
    } else {
      throw Exception('Error al cargar los datos del líder de gimnasio');
    }
  }
}

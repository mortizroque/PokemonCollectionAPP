import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemonapp/game/Pokemon_List.dart';
import 'package:pokemonapp/game/main.dart';
import 'package:pokemonapp/game/battle/components/battle_enemy_side.dart';
import 'package:pokemonapp/usuario_provider.dart';
import 'package:provider/provider.dart';

class PokemonInfo {
  final int pokemonId;

  PokemonInfo({required this.pokemonId});

  int get id => pokemonId;
}

class BattlePlayerSide extends StatefulWidget {
  @override
  _BattlePlayerSideState createState() => _BattlePlayerSideState();
}

class _BattlePlayerSideState extends State<BattlePlayerSide> {
  String pokemonName = "";
  String pokemonImage = "";
  bool _pokemonDataLoaded = false;
  List<PokemonInfo> pokemonInfos = [];
  static int currentPokemonId = 0;
  List<String> _attacks = [];
  List<int> _attackDamages = []; // Lista para almacenar el daño de cada ataque
  int currentPs = 100; // Valor predeterminado de puntos de vida actual
  int maxPs = 100; // Valor predeterminado de puntos de vida máximo
  int pokemonDefense = 0; // Variable para almacenar la defensa del Pokémon
  BattleEnemySide? _enemySide; // Referencia al lado del enemigo

  @override
  Widget build(BuildContext context) {
    _enemySide ??= BattleEnemySide(
        usuarioProvider: Provider.of<UsuarioProvider>(
            context)); // Inicializa _enemySide si es nulo

    return FutureBuilder(
      future: _pokemonDataLoaded ? null : _fetchPokemonData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Utiliza los datos del enemigo como desees
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 276,
                      margin: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/Game/grass-player.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    Container(
                      height: 120,
                      margin: EdgeInsets.only(left: 20),
                      child: pokemonImage.isNotEmpty
                          ? Image.network(
                              pokemonImage,
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.bottomLeft,
                            )
                          : Container(),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 281,
                      child: Image.asset(
                        'assets/Game/pokemon_info_ui.png',
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                    Container(
                      width: 281,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 40),
                            child: Text(
                              pokemonName,
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
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      width: 131,
                      height: 10,
                      margin: EdgeInsets.only(top: 45, left: 129),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Color base
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 131 *
                                (currentPs /
                                    maxPs), // Representa la cantidad actual de puntos de vida
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors
                                  .green, // Color de puntos de vida restantes
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          Container(
                            width: 131 *
                                ((maxPs - currentPs) /
                                    maxPs), // Representa la cantidad perdida de puntos de vida
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
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Game/background_text.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      for (var i = 0; i < _attacks.length; i++)
                        GestureDetector(
                          onTap: () {
                            // Obtener el daño del ataque seleccionado
                            int damage = _attackDamages[i];
                            // Aplicar el daño al enemigo utilizando la función en BattleEnemySide
                            handleAttackDamage(damage, context);
                            // Restar vida al Pokémon
                            _subtractPokemonLife();
                          },
                          child: Text(
                            _attacks[i],
                            style: TextStyle(
                              fontFamily: 'PokemonFireRed',
                              fontSize: 35,
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAppGame()),
                                );
                              },
                              child: Text(
                                "Huir",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'PokemonFireRed',
                                  fontSize: 35,
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void handleAttackDamage(int damage, BuildContext context) {
    _enemySide!.applyAttackDamage(damage, context);
  }

  void _subtractPokemonLife() {
    // Generar un número aleatorio entre 80 y 100
    var random = Random();
    int damage = random.nextInt(21) + 80; // Número aleatorio entre 80 y 100

    setState(() {
      // Restar el daño a los puntos de vida actuales
      currentPs -= damage - pokemonDefense;
      if (currentPs < 0) {
        currentPs = 0;
        // Si los puntos de vida son cero, mostrar el mensaje de "Perdiste"
        showDialog(
          context: context,
          builder: (BuildContext context) {
return AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          width: 300.0,
          height: 150.0, // Ajusta la altura total del AlertDialog
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
                    "¡Has sido Derrotado!",
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
                width: 250,
                child: TextButton(
                  onPressed: () async {
                    // Código para continuar
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyAppGame()), // Cambia MyAppGame por Menu
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
    });
  }

  Future<void> _fetchPokemonData() async {
    try {
      List<int> selectedPokemonIds = PokemonList.getSelectedPokemonIds();
      int pokemonId =
          selectedPokemonIds.isNotEmpty ? selectedPokemonIds.first : 1;
      String apiUrl =
          'http://20.162.113.208:5000/api/pokemon/ataques/$pokemonId';
      final response = await http.get(Uri.parse(apiUrl));
      print('HTTP Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Respuesta JSON: $data');

        setState(() {
          pokemonName = data['nombre_pokemon'];
          String relativeImagePath = data['foto_pokemon_back'];
          pokemonImage = 'http://20.162.113.208/$relativeImagePath';
          _pokemonDataLoaded = true;

          currentPokemonId = pokemonId;

          pokemonInfos.add(PokemonInfo(pokemonId: pokemonId));

          List<dynamic> attacksData = data['ataques'];
          List<String> attacks = [];
          for (var attackData in attacksData) {
            attacks.add(attackData['nombre_ataque'] as String);
            _attackDamages
                .add(attackData['daño'] as int); // Guarda el daño del ataque
          }
          _attacks = attacks;

          // Obtener y establecer la cantidad actual de puntos de vida (ps), la cantidad máxima posible y la defensa
          currentPs = data['ps'];
          maxPs = data['ps'];
          pokemonDefense = data['defensa'];
        });
      } else {
        throw Exception('Failed to load pokemon data');
      }
    } catch (error) {
      print('Error fetching pokemon data: $error');
    }
  }
}

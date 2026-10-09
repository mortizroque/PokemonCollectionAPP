import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemonapp/game/Pokemon_List.dart';
import 'dart:convert';

import 'package:pokemonapp/game/main.dart'; // Importa el archivo de la pantalla MyAppGame

class BattleActions extends StatefulWidget {
  @override
  _BattleActionsState createState() => _BattleActionsState();
}

class _BattleActionsState extends State<BattleActions> {
  List<String> _attacks = [];

  // Método para realizar la solicitud HTTP y obtener los ataques del Pokémon
  Future<void> _fetchPokemonAttacks() async {
    try {
      // Obtener el ID del Pokémon seleccionado desde PokemonList
      List<int> selectedPokemonIds = PokemonList.getSelectedPokemonIds();
      int idPokemon = selectedPokemonIds.isNotEmpty ? selectedPokemonIds.first : 1;

      // Hacer la solicitud HTTP para obtener los datos del Pokémon y sus ataques
      final response = await http.get(Uri.parse('http://20.162.113.208:5000/api/pokemon/ataques/$idPokemon'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData); // Imprime el JSON recibido
        List<dynamic> attacksData = jsonData['ataques'];
        List<String> attacks = [];
        for (var attackData in attacksData) {
          attacks.add(attackData['nombre_ataque'] as String);
        }
        setState(() {
          _attacks = attacks;
        });

        // Imprimir los nombres de los ataques con su número correspondiente
        for (int i = 0; i < _attacks.length; i++) {
          print('Ataque ${i + 1}: ${_attacks[i]}');
        }
      } else {
        throw Exception('Error al cargar los ataques del Pokémon');
      }
    } catch (error) {
      print(error);
      // Maneja el error de conexión
    }
  }

  @override
  void initState() {
    super.initState();
    // Llamar al método _fetchPokemonAttacks() en initState
    _fetchPokemonAttacks();

    // Obtener el ID del Pokémon seleccionado desde PokemonList
    List<int> selectedPokemonIds = PokemonList.getSelectedPokemonIds();
    int idPokemon = selectedPokemonIds.isNotEmpty ? selectedPokemonIds.first : 1;

    // Imprimir la URI de la solicitud HTTP
    String apiUrl = 'http://20.162.113.208:5000/api/pokemon/ataques/$idPokemon';
    print('URI de la solicitud: $apiUrl');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
            SizedBox(height: 25),
            for (var i = 0; i < _attacks.length; i++)
              GestureDetector(
                onTap: () {
                  // Lógica para manejar el tap del ataque
                },
                child: Text(
                  'Ataque ${i + 1}: ${_attacks[i]}',
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
                        MaterialPageRoute(builder: (context) => MyAppGame()),
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
    );
  }
}

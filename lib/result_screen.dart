import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pokemonapp/menu.dart';
import 'usuario.dart';
import 'usuario_provider.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showCardImage = false;

  final List<String> pokemonNames = [
    'Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon', 'Charizard', 'Squirtle', 'Wartortle', 'Blastoise',
    'Caterpie', 'Metapod', 'Butterfree', 'Weedle', 'Kakuna', 'Beedrill', 'Pidgey', 'Pidgeotto', 'Pidgeot', 'Rattata',
    'Raticate', 'Spearow', 'Fearow', 'Ekans', 'Arbok', 'Pikachu', 'Raichu', 'Sandshrew', 'Sandslash', 'Nidoran♀',
    'Nidorina', 'Nidoqueen', 'Nidoran♂', 'Nidorino', 'Nidoking', 'Clefairy', 'Clefable', 'Vulpix', 'Ninetales',
    'Jigglypuff', 'Wigglytuff', 'Zubat', 'Golbat', 'Oddish', 'Gloom', 'Vileplume', 'Paras', 'Parasect', 'Venonat',
    'Venomoth', 'Diglett', 'Dugtrio', 'Meowth', 'Persian', 'Psyduck', 'Golduck', 'Mankey', 'Primeape', 'Growlithe',
    'Arcanine', 'Poliwag', 'Poliwhirl', 'Poliwrath', 'Abra', 'Kadabra', 'Alakazam', 'Machop', 'Machoke', 'Machamp',
    'Bellsprout', 'Weepinbell', 'Victreebel', 'Tentacool', 'Tentacruel', 'Geodude', 'Graveler', 'Golem', 'Ponyta',
    'Rapidash', 'Slowpoke', 'Slowbro', 'Magnemite', 'Magneton', 'Farfetch\'d', 'Doduo', 'Dodrio', 'Seel', 'Dewgong',
    'Grimer', 'Muk', 'Shellder', 'Cloyster', 'Gastly', 'Haunter', 'Gengar', 'Onix', 'Drowzee', 'Hypno', 'Krabby',
    'Kingler', 'Voltorb', 'Electrode', 'Exeggcute', 'Exeggutor', 'Cubone', 'Marowak', 'Hitmonlee', 'Hitmonchan',
    'Lickitung', 'Koffing', 'Weezing', 'Rhyhorn', 'Rhydon', 'Chansey', 'Tangela', 'Kangaskhan', 'Horsea', 'Seadra',
    'Goldeen', 'Seaking', 'Staryu', 'Starmie', 'Mr. Mime', 'Scyther', 'Jynx', 'Electabuzz', 'Magmar', 'Pinsir',
    'Tauros', 'Magikarp', 'Gyarados', 'Lapras', 'Ditto', 'Eevee', 'Vaporeon', 'Jolteon', 'Flareon', 'Porygon',
    'Omanyte', 'Omastar', 'Kabuto', 'Kabutops', 'Aerodactyl', 'Snorlax', 'Articuno', 'Zapdos', 'Moltres', 'Dratini',
    'Dragonair', 'Dragonite', 'Mewtwo', 'Mew'
  ];

  @override
  Widget build(BuildContext context) {
    int foundPokemonIndex = pokemonNames.indexWhere((pokemon) => widget.text.contains(pokemon));

    return Scaffold(
      appBar: null,
      body: GestureDetector(
        onTap: () {
          _showSaveConfirmation(context, foundPokemonIndex);
        },
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints.expand(),
              child: Image.asset(
                'assets/fondo_ocr.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: _showCardImage
                  ? AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(seconds: 3),
                      child: Image.asset(
                        'assets/pokeball.png',
                        height: 200,
                        width: 200,
                      ),
                    )
                  : (foundPokemonIndex != -1
                      ? FutureBuilder<String?>(
                          future: fetchCardImage(foundPokemonIndex),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              final cardImageLocation = snapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  _showSaveConfirmation(context, foundPokemonIndex);
                                },
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: Duration(seconds: 3),
                                  child: Image.network(
                                    'http://20.162.113.208$cardImageLocation',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return Text('No se encontró ninguna imagen de carta para este Pokémon');
                            }
                          },
                        )
                      : Text('No se encontró ningún Pokémon')),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> fetchCardImage(int pokemonIndex) async {
    final pokemonId = pokemonIndex + 1;
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

  void _showSaveConfirmation(BuildContext context, int foundPokemonIndex) async {
    try {
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      final usuario = usuarioProvider.usuario;

      final pokemonId = foundPokemonIndex + 1;

      // Verifica si ya se ha guardado el Pokémon
      if (!_showCardImage) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Guardar Pokémon'),
              content: Text('¿Quieres guardar este Pokémon?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    final apiUrl = 'http://20.162.113.208:5000/api/pokedex';
                    final requestBody = jsonEncode({
                      'id_usuario': usuario!.idUsuario,
                      'id_pokemon': pokemonId,
                    });

                    final response = await http.post(
                      Uri.parse(apiUrl),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: requestBody,
                    );

                    if (response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Pokémon guardado'),
                        ),
                      );

                      // Set _showCardImage to true to trigger the animation
                      setState(() {
                        _showCardImage = true;
                      });

                      // Navegar a la pantalla del menú después del guardado
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar el Pokémon'),
                        ),
                      );
                    }

                    Navigator.of(context).pop(); // Cierra el diálogo de confirmación
                  },
                  child: Text('Sí'),
                ),
              ],
            );
          },
        );
      } else {
        // Si _showCardImage es true (ya se guardó el Pokémon), navega al menú
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

}

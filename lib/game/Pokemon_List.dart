import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemonapp/game/battle/main.dart';
import 'package:provider/provider.dart';
import '../usuario.dart';
import '../usuario_provider.dart';
import 'package:pokemonapp/game/battle/screens/battle_screen.dart';

class GlobalState {
  static int idUsuario = 0;
}

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();

  static List<int> getSelectedPokemonIds() {
    return _PokemonListState.getSelectedPokemonIds();
  }
}

class _PokemonListState extends State<PokemonList> {
  static List<int> _selectedPokemonIds = [];
  TextEditingController _searchController = TextEditingController();

  static List<int> getSelectedPokemonIds() {
    return _selectedPokemonIds;
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;

    // Guardar idUsuario en GlobalState
    if (usuario != null) {
      GlobalState.idUsuario = usuario.idUsuario;
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: CustomPaint(
              painter: CustomContainerPainter(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 22, 22, 1), // Color rojo
                    Color.fromRGBO(46, 4, 4, 1), // Color negro
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Biblioteca de Pokémon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Sarpanch'
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'de ${usuario?.nombreUsuario ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Sarpanch'
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
Container(
  color: Colors.black,
  padding: EdgeInsets.all(8.0),
  child: SizedBox(
    height: 30,
    child: Container(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          // Establece el color del texto en blanco
          hintStyle: TextStyle(color: Colors.white),
          // Establece el color del texto en blanco cuando está seleccionado
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          // Centra el texto dentro del TextField
          contentPadding: EdgeInsets.symmetric(vertical:8.0), // Ajusta el padding vertical para centrar verticalmente el texto
        ),
        onChanged: (value) {
          setState(() {});
        },
        style: TextStyle(color: Colors.white), // Color del texto en blanco
      ),
    ),
  ),
),


          Expanded(
            child: CustomPaint(
              painter: CustomContainerPainter(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(179, 179, 179, 1),
                    Colors.white,
                  ],
                ),
              ),
              child: _buildPokemonList(),
            ),
          ),
          if (_selectedPokemonIds.length == 6)
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _navigateToBattleScreen(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 30, 29, 1)), // Color de fondo del botón
                ),
                child: Container( // Envuelve el texto en un contenedor para aplicar alineación
                  alignment: Alignment.center,
                  child: Text(
                    'COMENZAR BATALLA',
                    textAlign: TextAlign.center, // Alinea el texto al centro
                    style: TextStyle(
                      fontSize: 18, // Tamaño del texto dentro del botón
                      fontFamily: 'Sarpanch',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPokemonList() {
    return FutureBuilder(
      future: _fetchPokemonList(GlobalState.idUsuario),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> pokemonList = snapshot.data ?? [];

          final filteredPokemonList = pokemonList.where((pokemon) {
            final pokemonName =
                pokemon['nombre_pokemon'].toString().toLowerCase();
            final searchValue = _searchController.text.toLowerCase();
            return pokemonName.contains(searchValue);
          }).toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: filteredPokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = filteredPokemonList[index];
              String imageUrl =
                  'http://20.162.113.208/' + pokemon['foto_pokemon'];
              bool isSelected = _selectedPokemonIds
                  .contains(pokemon['id_pokemon']);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedPokemonIds
                        .contains(pokemon['id_pokemon'])) {
                      _selectedPokemonIds
                          .remove(pokemon['id_pokemon']);
                    } else {
                      if (_selectedPokemonIds.length < 6) {
                        _selectedPokemonIds
                            .add(pokemon['id_pokemon']);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '¡Ya has seleccionado 6 Pokémon!'),
                          ),
                        );
                      }
                    }
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color.fromRGBO(229, 166, 94, 1) : Colors.white,
                      ),
                      child: Center(
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      pokemon['nombre_pokemon'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarpanch',
                        color:  Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> _fetchPokemonList(int userId) async {
    final response = await http.get(
        Uri.parse(
            'http://20.162.113.208:5000/api/pokemon/usuario/$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  void _navigateToBattleScreen(BuildContext context) {
    if (_selectedPokemonIds.length == 6) {
      _selectedPokemonIds = List.from(_selectedPokemonIds);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyBattle()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecciona 6 Pokémon para continuar.'),
        ),
      );
    }
  }
}

class CustomContainerPainter extends CustomPainter {
  final LinearGradient gradient;

  CustomContainerPainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

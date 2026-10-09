import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokemonapp/bar.dart';
import 'package:pokemonapp/menu.dart';
import 'dart:typed_data';
import 'package:pokemonapp/usuario.dart';
import 'usuario_provider.dart';
import 'package:provider/provider.dart';


class Pokedex extends StatefulWidget {
  @override
  _PokedexState createState() => _PokedexState();
}
class _PokedexState extends State<Pokedex> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  int inicio = 1;
  int _currentIndex = 0;
  late CustomNavBar _customNavBar;
  @override
  void initState() {
    super.initState();
    _customNavBar = CustomNavBar(
      currentIndex: _currentIndex,
      coins: 0, // Inicializa el valor con 0 o el valor real de las monedas
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late final Size screenSize = MediaQuery.of(context).size;

    // Calcula el tamaño de la imagen del fondo
    double backgroundWidth = screenSize.width * 1.2;
    double backgroundHeight = screenSize.height * 1.2;
    return WillPopScope(
      onWillPop: () async {
        // Llama a la función updateCoins() cuando el usuario haga clic en "hacia atrás"
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
        updateCoins();
        return false; // Retorna true para permitir la acción de retroceso
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/fondosec.png',
                  ),
                  fit: BoxFit.fill,
                ),
                  ),
            ),
             _labels(context),
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              bottom: 0,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                children: [
                  _pokedexContent(),
                  _duplicatesContent(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 20,
              child: _customNavBar, // Utilizamos la variable almacenada
            ),
          ],
        ),        
      ),
    );
  }

  Widget _labels(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.12,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: 2,
              ),
              decoration: BoxDecoration(
                border: _currentPageIndex == 0
                    ? Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      )
                    : null,
              ),
              child: Text(
                "POKEDEX",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'sarpanch',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: 2,
              ),
              decoration: BoxDecoration(
                border: _currentPageIndex == 1
                    ? Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      )
                    : null,
              ),
              child: Text(
                "DUPLICATES",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'sarpanch',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _pokedexContent() {
  final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
  final usuario = usuarioProvider.usuario;
  int idUsuario = usuario?.idUsuario ?? 0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(width: 15,
          height: 5),
          Positioned(
            left: MediaQuery.of(context).size.height * 1.1, // Ajusta la posición horizontal según sea necesario
            top: MediaQuery.of(context).size.height * 0.01, // Ajusta la posición vertical según sea necesario
            child: FutureBuilder<String>(
              future: countUserCards(idUsuario), // Pasa el ID del usuario
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      '${snapshot.data} / 151',
                      style: TextStyle(fontSize: 24, fontFamily: 'Sarpanch'),
                    );
                  }
                }
              },
            ),
          ),
          SizedBox(width: 20), // Espacio entre los dos Positioned
          Positioned(
            left: MediaQuery.of(context).size.height * 0.15, // Ajusta la posición horizontal según sea necesario
            top: MediaQuery.of(context).size.height * 0.018, // Ajusta la posición vertical según sea necesario
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ), // Define el borde negro
                borderRadius: BorderRadius.circular(25.0), // Define el radio del borde
              ),
              child: FutureBuilder<String>(
                future: countUserCards(idUsuario), // Pasa el ID del usuario
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int collectedCards = int.parse(snapshot.data ?? '0');
                      double progress = collectedCards / 151; // Calcula el progreso como el número de cartas recolectadas dividido por 151
                      return LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width / 1.6,
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2500,
                        percent: progress,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: const Color.fromRGBO(229, 166, 94, 1),
                        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Expanded(
        child: FutureBuilder<List<dynamic>>(
          future: fetchUserCards(idUsuario), // Cambia 1 por el ID del usuario
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data.toString() == "") {
              // Agregar verificación de nulidad aquí
              return Center(child: Text('No se encontraron cartas de usuario.'));
            } else {
              List<dynamic> userCards = snapshot.data!;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: 151, // Mostrar 151 cartas
                itemBuilder: (context, index) {
                  bool userHasCard = userHasCardAtIndex(index, userCards);
                  String imageUrl;
                  if (userHasCard) {
                    String baseUrl = 'http://20.162.113.208';
                    String imagePath = '/FOTOS_CARTAS/${index + 1}.png'; // La imagen sigue el formato de ID de Pokémon
                    imageUrl = baseUrl + imagePath;
                  } else {
                    // Si el usuario no tiene la carta, cargar la imagen estática desde assets
                    imageUrl = 'assets/ContraPortada.png';
                  }
                  return GestureDetector(
                    onTap: () {
                      // Mostrar la imagen centrada y aumentada al hacer clic
                      if (userHasCard) {
                        _showCenteredImage(context, imageUrl);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: userHasCard
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.fitHeight,
                            )
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.fitHeight,
                            ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ],
  );
}
  bool userHasCardAtIndex(int index, List<dynamic> userCards) {
    // Verificar si el JSON contiene una carta con el ID del Pokémon correspondiente al índice
    bool hasCard = userCards.any((card) => card['id_pokemon'] == index + 1);
    return hasCard;
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
  Widget _duplicatesContent() {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;
    int idUsuario = usuario?.idUsuario ?? 0;
    int pokemon = 59;
    return FutureBuilder<List<dynamic>>(
      future: fetchDuplicateCards(idUsuario),
     
      builder: (context, snapshot) {
         print("ESTO ES LO QUE DEVUELVE " + snapshot.data.toString());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data.toString() == "[]") {
        return Center(
          child: Text(
            'No tienes cartas duplicadas.',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'sarpanch',
              fontSize: 18,
            ),
          ),
        );
        } else {
          List<dynamic> duplicateCards = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: duplicateCards.length,
            itemBuilder: (context, index) {
              String imageUrl = duplicateCards[index]['foto_carta'];
              int duplicatesCount =(duplicateCards[index]['cantidad_repetidas'] ?? 0) - 1;
              int cardNumber =
                  int.parse(imageUrl.split('/').last.split('.').first);
              // Verificar si ya es una URL completa
              if (!imageUrl.startsWith('http')) {
                // Si no es una URL completa, construir la URL completa
                imageUrl = 'http://20.162.113.208$imageUrl';
              }
              return Stack(
                alignment: Alignment.center, // Alineación a la derecha
                children: [
                  GestureDetector(
                    onTap: () {
                      mostrarPokedex(idUsuario, cardNumber);
                      _showPopUp(
                          context, imageUrl, duplicatesCount, cardNumber);
                          print('Número de la carta: $cardNumber');
                    },
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  if (duplicatesCount >
                      1) // Mostrar redonda solo si duplicatesCount es mayor que 0
                    Positioned(
                      top: 100,
                      right: 50,
                      child: Container(
                        width: 25,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(244, 67, 54, 0.685),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            duplicatesCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              );
            },
          );
        }
      },
    );
  }



Future<List<dynamic>> fetchDuplicateCards(int userId) async {
  final response = await http.get(
    Uri.parse('http://20.162.113.208:5000/api/cartas/usuario/dupes/$userId')
  );
  
  if (response.statusCode == 200) {
    // Decodificar la respuesta JSON
    List<dynamic> jsonData = json.decode(response.body);

    // Obtener la lista de cartas duplicadas
    List<dynamic> duplicateCards = [];
    for (var item in jsonData) {
      for (var carta in item['cartas_repetidas']) {
        duplicateCards.add({
          'id_pokemon': carta['id_pokemon'],
          'foto_carta': carta['foto_carta'],
          'cantidad_repetidas': item['cantidad_repetidas'],
        });
      }
    }
    return duplicateCards;
  } else if (response.statusCode == 404) {
    print('No se encontraron cartas duplicadas para el usuario $userId');
    return []; // Devuelve una lista vacía si el estado es 404
  } else {
    throw Exception('Failed to load duplicate cards');
  }
}




Future<List<dynamic>> fetchUserCards(int userId) async {
  print("PRUEBA PARA SABER SI HACE LA LLAMADA");
  
  final response = await http.get(
    Uri.parse('http://20.162.113.208:5000/api/cartas/usuario/$userId')
  );
  print("TIENE RESPUESTA");

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    List<dynamic> userCards = json.decode(response.body);
    while (!json.encode(userCards).contains(']')) {
      await Future.delayed(Duration(seconds: 1)); // Esperar un segundo antes de verificar nuevamente
      final updatedResponse = await http.get(
        Uri.parse('http://20.162.113.208:5000/api/cartas/usuario/$userId')
      );
      print("TIENE RESPUESTA");
      if (updatedResponse.statusCode == 200) {
        print(json.decode(updatedResponse.body));
        userCards = json.decode(updatedResponse.body);
      } else {
        throw Exception('Failed to load user cards');
      }
    }
    return userCards;
  } else if (response.statusCode == 404) {
    return []; // Devuelve una lista vacía si el estado es 404
  } else {
    throw Exception('Failed to load user cards');
  }
}


  Future<void> _showPopUp(
    BuildContext context,
    String imageUrl,
    int duplicatesCount,
    int cardNumber,
  ) async {
    int currentCount = 1; // Inicialmente, siempre mostrará 1
    int precio = 15;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                width: 300.0,
                height: 430.0,
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
                          'SELL DUPLICATE',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 173, 172, 172),
                            fontSize: 24.0,
                            fontFamily: 'sarpanch',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 280,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color.fromRGBO(208, 56, 56, 1),
                            const Color.fromRGBO(255, 91, 91, 1),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 200,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'x$currentCount', // Siempre mostrará el valor actual del contador
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontFamily: 'sarpanch',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: 260,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón de resta
                                if (currentCount > 1) {
                                  setState(() {
                                    currentCount--; // Reducir solo si no hemos alcanzado el mínimo
                                  });
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(40, 40)),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(0)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(Icons.remove),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 150,
                            child: TextButton(
                              onPressed: () async {
                                final usuarioProvider =
                                    Provider.of<UsuarioProvider>(context,
                                        listen: false);
                                final usuario = usuarioProvider.usuario;
                                int idUsuario = usuario?.idUsuario ?? 0;
                                final precioTotal = precio * currentCount;

                                try {
                                  List<int> pokedexEntries =
                                      await mostrarPokedex(
                                          idUsuario, cardNumber);
                                  int pokedexEntryCount = pokedexEntries.length;
                                  for (int i = pokedexEntryCount - 1;
                                      i >= 0 &&
                                          i >= pokedexEntryCount - currentCount;
                                      i--) {
                                    int idPokedexEntry = pokedexEntries[i];
                                    await deletePokedexEntry(idPokedexEntry);
                                  }
                                  await updateMonedas(idUsuario, precioTotal);
                                  updateCoins();
                                  _duplicatesContent(); // Llama a la función para actualizar las monedas y _customNavBar
                                  Navigator.of(context).pop();
                                } catch (error) {
                                  print(
                                      'Error al actualizar las monedas: $error');
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('assets/moneda.png'),
                                  SizedBox(width: 5.0),
                                  Text(
                                    '${precio * currentCount}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontFamily: 'sarpanch',
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Image.asset('assets/moneda.png'),
                                ],
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(29, 30, 29, 1),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón de suma
                                if (currentCount < duplicatesCount) {
                                  setState(() {
                                    currentCount++; // Incrementar solo si no hemos alcanzado el máximo
                                  });
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(40, 40)),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(0)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.zero,
            );
          },
        );
      },
    );
  }
  void updateCoins() async {
    final usuarioProvider =
        Provider.of<UsuarioProvider>(context, listen: false);
    final usuario = usuarioProvider.usuario;
    int idUsuario = usuario?.idUsuario ?? 0;
    final updatedCoins = await fetchUserCoins(idUsuario);
    setState(() {
      _customNavBar = CustomNavBar(
        currentIndex: _currentIndex,
        coins: updatedCoins[
            'monedas'], // Actualiza el número de monedas en _customNavBar
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      );
    });
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

Future<void> updateMonedas(int idUsuario, int cantidadMonedas) async {
  final url = Uri.parse('http://20.162.113.208:5000/api/tienda');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id_usuario': idUsuario,
      'monedas': cantidadMonedas,
      'cantidad_pokecoins': 0, // No modificamos las pokecoins en este caso
    }),
  );
  if (response.statusCode == 200) {
    print('Monedas actualizadas correctamente');
  } else {
    throw Exception('Failed to update monedas');
  }
}

Future<List<int>> mostrarPokedex(int userId, int idPokemon) async {
  final url = Uri.parse(
      'http://20.162.113.208:5000/api/pokedex/user/$userId/pokemon/$idPokemon');
      final response = await http.get(url);

  if (response.statusCode == 200) {
    // Aquí puedes imprimir los resultados o realizar cualquier otra acción
    print('Resultados de la Pokédex:');
    List<int> pokedexEntries = [];
    // Analiza la respuesta JSON y extrae las id_pokedex
    List<dynamic> data = json.decode(response.body);
    for (var entry in data) {
      pokedexEntries.add(entry['id_pokedex']);
    }
    print('ID Pokedex del Pokémon $idPokemon: $pokedexEntries');
    return pokedexEntries;
  } else {
    // Si la solicitud no fue exitosa, puedes manejarlo de acuerdo a tus necesidades
    print(
        'Hubo un error al obtener los datos de la Pokédex. Código de estado: ${response.statusCode}');
    throw Exception('Failed to fetch Pokédex entries');
  }
}

Future<void> deletePokedexEntry(int idPokedexEntry) async {
  final url = Uri.parse(
      'http://20.162.113.208:5000/api/pokedex/delete/$idPokedexEntry');

  final response = await http.delete(url);

  if (response.statusCode == 200) {
    // Si el borrado fue exitoso, puedes manejarlo aquí
    print('La entrada de la Pokedex ha sido eliminada correctamente');
  } else {
    // Si el borrado no fue exitoso, puedes manejarlo aquí
    print(
        'Hubo un error al eliminar la entrada de la Pokedex. Código de estado: ${response.statusCode}');
  }
}
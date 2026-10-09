import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyPokeLab extends StatelessWidget {
  double x;
  double y;
  String currentMap;

  MyPokeLab({this.x = 0.0, this.y = 0.0, this.currentMap = ''});

  @override
  Widget build(BuildContext context){
    if (currentMap == 'pokelab') {
      return Container(
        alignment: Alignment(x, y),
        child: Image.asset(
          'assets/Game/Pokelab.png',
          width: MediaQuery.of(context).size.width *
              0.75,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container();
    }
  }
}
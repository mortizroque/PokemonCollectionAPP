import 'package:flutter/material.dart';

class Battleblaine extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String BlaineDirection = '';

  Battleblaine({required this.x, required this.y, required this.location, required this.BlaineDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'pokelab') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/blaine' + BlaineDirection + '.png',
          width: MediaQuery.of(context).size.width *
              0.75,
          fit: BoxFit.cover,
        ),
      );
    }else {
      return Container();
    }
  }
}

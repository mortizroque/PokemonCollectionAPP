import 'package:flutter/material.dart';

class Battlemisty extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String MistyDirection = '';

  Battlemisty({required this.x, required this.y, required this.location, required this.MistyDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'upbluehouse') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/misty' + MistyDirection + '.png',
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

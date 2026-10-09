import 'package:flutter/material.dart';

class BattleSabrina extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String SabrinaDirection = '';

  BattleSabrina({required this.x, required this.y, required this.location, required this.SabrinaDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'bluehouse') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/Sabrina' + SabrinaDirection + '.png',
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

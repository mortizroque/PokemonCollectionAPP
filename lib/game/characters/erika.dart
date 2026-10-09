import 'package:flutter/material.dart';

class BattleErika extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String ErikaDirection = '';

  BattleErika({required this.x, required this.y, required this.location, required this.ErikaDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'pinkhouse') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/Erika' + ErikaDirection + '.png',
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

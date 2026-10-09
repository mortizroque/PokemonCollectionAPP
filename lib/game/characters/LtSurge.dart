import 'package:flutter/material.dart';

class BattleLtSurge extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String LtSurgeDirection = '';

  BattleLtSurge({required this.x, required this.y, required this.location, required this.LtSurgeDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'pokelab') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/LtSurge' + LtSurgeDirection + '.png',
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

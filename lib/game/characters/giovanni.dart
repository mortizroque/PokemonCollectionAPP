import 'package:flutter/material.dart';

class Battlegiovanni extends StatelessWidget{
  double x = 0.0;
  double y = 0.0;
  String location = '';
  String GiovanniDirection = '';

  Battlegiovanni({required this.x, required this.y, required this.location, required this.GiovanniDirection});

  @override
  Widget build(BuildContext context) {
    if (location == 'littleroot') {
      return Container(
        alignment: Alignment(x,y),
        child: Image.asset(
          'assets/Game/personajes/giovanni' + GiovanniDirection + '.png',
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

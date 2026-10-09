import 'package:flutter/material.dart';

class pinkhouse extends StatelessWidget {
  double x;
  double y;
  String currentMap;

  pinkhouse({this.x = 0.0, this.y = 0.0, this.currentMap = ''});

  @override
  Widget build(BuildContext context) {
    if (currentMap == 'pinkhouse') {
      return Container(
        alignment: Alignment (x, y),
        child: Image.asset(
          'assets/Game/HousePink.png',
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
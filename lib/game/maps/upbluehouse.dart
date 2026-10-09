import 'package:flutter/material.dart';

class upbluehouse extends StatelessWidget {
  double x;
  double y;
  String currentMap;

  upbluehouse({this.x = 0.0, this.y = 0.0, this.currentMap = ''});

  @override
  Widget build(BuildContext context) {
    if (currentMap == 'upbluehouse') {
      return Container(
        alignment: Alignment (x, y),
        child: Image.asset(
          'assets/Game/HouseBlueUp.png',
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
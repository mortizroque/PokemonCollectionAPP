import 'package:flutter/material.dart';

class LittleRoot extends StatelessWidget {
  double x;
  double y;
  String currentMap;

  LittleRoot({this.x = 0.0, this.y = 0.0, this.currentMap = ''});

  @override
  Widget build(BuildContext context) {
    if (currentMap == 'littleroot') {
      return Container(
        alignment: Alignment (x, y),
        child: Image.asset(
          'assets/Game/littleroot.png',
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
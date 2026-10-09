import 'package:flutter/material.dart';
import 'package:pokemonapp/game/battle/screens/battle_screen.dart';

void main() {
  runApp(MyBattle());
}

class MyBattle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BattleScreen(),
      ),
    );
  }
}

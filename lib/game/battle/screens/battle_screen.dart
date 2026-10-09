import 'package:flutter/material.dart';
import 'package:pokemonapp/game/battle/components/battle_actions.dart';
import 'package:pokemonapp/game/battle/components/battle_enemy_side.dart' as EnemySide; // Renombramos BattleEnemySide para evitar conflictos
import 'package:pokemonapp/game/battle/components/battle_player_side.dart';
import 'package:pokemonapp/usuario_provider.dart';
import 'package:provider/provider.dart';

class BattleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Game/background-grass.png"),
            fit: BoxFit.fitHeight, // Ajusta la imagen para adaptarse a la altura de la pantalla
          ),
        ),
        child: Column(
          children: <Widget>[
            EnemySide.BattleEnemySide(usuarioProvider: Provider.of<UsuarioProvider>(context)), // Usamos el BattleEnemySide importado como EnemySide
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BattlePlayerSide(),
                    //BattleActions(), // Pasa una lista vacía como placeholder
                    SizedBox(height: 20), // Añadir un espacio entre BattleActions y el borde inferior
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
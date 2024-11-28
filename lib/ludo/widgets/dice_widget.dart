import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:allgames/ludo/constants.dart';
import 'package:allgames/ludo/ludo_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class DiceWidget extends StatelessWidget {
  final String name;
  final int amount ;
  
  final LudoPlayerType playerType;
  final bool isActive;

  const DiceWidget({
    super.key,
    required this.playerType,
    required this.isActive, required this.name, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LudoProvider>(
      builder: (context, value, child) => RippleAnimation(
        color: isActive && value.gameState == LudoGameState.throwDice
            ? value.player(playerType).color
            : Colors.transparent,
        ripplesCount: 3,
        minRadius: 20,
        repeat: true,
        child: CupertinoButton(
          onPressed: isActive ? value.throwDice : null,
          padding: const EdgeInsets.only(),
          child: value.diceStarted && isActive
              ? Image.asset("assets/images/dice/draw.gif", fit: BoxFit.contain)
              : Image.asset(
                  "assets/images/dice/${value.diceResult}.png",
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}

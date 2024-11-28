import 'package:flutter/cupertino.dart';

import 'picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatelessWidget {
  final Map<Player, Widget> colorOptions = <Player, Widget>{
    Player.player1: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/chess/images/white_king.png',
          width: 25,
          height: 25,
        ),
        Text('WHITE',
            style: TextStyle(
              fontFamily: 'Eater-Regular',
            ))
      ],
    ),
    Player.player2: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/chess/images/black_king.png',
          width: 25,
          height: 25,
        ),
        Text('BLACK',
            style: TextStyle(
              fontFamily: 'Eater-Regular',
            ))
      ],
    ),
    Player.random: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/chess/images/both_king.png',
          width: 25,
          height: 25,
        ),
        Text('RANDOM',
            style: TextStyle(
              fontFamily: 'Eater-Regular',
            ))
      ],
    ),
  };

  final Player playerSide;
  final Function(Player?) setFunc;

  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: 'Select Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}

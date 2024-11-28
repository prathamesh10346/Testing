import 'package:flutter/cupertino.dart';

import 'picker.dart';

class GameModePicker extends StatelessWidget {
  final Map<int, Widget> playerCountOptions = const <int, Widget>{
    1: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person,
              color: Color(0xffBEBEBE),
            ),
            SizedBox(
              width: 5,
            ),
            Text('One Player',
                style: TextStyle(
                  fontFamily: 'Eater-Regular',
                ))
          ],
        )),
    2: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.person_2,
          color: Color(0xffBEBEBE),
        ),
        SizedBox(
          width: 5,
        ),
        Text('Two Player',
            style: TextStyle(
              fontFamily: 'Eater-Regular',
            ))
      ],
    )
  };

  final int playerCount;
  final Function(int?) setFunc;

  GameModePicker(this.playerCount, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Game Mode',
      options: playerCountOptions,
      selection: playerCount,
      setFunc: setFunc,
    );
  }
}

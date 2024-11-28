import 'package:flutter/cupertino.dart';

import 'picker.dart';

class AIDifficultyPicker extends StatelessWidget {
  final Map<int, Widget> difficultyOptions = {
    1: Padding(padding: EdgeInsets.all(8), child: Text('1')),
    2: Text('2'),
    3: Text('3'),
    4: Text('4'),
    5: Text('5'),
    6: Text('6')
  };

  final int aiDifficulty;
  final Function(int?) setFunc;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Set Difficulty',
      options: difficultyOptions,
      selection: aiDifficulty,
      setFunc: setFunc,
    );
  }
}

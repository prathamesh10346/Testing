import 'package:allgames/chess/views/components/main_menu_view/game_options/picker.dart';
import 'package:flutter/cupertino.dart';

class TimeLimitPicker extends StatelessWidget {
  final int? selectedTime;
  final Function(int?)? setTime;

  TimeLimitPicker({this.selectedTime, this.setTime});

  final Map<int, Widget> timeOptions = const <int, Widget>{
    0: Padding(padding: EdgeInsets.all(7), child: Text('None')),
    15: Text('15 min'),
    30: Text('30 min'),
    60: Text('1hr'),
  };

  @override
  Widget build(BuildContext context) {
    return Picker<int>(
      label: 'Play Time',
      options: timeOptions,
      selection: selectedTime,
      setFunc: setTime,
    );
  }
}

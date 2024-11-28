import 'package:flutter/cupertino.dart';

import '../../shared/text_variable.dart';

class Picker<T> extends StatelessWidget {
  final String? label;
  final Map<T, Widget>? options;
  final T? selection;
  final Function(T?)? setFunc;

  Picker({this.label, this.options, this.selection, this.setFunc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label ?? "",
                style: const TextStyle(
                    fontFamily: 'Jura',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffBEBEBE))),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(fontFamily: 'Eater-Regular', fontSize: 8),
              ),
            ),
            child: CupertinoSlidingSegmentedControl<T>(
              children: options ?? {},
              groupValue: selection,
              onValueChanged: (T? val) {
                if (setFunc != null) {
                  setFunc!(val);
                }
              },
              thumbColor: const Color(0xff0128F6).withOpacity(0.75),
              backgroundColor: const Color(0xff060B77),
            ),
          ),
          width: double.infinity,
        )
      ],
    );
  }
}

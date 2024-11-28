import 'package:allgames/chess/model/app_model.dart';
import 'package:allgames/chess/views/components/shared/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../chess_view.dart';
import '../../settings_view.dart';

class MainMenuButtons extends StatelessWidget {
  final AppModel appModel;

  MainMenuButtons(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    appModel.newGame(context, notify: false);
                    return ChessView(appModel);
                  },
                ),
              );
            },
            child: Container(
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xff006AFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Play Now",
                  style: TextStyle(
                    color: const Color(0xffF2F2F2),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SettingsView(),
                    ),
                  );
                },
                child: Image.asset("assets/chess/images/setting.png",
                    fit: BoxFit.cover, width: 60, height: 40),
              )
            ],
          ),
        ],
      ),
    );
  }
}

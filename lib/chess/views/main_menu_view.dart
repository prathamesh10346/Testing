import 'package:allgames/chess/model/app_model.dart';
import 'package:allgames/chess/views/components/main_menu_view/game_options.dart';
import 'package:allgames/chess/views/components/shared/bottom_padding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/main_menu_view/main_menu_buttons.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            Color(0xff1A1B50),
            Color(0xff0D0918),
          ])),
          padding: EdgeInsets.all(30),
          child: Stack(
            children: [
              Positioned(
                top: 300,
                right: 115,
                child: Text("CHESS",
                    style: TextStyle(
                        color: Color(0xffF2F2F2),
                        fontSize: 30,
                        fontFamily: "Eater-Regular",
                        fontWeight: FontWeight.bold)),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          "assets/images/img/back.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        10, MediaQuery.of(context).padding.top + 10, 10, 0),
                    child: Image.asset(
                      'assets/chess/images/chess.png',
                      height: 300,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: 10),
                  GameOptions(appModel),
                  SizedBox(height: 10),
                  MainMenuButtons(appModel),
                  BottomPadding(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

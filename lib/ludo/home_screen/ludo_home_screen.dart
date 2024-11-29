import 'package:allgames/ludo/home_screen/ludo_setting_screen.dart';
import 'package:allgames/ludo/home_screen/play_choose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LudoGameSelectionScreen extends StatefulWidget {
  @override
  State<LudoGameSelectionScreen> createState() =>
      _LudoGameSelectionScreenState();
}

class _LudoGameSelectionScreenState extends State<LudoGameSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[800],
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xff2539A5),
            // gradient:
            //     LinearGradient(colors: [Color(0xff050B62), Color(0xff090A5A)]),
            image: DecorationImage(
                opacity: 0.11,
                image: AssetImage(
                  'assets/images/ludo/home/backgroundimg.png',
                ),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/images/img/back.png",
                          width: 35,
                          height: 35,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  Container(
                    height: 5,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Color(0xffBDBF52)),
                  ),
                  SizedBox(height: 140),
                  Image.asset(
                    'assets/images/ludo/home/ludo_home_item.png',
                    width: 300,
                  ),
                  SizedBox(height: 65),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChoosePlayerSelectionScreen(
                            key: Key('ChoosePlayerSelectionScreen'),
                            isOnline: true,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/ludo/home/playbuttonPng.png',
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChoosePlayerSelectionScreen(
                            key: Key('ChoosePlayerSelectionScreen'),
                            isOnline: false,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/ludo/home/playwithfriendPng.png',
                      width: 300,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -10,
                left: 20,
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/ludo/home/homeitem.png'),
                          fit: BoxFit.fitWidth),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 60),
                        Column(
                          children: [
                            SizedBox(height: 80),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/home/profile.png',
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Name",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: "PoetsenOne-Regular",
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text("+91 1234567890",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: "PoetsenOne-Regular",
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen()));
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Color(0xff003090),
                                        border: Border.all(color: Colors.white),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Icon(Icons.settings,
                                            size: 20, color: Colors.white)),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Color(0xff003090),
                                      border: Border.all(color: Colors.white),
                                      shape: BoxShape.circle),
                                  child: Center(
                                      child: Icon(Icons.notifications_rounded,
                                          size: 20, color: Colors.yellow)),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 125,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Color(0xff003090),
                                borderRadius: BorderRadius.circular(200),
                                border: Border.all(
                                    color: Color(0xff03C3FF), width: 5),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                    child: Text('₹ 10',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Positioned(
                                    top: -29,
                                    left: -30,
                                    child: Image.asset(
                                      'assets/images/ludo/home/walleticon.png',
                                      width: 75,
                                      height: 75,
                                    ),
                                  ),
                                  Positioned(
                                    top: -5,
                                    right: -10,
                                    child: Image.asset(
                                      'assets/images/ludo/home/addIcon.png',
                                      width: 31,
                                      height: 31,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:allgames/ludo/ludo_provider.dart';
import 'package:allgames/ludo/widgets/board_widget.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final int playerCount;

  const MainScreen({Key? key, required this.playerCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          colors: [
            Color(0xff5E58A1),
            Color(0xff1D043C),
            Color(0xff1D043C),
          ],
          center: Alignment.center,
          radius: 1.5,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/images/img/back.png",
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/images/img/info.png",
                        width: 35,
                        height: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        "assets/images/img/network.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 85,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF3B41E7).withOpacity(1),
                          border: Border.all(color: Color(0xFF23B0FF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/images/img/icon.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              " 100",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "PoetsenOne-Regular",
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        "assets/images/img/trophy.png",
                        width: 40,
                        height: 64,
                      ),
                      Container(
                        width: 85,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/img/shape.png"),
                              fit: BoxFit.fitWidth),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "    ₹100",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "PoetsenOne-Regular",
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  BoardWidget(
                    playerCount: playerCount,
                  ),
                ],
              ),
              Consumer<LudoProvider>(
                builder: (context, value, child) => value.winners.length == 3
                    ? Container(
                        color: Colors.black.withOpacity(0.8),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Thank you for playing 😙",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center),
                              Text(
                                  "The Winners is: ${value.winners.map((e) => e.name.toUpperCase()).join(", ")}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 30),
                                  textAlign: TextAlign.center),
                              const Divider(color: Colors.white),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// // To read the player count
// int count = context.watch<GameStateProvider>().playerCount;

// // To update the player count
// context.read<GameStateProvider>().setPlayerCount(newCount);
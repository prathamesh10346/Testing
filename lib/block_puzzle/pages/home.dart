// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'package:allgames/block_puzzle/widgets/boxes.dart';
import 'package:allgames/block_puzzle/widgets/drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'dart:math';

import '../utils/db.dart';
import '../widgets/piece.dart';

//2 * 2 list
List<List<Tetromino?>> gameBoard =
    List.generate(col, (i) => List.generate(row, (i) => null));

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double value = 0;
  int row = 10;
  int col = 15;
  int score = 0;

  int highscore = -1;

  Piece currentPiece = Piece(type: Tetromino.TTT);

  bool over = false;

  //reference the hive box
  final highbox = Hive.box("HighScore_db");
  HighScoreDB db = HighScoreDB();

  @override
  void initState() {
    if (highbox.get("SCOREDB") == null) {
      db.createInitialData();
      highscore = db.score;
    } else {
      db.loadData();
      highscore = db.score;
    }

    super.initState();
    //start game when app starts
    startGame();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void startGame() {
    currentPiece.genPieces();

    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        checkLanding();
        if (gameOver() == true) {
          timer.cancel();
          showGameOver();
        }
        currentPiece.pieceMove(Directions.down);
      });
    });
  }

  void showGameOver() {
    showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 51, 49, 44),
              content: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Game Over",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: Text("Play Again"))
              ],
            ));
  }

  bool collisionDet(Directions direction) {
    for (int i = 0; i < currentPiece.positions.length; i++) {
      int currow = (currentPiece.positions[i] / row).floor();
      int curcol = currentPiece.positions[i] % row;

      if (direction == Directions.left) {
        curcol -= 1;
      } else if (direction == Directions.right) {
        curcol += 1;
      } else if (direction == Directions.down) {
        currow += 1;
      }

      if (currow > 13 || curcol < 0 || curcol >= row) {
        return true;
      }
      if (currow >= 0 && curcol >= 0) {
        if (gameBoard[currow][curcol] != null) {
          return true;
        }
      }
    }
    return false;
  }

  void checkLanding() {
    if (collisionDet(Directions.down)) {
      for (int i = 0; i < currentPiece.positions.length; i++) {
        int currow = (currentPiece.positions[i] / row).floor();
        int curcol = currentPiece.positions[i] % row;
        if (currow >= 0 && curcol >= 0) {
          gameBoard[currow][curcol] = currentPiece.type;
        }
      }
      score += 4;
      newPiece();
    }
  }

  void newPiece() {
    Random rand = Random();
    Tetromino randoType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randoType);
    currentPiece.genPieces();
    if (gameOver() == true) {
      over = true;
    }
  }

  void moveLeft() {
    if (!collisionDet(Directions.left)) {
      setState(() {
        currentPiece.pieceMove(Directions.left);
      });
    }
  }

  void resetGame() {
    setState(() {
      if (score > highscore) {
        highscore = score;
        db.score = score;
      }
    });
    db.updateData();
    gameBoard = List.generate(col, (i) => List.generate(row, (i) => null));
    over = false;
    score = 0;
    newPiece();
    startGame();
  }

  void moveRight() {
    if (!collisionDet(Directions.right)) {
      setState(() {
        currentPiece.pieceMove(Directions.right);
      });
    }
  }

  bool gameOver() {
    for (int i = 0; i < row; i++) {
      if (gameBoard[0][i] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using Stack for two fold animation. dont Add Expand
      body: Stack(
        children: [
          DrawerPage(
            high: highscore,
          ),

          //Menu Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            builder: (_, double val, __) {
              return (Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY(pi / 6 * val),

                //home page begins
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      value == 1 ? value = 0 : value = 0;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFAD7834),
                                Color(0xFFBD814C),
                                Color(0xFFAD7834),
                                Color(0xFFBD814C),
                                Color(0xFFAD7834),
                                Color(0xFFBD814C),
                                Color(0xFFAD7834),
                                Color(0xFFBD814C),
                                Color(0xFFAD7834),
                                Color(0xFFBD814C),
                              ],
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 25),
                                  child: Row(
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       value == 0 ? value = 1 : value = 0;
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //       padding: EdgeInsets.all(10),
                                      //       decoration: BoxDecoration(
                                      //           borderRadius:
                                      //               BorderRadius.circular(10),
                                      //           color: Colors.grey[400]),
                                      //       child: Icon(Icons.menu, size: 25)),
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Image.asset(
                                                  "assets/images/puzzle/back_puzzle.png",
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
                                            "assets/images/puzzle/info_puzzle .png",
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
                                              color: Color(0xFFDCBC95)
                                                  .withOpacity(1),
                                              border: Border.all(
                                                  color: Color(0xFFFFA438)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                      fontFamily:
                                                          "PoetsenOne-Regular",
                                                      fontWeight:
                                                          FontWeight.w700),
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
                                                  image: AssetImage(
                                                      "assets/images/puzzle/shape.png"),
                                                  fit: BoxFit.fitWidth),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "    ₹100",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "PoetsenOne-Regular",
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TimerWidget(), // Use the new TimerWidget here

                                    // Score
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 16),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Color(0xff582A08),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: GradientText(
                                            '$score',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            gradientDirection:
                                                GradientDirection.ttb,
                                            colors: [
                                              Color(0xffFFD66B),
                                              Color(0xffB6870E)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: GradientText(
                                            "Best : $highscore",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            gradientDirection:
                                                GradientDirection.ttb,
                                            colors: [
                                              Color(0xffFFD66B),
                                              Color(0xffB6870E)
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Expanded(
                                  child: GridView.builder(
                                      itemCount: row * col,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: row,
                                      ),
                                      itemBuilder: (context, index) {
                                        int currow = (index / row).floor();
                                        int curcol = index % row;

                                        if (currentPiece.positions
                                            .contains(index)) {
                                          return Boxes(
                                            color: currentPiece.color,
                                          );
                                        } else if (gameBoard[currow][curcol] !=
                                            null) {
                                          final Tetromino? tetType =
                                              gameBoard[currow][curcol];
                                          return Boxes(
                                            color: tetColors[tetType],
                                          );
                                        } else {
                                          return Boxes(
                                            color: Color(0xffFCC470),
                                          );
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: 27,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff582A08),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: IconButton(
                                          onPressed: moveLeft,
                                          icon: Icon(
                                            Icons.arrow_back_rounded,
                                            size: 30,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff582A08),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: IconButton(
                                          onPressed: resetGame,
                                          icon: Icon(
                                            Icons.replay_outlined,
                                            size: 30,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff582A08),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: IconButton(
                                          onPressed: moveRight,
                                          icon: Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 30,
                                          ),
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 27,
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _timeInSeconds = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeInSeconds > 0) {
          _timeInSeconds--;
        } else {
          timer.cancel();
          // Handle time up scenario
          // showTimeUpDialog();
        }
      });
    });
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Time Up!'),
        content: Text('Your time has ended.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _timeInSeconds = 30;
                startTimer();
              });
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xff582A08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/puzzle/clock.png",
            height: 22,
          ),
          SizedBox(width: 5),
          GradientText(
            '${(_timeInSeconds ~/ 60).toString().padLeft(2, '0')}:${(_timeInSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
            gradientDirection: GradientDirection.ttb,
            colors: [Color(0xffFFD66B), Color(0xffB6870E)],
          ),
        ],
      ),
    );
  }
}

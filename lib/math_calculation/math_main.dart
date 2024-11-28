import 'dart:async';

import 'package:allgames/math_calculation/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class Fruit {
  final String icon;
  final int value;
  Fruit({
    required this.icon,
    required this.value,
  });
}

class Operation {
  final String icon;
  final String value;

  Operation({
    required this.icon,
    required this.value,
  });
}

class MyMathHomePage extends StatefulWidget {
  const MyMathHomePage();

  @override
  State<MyMathHomePage> createState() => _MyMathHomePageState();
}

class _MyMathHomePageState extends State<MyMathHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String? result;
  int level = 1;

  int _score = 854;

  @override
  Widget build(BuildContext context) {
    final fruits = generateFruits();
    return Scaffold(
      backgroundColor: Color(0xff035EA0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
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
                  width: 50,
                  height: 65,
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimerWidget(), // Use the new TimerWidget here

                // Score
                Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                color: Color(0xff03375D),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                  child: Column(
                    children: [
                      _buildRow(
                        fruitValues: fruits..shuffle(),
                        operations: asignOperationValues(),
                        isQuestion: false,
                      ),
                      _buildRow(
                        fruitValues: fruits..shuffle(),
                        operations: asignOperationValues(),
                        isQuestion: false,
                      ),
                      _buildRow(
                        fruitValues: fruits..shuffle(),
                        operations: asignOperationValues(),
                        isQuestion: false,
                      ),
                      _buildRow(
                        fruitValues: fruits..shuffle(),
                        operations: asignOperationValues(),
                        isQuestion: false,
                      ),
                      _buildRow(
                        fruitValues: fruits..shuffle(),
                        operations: asignOperationValues(),
                        isQuestion: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildResultInput()
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required List<Fruit> fruitValues,
    required List<Operation> operations,
    bool? isQuestion = false,
  }) {
    Fruit leadFruit = fruitValues[0];
    Fruit midFruit = fruitValues[1];
    Fruit sufixFruit = fruitValues[2];
    Operation leadOperation = operations[0];
    Operation sufixOperation = operations[1];
    if (isQuestion!) {
      result = findResult(
        leadOperation,
        sufixOperation,
        leadFruit,
        midFruit,
        sufixFruit,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(
          leadFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          leadOperation.icon,
          height: 25,
        ),
        SvgPicture.asset(
          midFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          sufixOperation.icon,
          height: 25,
        ),
        SvgPicture.asset(
          sufixFruit.icon,
          height: 45,
        ),
        SvgPicture.asset(
          operationIconsList[2],
          height: 25,
        ),
        Text(
          isQuestion
              ? 'X'
              : findResult(
                  leadOperation,
                  sufixOperation,
                  leadFruit,
                  midFruit,
                  sufixFruit,
                ),
          style: GoogleFonts.play(
              textStyle: const TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          )),
        ),
      ],
    );
  }

  Widget _buildResultInput() {
    return Container(
      width: 250,
      height: 50,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff03375D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ans.',
            style: GoogleFonts.play(
                textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            )),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TextField(
              controller: textEditingController,
              onChanged: (String value) {
                if (value == "2") {
                  setState(() {
                    _score += 10; // Increase score when correct
                  });
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          content:
                              Image.asset('assets/math/gifs/completed.gif'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('Start level ${level + 1}'),
                              onPressed: () {
                                textEditingController.clear();
                                setState(() {
                                  level++;
                                  

                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                }
              },
              cursorColor: Colors.green,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              keyboardType: TextInputType.number,
              style: GoogleFonts.play(
                  textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              )),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  List<Fruit> generateFruits() {
    return fruitIconsList.map(
      (fruit) {
        return Fruit(
          icon: fruit,
          value: Random().nextInt(5),
        );
      },
    ).toList();
  }

  List<Operation> asignOperationValues() {
    List<Operation> operations = [
      Operation(icon: operationIconsList[0], value: '+'),
      Operation(icon: operationIconsList[1], value: '-'),
    ]..shuffle();

    return operations.map(
      (operation) {
        return Operation(
          icon: operation.icon,
          value: operation.value,
        );
      },
    ).toList();
  }

  String findResult(
    Operation leadOperation,
    Operation sufixOperation,
    Fruit leadFruit,
    Fruit midFruit,
    Fruit sufixFruit,
  ) {
    {
      if (leadOperation.value == '+' && sufixOperation.value == '+') {
        return (leadFruit.value + midFruit.value + sufixFruit.value).toString();
      } else if (leadOperation.value == '+' && sufixOperation.value == '-') {
        return (leadFruit.value + midFruit.value - sufixFruit.value).toString();
      } else if (leadOperation.value == '-' && sufixOperation.value == '+') {
        return (leadFruit.value - midFruit.value + sufixFruit.value).toString();
      } else {
        return (leadFruit.value - midFruit.value - sufixFruit.value).toString();
      }
    }
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
          showTimeUpDialog();
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
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.white, size: 20),
          SizedBox(width: 4),
          Text(
            '${(_timeInSeconds ~/ 60).toString().padLeft(2, '0')}:${(_timeInSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

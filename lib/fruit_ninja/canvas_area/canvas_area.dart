import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'models/fruit.dart';
import 'models/fruit_part.dart';
import 'models/touch_slice.dart';
import 'slice_painter.dart';

class CanvasArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasAreaState();
  }
}

class _CanvasAreaState<CanvasArea> extends State {
  int _score = 0;
  int _bestScore = 0;
  bool _gameOver = false;
  TouchSlice? _touchSlice;
  final List<Fruit> _fruits = <Fruit>[];

  final Random _random = Random();

  // New variables for combo system and timer
  int _comboCount = 0;
  DateTime? _lastSliceTime;
  Timer? _gameTimer;
  int _remainingSeconds = 60;
  bool _isComboActive = false;
  String _comboMessage = '';
  double _comboOpacity = 0.0;
  late AudioPlayer _backgroundMusicPlayer;
  late AudioPlayer _sliceSoundPlayer;
  late AudioPlayer _bombSoundPlayer;
  late AudioPlayer _gameOverSoundPlayer;
  late AudioPlayer _gameStartSoundPlayer;
  // Constants for combo system
  static const double COMBO_TIME_WINDOW = 1.0; // seconds
  static const int COMBO_REQUIREMENT = 3;
  static const int COMBO_BONUS = 3;
  final List<FruitPart> _fruitParts = <FruitPart>[];
  final List<String> _fruitTypes = [
    'melon',
    'apple',
    'orange',
    'mango',
    'bomb',
    'banana'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _loadBestScore();
    _startGame();
  }

  Future<void> _initializeAudio() async {
    // Initialize audio players
    _backgroundMusicPlayer = AudioPlayer();
    _sliceSoundPlayer = AudioPlayer();
    _bombSoundPlayer = AudioPlayer();
    _gameOverSoundPlayer = AudioPlayer();
    _gameStartSoundPlayer = AudioPlayer();

    // Load audio assets
    await Future.wait([
      _backgroundMusicPlayer.setAsset('assets/audio/background_music.mp3'),
      _sliceSoundPlayer.setAsset('assets/audio/slice.mp3'),
      _bombSoundPlayer.setAsset('assets/sounds/BombExplosion.mp3'),
      _gameOverSoundPlayer.setAsset('assets/audio/game_over.mp3'),
      _gameStartSoundPlayer.setAsset('assets/audio/game_start.mp3'),
    ]);

    // Set background music to loop
    _backgroundMusicPlayer.setLoopMode(LoopMode.one);
  }

  void _spawnRandomFruit() {
    final fruitType = _fruitTypes[_random.nextInt(_fruitTypes.length)];
    final startFromLeft = _random.nextBool();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final startX = startFromLeft ? -80.0 : screenWidth;
    final startY =
        screenHeight * 0.4 + _random.nextDouble() * (screenHeight * 0.01);
    final forceX = startFromLeft
        ? (5 + _random.nextDouble() * 5)
        : -(5 + _random.nextDouble() * 5);

    _fruits.add(
      Fruit(
        type: fruitType,
        position: Offset(startX, startY),
        width: 80,
        height: 80,
        additionalForce: Offset(
          forceX,
          _random.nextDouble() * -15 - 10,
        ),
        rotation: _random.nextDouble() / 3 - 0.16,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of audio players
    _backgroundMusicPlayer.dispose();
    _sliceSoundPlayer.dispose();
    _bombSoundPlayer.dispose();
    _gameOverSoundPlayer.dispose();
    _gameStartSoundPlayer.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_gameOver) return;

    setState(() {
      for (Fruit fruit in _fruits) {
        fruit.applyGravity();
      }
      for (FruitPart fruitPart in _fruitParts) {
        fruitPart.applyGravity();
      }

      _fruits.removeWhere(
          (fruit) => fruit.position.dy > MediaQuery.of(context).size.height);
      _fruitParts.removeWhere(
          (part) => part.position.dy > MediaQuery.of(context).size.height);

      if (_random.nextDouble() > 0.97) {
        _spawnRandomFruit();
      }
    });

    Future<void>.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: _getStack()));
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = <Widget>[];

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getFruitParts());
    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());
    widgetsOnStack.add(_getScoreDisplay());
    widgetsOnStack.add(_getBestScore());
    widgetsOnStack.add(_getTimer());
    widgetsOnStack.add(_getTopBar());

    if (_isComboActive) {
      widgetsOnStack.add(_getComboDisplay());
    }
    if (_gameOver) {
      widgetsOnStack.add(_getGameOverDisplay());
    }

    return widgetsOnStack;
  }

  Widget _getComboDisplay() {
    return AnimatedOpacity(
      opacity: _comboOpacity,
      duration: Duration(milliseconds: 500),
      child: Center(
        child: Text(
          _comboMessage,
          style: TextStyle(
            fontSize: 48,
            color: Colors.yellow,
            fontFamily: "PoetsenOne-Regular",
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(5.0, 5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGameOverDisplay() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 1.2,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/fruit_ninja/game_over.png',
            ),
          ),
          // color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
            ),
            Text(
              'Game Over',
              style: TextStyle(
                fontSize: 38,
                color: Colors.red,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: "PoetsenOne-Regular",
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: _restartGame,
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 224, 146, 51).withOpacity(1),
                  border: Border.all(color: Color(0xFFFFA438)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: _restartGame,
                  child: Center(
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: "PoetsenOne-Regular",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getFruit(Fruit fruit) {
    String assetPath;
    switch (fruit.type) {
      case 'melon':
        assetPath = 'assets/images/fruit_ninja/water_melon.png';
        break;
      case 'apple':
        assetPath = 'assets/images/fruit_ninja/apple.png';
        break;
      case 'orange':
        assetPath = 'assets/images/fruit_ninja/fruit1.png';
        break;
      case 'mango':
        assetPath = 'assets/images/fruit_ninja/mango.png';
        break;
      case 'banana':
        assetPath = 'assets/images/fruit_ninja/banana.png';
        break;
      case 'bomb':
        assetPath = 'assets/images/fruit_ninja/bomb.png';
        break;
      default:
        assetPath = 'assets/images/fruit_ninja/fruit1.png';
    }

    return Image.asset(
      assetPath,
      height: 100,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getFruitPart(FruitPart fruitPart) {
    String assetPath;
    switch (fruitPart.fruitType) {
      case 'melon':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/water_melon_cut_left.png'
            : 'assets/images/fruit_ninja/water_melon_cut_right.png';
        break;
      case 'apple':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/apple_cut_left.png'
            : 'assets/images/fruit_ninja/apple_cut_right.png';
        break;
      case 'orange':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/fruit1flash.png'
            : 'assets/images/fruit_ninja/fruit1_cut.png';
        break;
      case 'mango':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/mango_cut_left.png'
            : 'assets/images/fruit_ninja/mango_cut_right.png';
        break;
      case 'banana':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/banana_cut_left.png'
            : 'assets/images/fruit_ninja/banana_cut_right.png';
        break;
      case 'bomb':
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/bomb_left.png'
            : 'assets/images/fruit_ninja/bomb_right.png';
        break;
      default:
        assetPath = fruitPart.isLeft
            ? 'assets/images/fruit_ninja/fruit1flash.png'
            : 'assets/images/fruit_ninja/fruit1_cut.png';
    }

    return Transform.rotate(
      angle: fruitPart.rotation * pi * 2,
      child: Image.asset(
        assetPath,
        height: 140,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  List<Widget> _getFruitParts() {
    return _fruitParts
        .map((fruitPart) => Positioned(
              top: fruitPart.position.dy,
              left: fruitPart.position.dx,
              child: _getFruitPart(fruitPart),
            ))
        .toList();
  }

  List<Widget> _getFruits() {
    return _fruits
        .map((fruit) => Positioned(
              top: fruit.position.dy,
              left: fruit.position.dx,
              child: Transform.rotate(
                angle: fruit.rotation * pi * 2,
                child: _getFruit(fruit),
              ),
            ))
        .toList();
  }

  Widget _getScoreDisplay() {
    return Positioned(
      left: 16,
      top: 50,
      child: Row(
        children: [
          Image.asset(
            'assets/images/fruit_ninja/score.png',
            width: 70,
          ),
          GradientText(
            '$_score',
            style: TextStyle(
              fontSize: 24,
              color: Colors.yellow,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w700,
            ),
            gradientType: GradientType.linear,
            gradientDirection:
                GradientDirection.ttb, // Default is left to right
            colors: [Color(0xffFFD66B), Color(0xffFFD66B), Color(0xffB6870E)],
          ),
        ],
      ),
    );
  }

  Widget _getTopBar() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/fruit_ninja/backbutton.png",
                width: 35,
                height: 35,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Image.asset(
              "assets/images/fruit_ninja/info.png",
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 15,
            ),
            Image.asset(
              "assets/images/img/network.png",
              width: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              width: 85,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFFDCBC95).withOpacity(1),
                border: Border.all(color: Color(0xFFFFA438)),
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
      ],
    );
  }

  Container _getBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          stops: <double>[0.2, 1.0],
          colors: <Color>[Color(0xff1A1B50), Color(0xff0D0918)],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage('assets/images/fruit_ninja/ninja_background.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _getSlice() {
    if (_touchSlice == null) {
      return Container();
    }

    return CustomPaint(
      size: Size.infinite,
      painter: SlicePainter(
        pointsList: _touchSlice!.pointsList,
      ),
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        setState(() => _setNewSlice(details));
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(
          () {
            _addPointToSlice(details);
            _checkCollision();
          },
        );
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() => _resetSlice());
      },
    );
  }

  _checkCollision() {
    if (_touchSlice == null) {
      return;
    }

    for (Fruit fruit in List<Fruit>.from(_fruits)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in _touchSlice!.pointsList) {
        if (!firstPointOutside && !fruit.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && fruit.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !fruit.isPointInside(point)) {
          _fruits.remove(fruit);
          _turnFruitIntoParts(fruit);
          _score += 10;
          break;
        }
      }
    }
  }

  void _turnFruitIntoParts(Fruit hit) {
    FruitPart leftFruitPart = FruitPart(
      position: Offset(hit.position.dx - hit.width / 8, hit.position.dy),
      width: hit.width / 2,
      height: hit.height,
      isLeft: true,
      gravitySpeed: hit.gravitySpeed,
      additionalForce:
          Offset(hit.additionalForce.dx - 1, hit.additionalForce.dy - 5),
      rotation: hit.rotation,
      fruitType: hit.type,
    );

    FruitPart rightFruitPart = FruitPart(
      position: Offset(
          hit.position.dx + hit.width / 4 + hit.width / 8, hit.position.dy),
      width: hit.width / 2,
      height: hit.height,
      isLeft: false,
      gravitySpeed: hit.gravitySpeed,
      additionalForce:
          Offset(hit.additionalForce.dx + 1, hit.additionalForce.dy - 5),
      rotation: hit.rotation,
      fruitType: hit.type,
    );

    setState(() {
      _fruitParts.add(leftFruitPart);
      _fruitParts.add(rightFruitPart);
      _fruits.remove(hit);

      if (hit.type == 'bomb') {
        // Play bomb sound
        _bombSoundPlayer.seek(Duration.zero);
        _bombSoundPlayer.play();
        _gameOver = true;
        _gameTimer?.cancel();
        _saveBestScore();
        _onGameOver();
      } else {
        // Play slice sound
        _sliceSoundPlayer.seek(Duration.zero);
        _sliceSoundPlayer.play();
        _score += 10;
        _handleCombo(hit.type);
      }
    });
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestScore = prefs.getInt('bestScore') ?? 0;
    });
  }

  Future<void> _saveBestScore() async {
    if (_score > _bestScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('bestScore', _score);
      setState(() {
        _bestScore = _score;
      });
    }
  }

  void _startGame() {
    _score = 0;
    _gameOver = false;
    _remainingSeconds = 60;
    _comboCount = 0;
    _fruits.clear();
    _fruitParts.clear();

    // Play game start sound and background music
    _gameStartSoundPlayer.seek(Duration.zero);
    _gameStartSoundPlayer.play();
    _backgroundMusicPlayer.seek(Duration.zero);
    _backgroundMusicPlayer.play();

    // Start the game timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _gameOver = true;
          timer.cancel();
          _saveBestScore();
          _onGameOver();
        }
      });
    });

    _tick();
  }

  void _onGameOver() {
    // Stop background music and play game over sound
    _backgroundMusicPlayer.stop();
    _gameOverSoundPlayer.seek(Duration.zero);
    _gameOverSoundPlayer.play();
  }

  void _handleCombo(String fruitType) {
    if (fruitType == 'bomb') return;

    final now = DateTime.now();
    if (_lastSliceTime != null) {
      final difference = now.difference(_lastSliceTime!).inMilliseconds / 1000;

      if (difference <= COMBO_TIME_WINDOW) {
        _comboCount++;

        if (_comboCount >= COMBO_REQUIREMENT) {
          setState(() {
            _score += COMBO_BONUS;
            _isComboActive = true;
            _comboMessage = '+$COMBO_BONUS COMBO!';
            _comboOpacity = 1.0;
          });

          // Fade out combo message
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _comboOpacity = 0.0;
            });
          });

          _comboCount = 0;
        }
      } else {
        _comboCount = 1;
      }
    } else {
      _comboCount = 1;
    }
    _lastSliceTime = now;
  }

  Widget _getTimer() {
    return Positioned(
      right: 16,
      top: 70,
      child: Row(
        children: [
          GradientText(
            '$_remainingSeconds',
            style: TextStyle(
              fontSize: 25,
              color: Colors.yellow,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w700,
            ),
            gradientType: GradientType.linear,
            gradientDirection:
                GradientDirection.ttb, // Default is left to right
            colors: [Color(0xffFFD66B), Color(0xffFFD66B), Color(0xffB6870E)],
          ),
        ],
      ),
    );
  }

  Widget _getBestScore() {
    return Positioned(
      left: 16,
      top: 105,
      child: Row(
        children: [
          GradientText(
            'Best : $_bestScore',
            style: TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w700,
            ),
            gradientType: GradientType.linear,
            gradientDirection:
                GradientDirection.ttb, // Default is left to right
            colors: [
              Color(0xffFFD66B).withOpacity(0.8),
              Color(0xffFFD66B).withOpacity(0.8),
              Color(0xffB6870E).withOpacity(0.8)
            ],
          ),
        ],
      ),
    );
  }

  // Update the _restartGame method
  void _restartGame() {
    setState(() {
      _startGame();
    });
  }

  void _resetSlice() {
    _touchSlice = null;
  }

  void _setNewSlice(details) {
    _touchSlice = TouchSlice(pointsList: <Offset>[details.localFocalPoint]);
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (_touchSlice?.pointsList == null || _touchSlice!.pointsList.isEmpty) {
      return;
    }

    if (_touchSlice!.pointsList.length > 16) {
      _touchSlice!.pointsList.removeAt(0);
    }
    _touchSlice!.pointsList.add(details.localFocalPoint);
  }
}

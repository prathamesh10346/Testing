import 'package:allgames/carrom/carrom_home_screen.dart';
import 'package:allgames/carrom/paint_board.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

enum CoinType { black, white, queen }

enum GameMode { twoPlayer, fourPlayer }

enum PlayerPosition { bottom, top, left, right }

const double RESTITUTION = 0.8;
const double FRICTION = 0.98;
const double MINIMUM_VELOCITY = 0.1;
const double COLLISION_DAMPING = 0.8;

const double BOARD_SIZE = 300.0;
const double PLAYABLE_AREA = BOARD_SIZE - 80.0;

class GameModeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const GameModeButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.white54,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}

extension OffsetExtension on Offset {
  Offset normalize() {
    double length = distance;
    if (length == 0) return Offset.zero;
    return this / length;
  }
}

class CarromBoard extends StatefulWidget {
  final GameMode gameMode;

  const CarromBoard({Key? key, required this.gameMode}) : super(key: key);
  @override
  _CarromBoardState createState() => _CarromBoardState();
}

class Coin {
  Offset position;
  final double radius;
  final Color color;
  final CoinType type;
  Offset velocity = Offset.zero;

  Coin({
    required this.position,
    required this.radius,
    required this.color,
    required this.type,
  });

  void update() {
    // Apply velocity
    position += velocity;

    // Apply friction
    velocity *= FRICTION;

    // Stop if velocity is very small
    if (velocity.distance < MINIMUM_VELOCITY) {
      velocity = Offset.zero;
    }
  }
}

class Striker {
  Offset position;
  final double radius;
  double angle = 0;
  double power = 0;
  Offset velocity = Offset.zero;
  bool isMoving = false;
  double basePositionY;
  double sliderPosition = 0.5;
  bool isVertical;

  Striker({
    required this.position,
    required this.radius,
    required this.basePositionY,
    this.isVertical = false,
  });

  void updatePositionFromSlider() {
    double margin = 50.0;
    double availableLength = BOARD_SIZE - 2 * margin;

    if (!isVertical) {
      position = Offset(
        margin + (availableLength * sliderPosition),
        basePositionY,
      );
    } else {
      position = Offset(
        basePositionY,
        margin + (availableLength * sliderPosition),
      );
    }
  }

  void update() {
    if (isMoving) {
      position += velocity;
      velocity *= FRICTION;

      if (velocity.distance < MINIMUM_VELOCITY) {
        velocity = Offset.zero;
        isMoving = false;
      }
    }
  }

  void shoot(double angle, double power) {
    final AudioPlayer _audioPlayer = AudioPlayer();

    velocity = Offset(
      cos(angle) * power,
      sin(angle) * power,
    );
    isMoving = true;
    _audioPlayer.play(AssetSource('sounds/carrom/striker_shoot.mp3'));
  }
}

class _CarromBoardState extends State<CarromBoard>
    with TickerProviderStateMixin {
  late Striker striker;
  List<Coin> coins = [];
  late AnimationController _animationController;
  Offset? dragStart;
  bool isAiming = false;
  int player1Score = 0;
  int player2Score = 0;
  bool isPlayer1Turn = true;
  bool queenCaptured = false;
  bool needsCoverShot = false;
  bool hasValidPocket = false; // Tracks if player pocketed their coin correctly
  bool strikerFoul = false; // Tracks if striker went into pocket
  bool queenCovered = false; // Tracks if queen was covered after pocketing
  bool queenClaimed = false;
  PlayerPosition? queenClaimedBy;
  int coverShotsNeeded = 0;
  int currentCoverShots = 0;
  bool isQueenOffBoard = false;
  bool waitingForCoverShot = false;
  // Updated to support multiple players
  Map<PlayerPosition, int> playerScores = {
    PlayerPosition.bottom: 0,
    PlayerPosition.top: 0,
    PlayerPosition.left: 0,
    PlayerPosition.right: 0,
  };

  PlayerPosition currentPlayerTurn = PlayerPosition.bottom;

  @override
  void initState() {
    super.initState();
    striker = _createStrikerForCurrentPlayer();
    initializeCoins();
    striker.basePositionY = BOARD_SIZE * 0.87;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
        if (mounted) {
          updatePhysics();
          setState(() {});
        }
      });
    _animationController.repeat();
  }

  Striker _createStrikerForCurrentPlayer() {
    switch (currentPlayerTurn) {
      case PlayerPosition.bottom:
        return Striker(
          position: Offset(BOARD_SIZE / 2, BOARD_SIZE * 0.87),
          radius: 10,
          basePositionY: BOARD_SIZE * 0.87,
        );
      case PlayerPosition.top:
        return Striker(
          position: Offset(BOARD_SIZE / 2, BOARD_SIZE * 0.14),
          radius: 10,
          basePositionY: BOARD_SIZE * 0.14,
        );
      case PlayerPosition.left:
        return Striker(
          position: Offset(BOARD_SIZE * 0.14, BOARD_SIZE / 2),
          radius: 10,
          basePositionY: BOARD_SIZE * 0.14,
          isVertical: true,
        );
      case PlayerPosition.right:
        return Striker(
          position: Offset(BOARD_SIZE * 0.87, BOARD_SIZE / 2),
          radius: 10,
          basePositionY: BOARD_SIZE * 0.87,
          isVertical: true,
        );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    _audioPlayer.dispose();

    super.dispose();
  }

  void initializeCoins() {
    coins.clear();
    double centerX = BOARD_SIZE / 2;
    double centerY = BOARD_SIZE / 2;
    double spacing = 20.0;

    // Add queen at center
    coins.add(Coin(
      position: Offset(centerX, centerY),
      radius: 8,
      color: Colors.red,
      type: CoinType.queen,
    ));

    // Add white coins in a diamond pattern
    final coinOffsets = widget.gameMode == GameMode.fourPlayer
        ? [
            // White coins in diagonal
            Offset(-spacing, -spacing),
            Offset(spacing, -spacing),
            Offset(-spacing, spacing),
            Offset(spacing, spacing),
            // Black coins in cross
            Offset(-spacing, 0),
            Offset(spacing, 0),
            Offset(0, -spacing),
            Offset(0, spacing),
          ]
        : [
            // Existing 2-player coin placement
            Offset(-spacing, -spacing),
            Offset(spacing, -spacing),
            Offset(-spacing, spacing),
            Offset(spacing, spacing),
            Offset(-spacing, 0),
            Offset(spacing, 0),
            Offset(0, -spacing),
            Offset(0, spacing),
          ];

    for (var offset in coinOffsets) {
      coins.add(Coin(
        position: Offset(centerX + offset.dx, centerY + offset.dy),
        radius: 8,
        color:
            coinOffsets.indexOf(offset) % 2 == 0 ? Colors.white : Colors.black,
        type: coinOffsets.indexOf(offset) % 2 == 0
            ? CoinType.white
            : CoinType.black,
      ));
    }
  }

  void _switchToNextPlayer() {
    // Correct order for 4-player mode: bottom -> right -> top -> left
    final players = widget.gameMode == GameMode.fourPlayer
        ? [
            PlayerPosition.bottom,
            PlayerPosition.right,
            PlayerPosition.top,
            PlayerPosition.left
          ]
        : [PlayerPosition.bottom, PlayerPosition.top];

    // Find current player index
    int currentIndex = players.indexOf(currentPlayerTurn);

    // Move to next player
    currentPlayerTurn = players[(currentIndex + 1) % players.length];

    // Reset striker for new player
    striker = _createStrikerForCurrentPlayer();

    // Reset aiming and movement states
    isAiming = false;
    dragStart = null;
  }

  void updatePhysics() {
    if (!striker.isMoving &&
        coins.every((coin) => coin.velocity == Offset.zero)) {
      return;
    }

    // Update positions
    striker.update();
    for (var coin in coins) {
      coin.update();
    }

    // Check collisions
    checkCollisions();

    // Check pocket hits
    checkPocketHits();

    // Check board boundaries
    checkBoundaries();
  }

  void checkCollisions() {
    // Striker with coins
    for (var coin in coins) {
      double distance = (striker.position - coin.position).distance;
      double minDistance = striker.radius + coin.radius;

      if (distance <= minDistance) {
        handleCollision(striker, coin);
      }
    }

    // Coins with other coins
    for (int i = 0; i < coins.length; i++) {
      for (int j = i + 1; j < coins.length; j++) {
        double distance = (coins[i].position - coins[j].position).distance;
        double minDistance = coins[i].radius + coins[j].radius;

        if (distance <= minDistance) {
          handleCollision(coins[i], coins[j]);
        }
      }
    }
  }

  bool checkCollision(Offset pos1, double rad1, Offset pos2, double rad2) {
    return (pos1 - pos2).distance <= (rad1 + rad2);
  }

  void handleCollision(dynamic obj1, dynamic obj2) {
    // Calculate the distance vector between objects
    if (obj1 is Striker || obj2 is Striker) {
      playStrikerHitSound();
    } else {
      playCoinCollisionSound();
    }
    Offset distanceVector = obj2.position - obj1.position;
    double distance = distanceVector.distance;

    // Skip if objects are not actually colliding
    if (distance > (obj1.radius + obj2.radius)) return;

    // Calculate normalized collision normal
    Offset normal = distanceVector.normalize();

    // Calculate relative velocity
    Offset relativeVelocity = obj2.velocity - obj1.velocity;

    // Calculate velocity along the normal
    double velocityAlongNormal =
        relativeVelocity.dx * normal.dx + relativeVelocity.dy * normal.dy;

    // Don't resolve if objects are moving apart
    if (velocityAlongNormal > 0) return;

    // Calculate restitution (bounciness)
    double restitution = COLLISION_DAMPING;

    // Calculate impulse scalar
    double j = -(1 + restitution) * velocityAlongNormal;
    double totalMass = 2; // Assuming equal mass for all objects
    j = j / totalMass;

    // Apply impulse
    Offset impulse = normal * j;
    obj1.velocity -= impulse;
    obj2.velocity += impulse;

    // Prevent objects from sticking together by separating them
    double overlap = (obj1.radius + obj2.radius) - distance;
    if (overlap > 0) {
      Offset separation = normal * (overlap / 2);
      obj1.position -= separation;
      obj2.position += separation;
    }
  }

  void checkPocketHits() {
    final pocketPositions = [
      const Offset(0, 0),
      const Offset(BOARD_SIZE, 0),
      const Offset(0, BOARD_SIZE),
      const Offset(BOARD_SIZE, BOARD_SIZE),
    ];
    final pocketRadius = 18.0;

    // Check if striker went into pocket
    for (var pocket in pocketPositions) {
      if ((striker.position - pocket).distance < pocketRadius) {
        // Handle striker foul directly here instead of passing to handlePocketedCoin
        strikerFoul = true;
        playerScores[currentPlayerTurn] =
            (playerScores[currentPlayerTurn] ?? 0) - 1;
        resetStriker();
        _switchToNextPlayer();
        return;
      }
    }

    // Check coins going into pockets
    coins.removeWhere((coin) {
      for (var pocket in pocketPositions) {
        double distanceToPocket = (coin.position - pocket).distance;
        double overlapPercentage =
            1 - (distanceToPocket / (pocketRadius + coin.radius));

        if (overlapPercentage > 0.2) {
          Offset toPocket = pocket - coin.position;
          double movementTowardsPocket =
              coin.velocity.dx * toPocket.dx + coin.velocity.dy * toPocket.dy;

          if (overlapPercentage > 0.8 || movementTowardsPocket > 0) {
            handlePocketedCoin(coin);
            return true;
          }
        }
      }
      return false;
    });

    // Check if turn should end
    if (!striker.isMoving &&
        coins.every((coin) => coin.velocity == Offset.zero)) {
      handleTurnEnd();
    }
  }

  void handlePocketedCoin(Coin coin) {
    playPocketSound();
    if (coin.type == CoinType.queen) {
      if (!queenClaimed) {
        queenClaimed = true;
        queenClaimedBy = currentPlayerTurn;
        coverShotsNeeded = 1; // Need one successful cover shot after queen
        needsCoverShot = true;
        // Don't switch turns - give player chance for cover shot
        return;
      }
    }

    // For regular coins
    bool isCorrectColor = isCorrectColorForPlayer(coin.type, currentPlayerTurn);

    if (isCorrectColor) {
      playerScores[currentPlayerTurn] =
          (playerScores[currentPlayerTurn] ?? 0) + 1;

      if (needsCoverShot && queenClaimedBy == currentPlayerTurn) {
        currentCoverShots++;
        if (currentCoverShots >= coverShotsNeeded) {
          // Cover shot successful - award queen points
          playerScores[currentPlayerTurn] =
              (playerScores[currentPlayerTurn] ?? 0) + 3;
          needsCoverShot = false;
          queenClaimed = false;
          queenClaimedBy = null;
          currentCoverShots = 0;
          queenCovered = true;
        }
      }
      hasValidPocket = true;
    } else {
      // Wrong color pocketed
      playerScores[currentPlayerTurn] =
          (playerScores[currentPlayerTurn] ?? 0) - 1;

      if (needsCoverShot && queenClaimedBy == currentPlayerTurn) {
        // Failed cover shot - return queen to board and reset queen status
        returnQueenToBoard();
        needsCoverShot = false;
        queenClaimed = false;
        queenClaimedBy = null;
        currentCoverShots = 0;
      }
      _switchToNextPlayer();
    }
  }

  void returnQueenToBoard() {
    // Return queen to center if it's not already on board
    if (coins.every((coin) => coin.type != CoinType.queen)) {
      coins.add(Coin(
        position: Offset(BOARD_SIZE / 2, BOARD_SIZE / 2),
        radius: 8,
        color: Colors.red,
        type: CoinType.queen,
      ));
    }
  }

  String getPlayerName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.bottom:
        return "Player 1 ";
      case PlayerPosition.top:
        return "Player 2 ";
      case PlayerPosition.left:
        return "Player 3 ";
      case PlayerPosition.right:
        return "Player 4 ";
    }
  }

  bool isCorrectColorForPlayer(CoinType coinType, PlayerPosition player) {
    switch (player) {
      case PlayerPosition.bottom:
        return coinType == CoinType.white;
      case PlayerPosition.top:
        return coinType == CoinType.black;
      case PlayerPosition.left:
        return widget.gameMode == GameMode.fourPlayer
            ? coinType == CoinType.white
            : false;
      case PlayerPosition.right:
        return widget.gameMode == GameMode.fourPlayer
            ? coinType == CoinType.black
            : false;
    }
  }

  void _checkGameEnd() {
    // Different winning conditions for 2-player and 4-player modes
    if (widget.gameMode == GameMode.twoPlayer) {
      // Win conditions for 2-player mode:
      // 1. First to get 9 pieces (including queen) wins
      // 2. If all pieces are pocketed, highest score wins

      int player1Score = playerScores[PlayerPosition.bottom] ?? 0;
      int player2Score = playerScores[PlayerPosition.top] ?? 0;

      if (player1Score >= 9 || player2Score >= 9 || coins.isEmpty) {
        _endGame();
      }
    } else {
      // 4-player mode
      // Win conditions:
      // 1. First to get 6 pieces (including queen) wins
      // 2. If all pieces are pocketed, highest score wins

      bool someoneWon = playerScores.values.any((score) => score >= 6);
      if (someoneWon || coins.isEmpty) {
        _endGame();
      }
    }
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> playCoinCollisionSound() async {
    await _audioPlayer.play(AssetSource('sounds/carrom/coin_collision.mp3'));
  }

  Future<void> playStrikerHitSound() async {
    await _audioPlayer.play(AssetSource('sounds/carrom/striker_hit.mp3'));
  }

  Future<void> playPocketSound() async {
    await _audioPlayer.play(AssetSource('sounds/carrom/pocket_sound.mp3'));
  }

  void _endGame() {
    PlayerPosition winner = PlayerPosition.bottom;
    int highestScore = -1;

    playerScores.forEach((player, score) {
      if (score > highestScore) {
        highestScore = score;
        winner = player;
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Winner: ${getPlayerName(winner)}'),
              Text('Score: $highestScore'),
              // Show all players' scores
              ...playerScores.entries.map((entry) =>
                  Text('${getPlayerName(entry.key)}: ${entry.value}')),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Return to menu
              },
            ),
          ],
        );
      },
    );
  }

  void handleTurnEnd() {
    // Check if all coins are stationary
    if (coins.every((coin) => coin.velocity == Offset.zero) &&
        !striker.isMoving) {
      // Handle queen capture logic
      if (needsCoverShot) {
        if (!hasValidPocket) {
          // Failed to cover the queen - return it to board
          needsCoverShot = false;
          queenCaptured = false;
          queenCovered = false;

          // Return queen to center of board
          coins.add(Coin(
            position: Offset(BOARD_SIZE / 2, BOARD_SIZE / 2),
            radius: 8,
            color: Colors.red,
            type: CoinType.queen,
          ));

          _switchToNextPlayer();
        } else {
          // Successfully covered the queen
          playerScores[currentPlayerTurn] =
              (playerScores[currentPlayerTurn] ?? 0) + 3;
          needsCoverShot = false;
          queenCovered = true;
        }
      } else if (!hasValidPocket && !strikerFoul) {
        // No valid pockets and no fouls - switch turns
        _switchToNextPlayer();
      }

      // Reset turn status
      hasValidPocket = false;
      strikerFoul = false;
    }
  }

  void resetStriker() {
    striker.isMoving = false;
    striker.velocity = Offset.zero;
    striker.basePositionY =
        isPlayer1Turn ? BOARD_SIZE * 0.87 : BOARD_SIZE * 0.14;
    striker.updatePositionFromSlider();
  }

  void checkBoundaries() {
    void bounceObject(dynamic obj) {
      double margin = 0.0;

      // Left boundary check
      if (obj.position.dx - obj.radius < margin) {
        obj.velocity =
            Offset(-obj.velocity.dx * COLLISION_DAMPING, obj.velocity.dy);
        obj.position = Offset(margin + obj.radius, obj.position.dy);
      }

      // Right boundary check
      if (obj.position.dx + obj.radius > BOARD_SIZE - margin) {
        obj.velocity =
            Offset(-obj.velocity.dx * COLLISION_DAMPING, obj.velocity.dy);
        obj.position =
            Offset(BOARD_SIZE - margin - obj.radius, obj.position.dy);
      }

      // Top boundary check
      if (obj.position.dy - obj.radius < margin) {
        obj.velocity =
            Offset(obj.velocity.dx, -obj.velocity.dy * COLLISION_DAMPING);
        obj.position = Offset(obj.position.dx, margin + obj.radius);
      }

      // Bottom boundary check
      if (obj.position.dy + obj.radius > BOARD_SIZE - margin) {
        obj.velocity =
            Offset(obj.velocity.dx, -obj.velocity.dy * COLLISION_DAMPING);
        obj.position =
            Offset(obj.position.dx, BOARD_SIZE - margin - obj.radius);
      }
    }

    bounceObject(striker);
    for (var coin in coins) {
      bounceObject(coin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xffF8C0C0), Color(0xffF8C0C0), Color(0xff890015)],
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/carrom/carron_blur_BG.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            topHeader(),
            const SizedBox(height: 25),
            _buildScoreBoard(
              widget.gameMode == GameMode.fourPlayer,
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onPanStart: (details) {
                      if (!striker.isMoving) {
                        dragStart = details.localPosition;
                        isAiming = true;
                      }
                    },
                    onPanUpdate: (details) {
                      if (isAiming) {
                        setState(() {
                          striker.angle =
                              (details.localPosition - dragStart!).direction;
                          striker.power = (details.localPosition - dragStart!)
                              .distance
                              .clamp(0, 50);
                        });
                      }
                    },
                    onPanEnd: (details) {
                      if (isAiming) {
                        striker.shoot(striker.angle, striker.power / 5);
                        isAiming = false;
                      }
                    },
                    child: Container(
                      width: 380,
                      height: 380,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/carrom/carromBoard.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: CustomPaint(
                        painter: CarromBoardPainter(
                          striker,
                          coins,
                          isAiming,
                          striker.angle,
                          striker.power,
                          isPlayer1Turn,
                        ),
                      ),
                    ),
                  ),
                  if (!striker.isMoving)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: BOARD_SIZE - 80,
                        height: 20,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Decorative background
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE6D5B8), // Light wooden color
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),

                            // // Center decoration

                            // Custom Slider
                            SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: Colors.transparent,
                                inactiveTrackColor: Colors.transparent,
                                thumbColor: Colors.orange.withOpacity(0.8),
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12,
                                  elevation: 4,
                                ),
                                overlayColor: Colors.white.withOpacity(0.2),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 20),
                                trackHeight: 4.0,
                              ),
                              child: Slider(
                                value: striker.sliderPosition,
                                onChanged: (value) {
                                  setState(() {
                                    striker.sliderPosition = value;
                                    striker.updatePositionFromSlider();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerProfile({
    required String name,
    required String score,
    required Color borderColor,
    required String profileImage,
    required bool isMe,
    required String color,
  }) {
    // Get player's coin color
    String coinColor = color.contains("White") ? "White" : "Black";
    bool isCurrentTurn = currentPlayerTurn == _getPositionFromName(name);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: isCurrentTurn ? Colors.green : Colors.red,
              width: isCurrentTurn ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                profileImage,
                height: 30,
                width: 30,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "PoetsenOne-Regular",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: coinColor == "White" ? Colors.white : Colors.black,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    score,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (queenClaimedBy == _getPositionFromName(name) &&
                  needsCoverShot)
                Text(
                  "Need cover shot!",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  PlayerPosition _getPositionFromName(String name) {
    if (name.contains("Player 1")) return PlayerPosition.bottom;
    if (name.contains("Player 2")) return PlayerPosition.top;
    if (name.contains("Player 3")) return PlayerPosition.left;
    return PlayerPosition.right;
  }

  Widget _buildScoreBoard(bool isFourPlayer) {
    if (!isFourPlayer) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPlayerProfile(
                name: "Player 1",
                score: "${playerScores[PlayerPosition.bottom]}",
                borderColor: Colors.blue,
                profileImage: "assets/images/home/profile.png",
                isMe: true,
                color: "White"),
            _buildPlayerProfile(
                name: "Player 2",
                score: "${playerScores[PlayerPosition.top]}",
                borderColor: Colors.red,
                profileImage: "assets/images/home/profile.png",
                isMe: false,
                color: "Black"),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlayerProfile(
                    name: "Player 1",
                    score: "${playerScores[PlayerPosition.bottom]}",
                    borderColor: Colors.blue,
                    profileImage: "assets/images/home/profile.png",
                    isMe: true,
                    color: "White"),
                _buildPlayerProfile(
                    name: "Player 2",
                    score: "${playerScores[PlayerPosition.top]}",
                    borderColor: Colors.red,
                    profileImage: "assets/images/home/profile.png",
                    isMe: false,
                    color: "Black"),
                _buildPlayerProfile(
                    name: "Player 3",
                    score: "${playerScores[PlayerPosition.left]}",
                    borderColor: Colors.blue,
                    profileImage: "assets/images/home/profile.png",
                    isMe: false,
                    color: "White"),
                _buildPlayerProfile(
                    name: "Player 4",
                    score: "${playerScores[PlayerPosition.right]}",
                    borderColor: Colors.red,
                    profileImage: "assets/images/home/profile.png",
                    isMe: false,
                    color: "Black"),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class topHeader extends StatelessWidget {
  const topHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/images/carrom/back_carrom.png",
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
          "assets/images/carrom/info_carrom.png",
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
                    color: Colors.black,
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
    );
  }
}

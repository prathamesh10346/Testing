import 'package:flutter/material.dart';
import 'package:allgames/ludo/constants.dart';
import 'package:allgames/ludo/ludo_provider.dart';
import 'package:allgames/ludo/widgets/pawn_widget.dart';
import 'package:allgames/ludo/widgets/dice_widget.dart';
import 'package:provider/provider.dart';

class BoardWidget extends StatefulWidget {
  final int playerCount;

  const BoardWidget({super.key, required this.playerCount});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  LudoPlayerType? _selectedMessagePlayer;
  double ludoBoard(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 500) {
      return 500;
    } else {
      if (width < 300) {
        return 300;
      } else {
        return width - 20;
      }
    }
  }

  double boxStepSize(BuildContext context) {
    return ludoBoard(context) / 15;
  }

  bool shouldShowPlayer(LudoPlayerType type) {
    switch (widget.playerCount) {
      case 2:
        return type == LudoPlayerType.green || type == LudoPlayerType.blue;
      case 3:
        return type == LudoPlayerType.green ||
            type == LudoPlayerType.yellow ||
            type == LudoPlayerType.blue;
      case 4:
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LudoProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (shouldShowPlayer(LudoPlayerType.green))
                  _buildDice(context, value, LudoPlayerType.green, false)
                else
                  SizedBox(width: 20),
                if (shouldShowPlayer(LudoPlayerType.yellow))
                  _buildDice(context, value, LudoPlayerType.yellow, true),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAlias,
              width: ludoBoard(context),
              height: ludoBoard(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                image: const DecorationImage(
                  image: AssetImage("assets/images/board.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.center,
                children: [
                  ..._createPawnWidgets(context, value),
                  ...winners(context, value.winners),
                  ..._createPlayerPhotos(context, value),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (shouldShowPlayer(LudoPlayerType.red))
                  _buildDice(context, value, LudoPlayerType.red, false)
                else
                  SizedBox(width: 20),
                if (shouldShowPlayer(LudoPlayerType.blue))
                  _buildDice(context, value, LudoPlayerType.blue, true),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDice(BuildContext context, LudoProvider provider,
      LudoPlayerType playerType, bool align) {
    String? playerMessage = provider.getMessageForPlayer(playerType);

    return Column(
      children: [
        if (playerMessage != null && playerMessage != '')
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              playerMessage ?? '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        GestureDetector(
          onLongPress: () {
            _showMessageDialog(context, provider);
          },
          child: Row(
            children: [
              // Alignment-based side information (left or right)
              _buildSideInfo(align, playerType),

              // Dice Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: boxStepSize(context) * 2.4,
                height: boxStepSize(context) * 2.4,
                margin: const EdgeInsets.all(20),
                padding: EdgeInsets.all(boxStepSize(context) * 0.2),
                decoration: BoxDecoration(
                  color: playerType == provider.currentPlayer.type
                      ? const Color(0xff3B41E7)
                      : const Color(0xff14295E),
                  border: Border.all(
                    width: 2,
                    color: playerType == provider.currentPlayer.type
                        ? const Color(0xffFFE602)
                        : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: playerType == provider.currentPlayer.type
                      ? [
                          BoxShadow(
                            color: const Color(0xffFFE602).withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          )
                        ]
                      : [],
                ),
                child: Opacity(
                  opacity: playerType == provider.currentPlayer.type ? 1 : 0.5,
                  child: DiceWidget(
                    playerType: playerType,
                    name: "Dice1",
                    amount: 100,
                    isActive: playerType == provider.currentPlayer.type,
                  ),
                ),
              ),

              // Alignment-based side information (opposite side)
              _buildSideInfo(!align, playerType),
            ],
          ),
        ),
      ],
    );
  }

// Helper method to build side information
  Widget _buildSideInfo(bool show, LudoPlayerType playerType) {
    if (!show) return const SizedBox.shrink();

    return Column(
      mainAxisAlignment:
          playerType == LudoPlayerType.green || playerType == LudoPlayerType.red
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      crossAxisAlignment: playerType == LudoPlayerType.green ||
              playerType == LudoPlayerType.yellow
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.end,
      children: [
        Text(
          "Dice1",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "PoetsenOne-Regular",
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Image.asset(
              "assets/images/img/groupicon.png",
              width: 23,
              height: 23,
            ),
            const SizedBox(width: 5),
            Text(
              "100",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

// In _showMessageDialog method
  void _showMessageDialog(BuildContext context, LudoProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff14295E),
        title:
            const Text('Send a Message', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3B41E7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                provider.sendPredefinedMessage('greeting');
                Navigator.of(context).pop();
              },
              child:
                  const Text('Greeting', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3B41E7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                provider.sendPredefinedMessage('encouragement');
                Navigator.of(context).pop();
              },
              child: const Text('Encouragement',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3B41E7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                provider.sendPredefinedMessage('taunt');
                Navigator.of(context).pop();
              },
              child: const Text('Taunt', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _createPawnWidgets(BuildContext context, LudoProvider value) {
    Map<String, List<PawnWidget>> pawnsRaw = {};
    for (var player in value.players) {
      for (var pawn in player.pawns) {
        if (pawn.step > -1) {
          String step = player.path[pawn.step].toString();
          pawnsRaw.putIfAbsent(step, () => []).add(pawn);
        } else {
          pawnsRaw.putIfAbsent("home", () => []).add(pawn);
        }
      }
    }

    List<Widget> widgets = [];
    pawnsRaw.forEach((key, pawns) {
      if (key == "home") {
        widgets.addAll(_createHomePawns(context, pawns, value));
      } else {
        widgets.addAll(_createPathPawns(context, key, pawns));
      }
    });

    return widgets;
  }

  List<Widget> _createHomePawns(
      BuildContext context, List<PawnWidget> pawns, LudoProvider value) {
    return pawns.map((e) {
      var player =
          value.players.firstWhere((element) => element.type == e.type);
      return AnimatedPositioned(
        key: ValueKey("${e.type.name}_${e.index}"),
        left: LudoPath.stepBox(ludoBoard(context), player.homePath[e.index][0]),
        top: LudoPath.stepBox(ludoBoard(context), player.homePath[e.index][1]),
        width: boxStepSize(context),
        height: boxStepSize(context),
        duration: const Duration(milliseconds: 200),
        child: e,
      );
    }).toList();
  }

  List<Widget> _createPathPawns(
      BuildContext context, String key, List<PawnWidget> pawns) {
    List<double> coordinates = key
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(",")
        .map((e) => double.parse(e.trim()))
        .toList();

    return List.generate(
      pawns.length,
      (index) {
        var e = pawns[index];
        return AnimatedPositioned(
          key: ValueKey("${e.type.name}_${e.index}"),
          duration: const Duration(milliseconds: 200),
          left: LudoPath.stepBox(ludoBoard(context), coordinates[0]) +
              (index * 3),
          top: LudoPath.stepBox(ludoBoard(context), coordinates[1]),
          width: boxStepSize(context) - 5,
          height: boxStepSize(context),
          child: pawns[index],
        );
      },
    );
  }

  List<Widget> winners(BuildContext context, List<LudoPlayerType> winners) =>
      List.generate(
        winners.length,
        (index) {
          Widget crownImage = Image.asset("assets/images/crown/1st.png");

          int x = 0;
          int y = 0;

          if (index == 0) {
            crownImage =
                Image.asset("assets/images/crown/1st.png", fit: BoxFit.cover);
          } else if (index == 1) {
            crownImage =
                Image.asset("assets/images/crown/2nd.png", fit: BoxFit.cover);
          } else if (index == 2) {
            crownImage =
                Image.asset("assets/images/crown/3rd.png", fit: BoxFit.cover);
          } else {
            return Container();
          }

          switch (winners[index]) {
            case LudoPlayerType.green:
              x = 0;
              y = 0;
              break;
            case LudoPlayerType.yellow:
              x = 1;
              y = 0;
              break;
            case LudoPlayerType.blue:
              x = 1;
              y = 1;
              break;
            case LudoPlayerType.red:
              x = 0;
              y = 1;
              break;
          }
          return Positioned(
            top: y == 0 ? 0 : null,
            left: x == 0 ? 0 : null,
            right: x == 1 ? 0 : null,
            bottom: y == 1 ? 0 : null,
            width: ludoBoard(context) * .4,
            height: ludoBoard(context) * .4,
            child: Padding(
              padding: EdgeInsets.all(boxStepSize(context)),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: crownImage,
              ),
            ),
          );
        },
      );

  List<Widget> _createPlayerPhotos(BuildContext context, LudoProvider value) {
    final double photoSize = ludoBoard(context) * 0.1;
    final List<Map<String, dynamic>> playerPositions = [
      {'type': LudoPlayerType.green, 'x': 0, 'y': 0},
      {'type': LudoPlayerType.yellow, 'x': 1, 'y': 0},
      {'type': LudoPlayerType.blue, 'x': 1, 'y': 1},
      {'type': LudoPlayerType.red, 'x': 0, 'y': 1},
    ]
        .where((player) => shouldShowPlayer(player['type'] as LudoPlayerType))
        .toList();

    return playerPositions.map((player) {
      return Positioned(
        top: player['y'] == 0 ? 57 : null,
        left: player['x'] == 0 ? 57 : null,
        right: player['x'] == 1 ? 57 : null,
        bottom: player['y'] == 1 ? 57 : null,
        child: Container(
          width: photoSize,
          height: photoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getPlayerColor(player['type']),
              width: 3,
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(_getPlayerPhotoAsset(player['type'])),
            ),
          ),
        ),
      );
    }).toList();
  }

  Color _getPlayerColor(LudoPlayerType type) {
    switch (type) {
      case LudoPlayerType.green:
        return Colors.green;
      case LudoPlayerType.yellow:
        return Colors.yellow;
      case LudoPlayerType.blue:
        return Colors.blue;
      case LudoPlayerType.red:
        return Colors.red;
    }
  }

  String _getPlayerPhotoAsset(LudoPlayerType type) {
    // Replace these with actual asset paths for player photos
    switch (type) {
      case LudoPlayerType.green:
        return 'assets/images/img/img.png';
      case LudoPlayerType.yellow:
        return 'assets/images/img/img.png';
      case LudoPlayerType.blue:
        return 'assets/images/img/img.png';
      case LudoPlayerType.red:
        return 'assets/images/img/img.png';
    }
  }

  void _showCustomMessageDialog(BuildContext context, LudoProvider provider) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Send a Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.predefinedMessages.entries.map((entry) {
              return Column(
                children: [
                  Text(entry.key.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...entry.value
                      .map((message) => ListTile(
                            title: Text(message),
                            onTap: () {
                              setState(() {
                                _selectedMessagePlayer =
                                    provider.currentPlayer.type;
                              });
                            },
                          ))
                      .toList(),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _selectedMessagePlayer != null
                  ? () {
                      // Find the selected message
                      String? selectedMessage;
                      for (var category in provider.predefinedMessages.values) {
                        selectedMessage = category.firstWhere(
                          (msg) => msg == _selectedMessagePlayer,
                          orElse: () => '',
                        );
                        if (selectedMessage.isNotEmpty) break;
                      }

                      if (selectedMessage != null) {
                        provider.showMessageForPlayer(
                            provider.currentPlayer.type, selectedMessage);
                      }
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:allgames/chess/model/app_model.dart';
import 'package:allgames/chess/views/components/chess_view/chess_board_widget.dart';
import 'package:allgames/chess/views/components/chess_view/game_info_and_controls.dart';
import 'package:allgames/chess/views/components/chess_view/promotion_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'components/chess_view/game_info_and_controls/game_status.dart';
import 'components/shared/bottom_padding.dart';

class ChessView extends StatefulWidget {
  final AppModel appModel;

  ChessView(this.appModel);

  @override
  _ChessViewState createState() => _ChessViewState(appModel);
}

class _ChessViewState extends State<ChessView> {
  AppModel appModel;

  _ChessViewState(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) {
        if (appModel.promotionRequested) {
          appModel.promotionRequested = false;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showPromotionDialog(appModel));
        }
        return WillPopScope(
          onWillPop: _willPopCallback,
          child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(colors: [
              Color(0xff1A1B50),
              Color(0xff0D0918),
            ])),
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
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
                SizedBox(height: 30),
                if (appModel.playerCount == 2) // Add this conditional check
                  VersusScreen(),
                Spacer(),
                ChessBoardWidget(appModel),
                SizedBox(height: 30),
                GameStatus(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: Icons.pan_tool_rounded,
                      label: 'Resign',
                      onTap: () {},
                    ),
                    _buildControlButton(
                      icon: Icons.flag_outlined,
                      label: 'Offer Draw',
                      onTap: () {},
                    ),
                    _buildControlButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () {},
                    ),

                    // Timers(appModel),
                    // MovesUndoRedoRow(appModel),
                    // RestartExitButtons(appModel),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(height: 30),
                // GameInfoAndControls(appModel),
                BottomPadding(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPromotionDialog(AppModel appModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return PromotionDialog(appModel);
      },
    );
  }

  Future<bool> _willPopCallback() async {
    appModel.exitChessView();

    return true;
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Function()? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2A),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class VersusScreen extends StatelessWidget {
  const VersusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Player (Sham)
            _buildPlayerProfile(
                name: "Sham",
                level: "Level 2",
                score: "400",
                borderColor: Colors.red,
                profileImage: "assets/images/home/profile.png",
                isMe: true),

            // Timer
            _buildTimer(),

            // Right Player (Sunny)
            _buildPlayerProfile(
                name: "Sunny",
                level: "Level 2",
                score: "400",
                borderColor: Colors.green,
                profileImage: "assets/images/home/profile.png",
                isMe: false),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerProfile({
    required String name,
    required String level,
    required String score,
    required Color borderColor,
    required String profileImage,
    required bool isMe,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile Image with Border
        // Player Name
        !isMe
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "PoetsenOne-Regular",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Score
                    Row(
                      children: [
                        const Icon(
                          Icons.diamond,
                          color: Colors.amber,
                          size: 20,
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
                    const SizedBox(height: 4),
                  ],
                ),
              )
            : SizedBox.shrink(),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                profileImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Player Name
        isMe
            ? Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "PoetsenOne-Regular",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Score
                    Row(
                      children: [
                        const Icon(
                          Icons.diamond,
                          color: Colors.amber,
                          size: 20,
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
                    const SizedBox(height: 4),
                  ],
                ),
              )
            : SizedBox.shrink(),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildTimer() {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          // Timer Background
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[800]!,
                width: 4,
              ),
            ),
          ),
          // Timer Progress
          CustomPaint(
            size: const Size(60, 60),
            painter: TimerPainter(
              progress: 0.125, // Represents 45 seconds out of 360 seconds
              color: Colors.red,
            ),
          ),
          // Timer Text
          Center(
            child: Text(
              "00:45",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Timer Progress
class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      -90 * (3.14159 / 180), // Start from top (negative 90 degrees)
      progress * 2 * 3.14159, // Progress in radians
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

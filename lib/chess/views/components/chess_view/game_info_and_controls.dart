import 'package:allgames/chess/model/app_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_info_and_controls/moves_undo_redo_row.dart';
import 'game_info_and_controls/restart_exit_buttons.dart';
import 'game_info_and_controls/timers.dart';

class GameInfoAndControls extends StatelessWidget {
  final AppModel appModel;
  final ScrollController scrollController = ScrollController();

  GameInfoAndControls(this.appModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      width: 250,
      child: Row(
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
    );
  }

  void _scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Function()? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
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

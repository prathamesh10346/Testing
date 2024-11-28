import 'package:flutter/material.dart';
import 'package:allgames/ludo/constants.dart';
import 'package:allgames/ludo/widgets/pawn_widget.dart';

class LudoPlayer {
  final LudoPlayerType type;

  late List<List<double>> path;

  late List<List<double>> homePath;

  final List<PawnWidget> pawns = [];

  late Color color;
  bool isActive = true;
  static List<LudoPlayerType> getPlayersForCount(int playerCount) {
    print(playerCount);
    switch (playerCount) {
      case 2:
        return [LudoPlayerType.green, LudoPlayerType.blue]; // Opposite corners
      case 3:
        return [
          LudoPlayerType.green,
          LudoPlayerType.yellow,
          LudoPlayerType.blue,
        ]; // Three corners
      case 4:
      default:
        return [
          LudoPlayerType.green,
          LudoPlayerType.yellow,
          LudoPlayerType.blue,
          LudoPlayerType.red,
        ]; // All corners
    }
  }

  LudoPlayer(this.type) {
    for (int i = 0; i < 4; i++) {
      pawns.add(PawnWidget(i, type));
    }
    switch (type) {
      case LudoPlayerType.green:
        path = LudoPath.greenPath;
        color = LudoColor.green;
        homePath = LudoPath.greenHomePath;
        break;
      case LudoPlayerType.yellow:
        path = LudoPath.yellowPath;
        color = LudoColor.yellow;
        homePath = LudoPath.yellowHomePath;
        break;
      case LudoPlayerType.blue:
        path = LudoPath.bluePath;
        color = LudoColor.blue;
        homePath = LudoPath.blueHomePath;
        break;
      case LudoPlayerType.red:
        path = LudoPath.redPath;
        color = LudoColor.red;
        homePath = LudoPath.redHomePath;
        break;
    }
  }

  ///Get how many pawns are in the home
  int get pawnInsideCount =>
      pawns.where((element) => element.step == -1).length;

  // Get how many pawns are outside home
  int get pawnOutsideCount =>
      pawns.where((element) => element.step > -1).length;

  // Moving means you'll replace the current widget with the new widget
  void movePawn(int index, int step) async {
    pawns[index] = PawnWidget(index, type, step: step, highlight: false);
  }

  // Highlight the pawn
  void highlightPawn(int index, [bool highlight = true]) {
    var pawn = pawns[index];
    pawns.removeAt(index);
    pawns.insert(index,
        PawnWidget(index, pawn.type, highlight: highlight, step: pawn.step));
  }

  // Highlight all the pawns
  void highlightAllPawns([bool highlight = true]) {
    if (!isActive) return; // Don't highlight inactive players' pawns
    for (var i = 0; i < pawns.length; i++) {
      highlightPawn(i, highlight);
    }
  }

  // Highlight pawn outside HOME
  void highlightOutside([bool highlight = true]) {
    if (!isActive) return; // Don't highlight inactive players' pawns
    for (var i = 0; i < pawns.length; i++) {
      if (pawns[i].step != -1) highlightPawn(i, highlight);
    }
  }

  // Highlight pawn inside HOME
  void highlightInside([bool highlight = true]) {
    if (!isActive) return; // Don't highlight inactive players' pawns
    for (var i = 0; i < pawns.length; i++) {
      if (pawns[i].step == -1) highlightPawn(i, highlight);
    }
  }
}

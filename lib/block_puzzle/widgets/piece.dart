import 'package:flutter/material.dart';

int row = 10;
int col = 15;

enum Tetromino {
  L,
  J,
  I,
  II, //horizontal I
  O,
  S,
  SS, //vertical S
  Z,
  T,
  TT, //left T
  TTT //right T
}

enum Directions {
  left,
  right,
  down,
}

// list of ints
class Piece {
  Tetromino type;

  Piece({required this.type});
  List<int> positions = [];

  //genrate integers
  void genPieces() {
    switch (type) {
      case Tetromino.L:
        positions = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        positions = [-25, -15, -6, -5];
        break;
      case Tetromino.I:
        positions = [-36, -26, -16, -6];
        break;
      case Tetromino.II:
        positions = [-7, -6, -5, -4];
        break;
      case Tetromino.O:
        positions = [-16, -15, -6, -5];
        break;
      case Tetromino.S:
        positions = [-15, -14, -6, -5];
        break;
      case Tetromino.SS:
        positions = [-26, -16, -15, -5];
        break;
      case Tetromino.Z:
        positions = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        positions = [-16, -15, -14, -5];
        break;
      case Tetromino.T:
        positions = [-16, -15, -14, -5];
        break;
      case Tetromino.TT:
        positions = [-26, -16, -15, -6];
        break;
      case Tetromino.TTT:
        positions = [-25, -16, -15, -5];
        break;

      default:
    }
  }

  void pieceMove(Directions direction) {
    switch (direction) {
      case Directions.down:
        for (int i = 0; i < positions.length; i++) {
          positions[i] += row;
        }
        break;
      case Directions.left:
        for (int i = 0; i < positions.length; i++) {
          positions[i] -= 1;
        }
        break;
      case Directions.right:
        for (int i = 0; i < positions.length; i++) {
          positions[i] += 1;
        }
        break;
      default:
    }
  }

  Color get color {
    return tetColors[type] ?? Colors.white;
  }
}

//colors
const Map<Tetromino, Color> tetColors = {
  Tetromino.L: Color(0xFF491405),
  Tetromino.J: Color(0xFF491405),
  Tetromino.I: Color(0xFF491405),
  Tetromino.II: Color(0xFF491405),
  Tetromino.O: Color(0xFF491405),
  Tetromino.S: Color(0xFF491405),
  Tetromino.SS: Color(0xFF491405),
  Tetromino.Z: Color(0xFF491405),
  Tetromino.T: Color(0xFF491405),
  Tetromino.TT: Color(0xFF491405),
  Tetromino.TTT: Color(0xFF491405),
};

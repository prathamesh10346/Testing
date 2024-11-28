import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:allgames/ludo/ludo_player.dart';

import 'audio.dart';
import 'constants.dart';

class LudoProvider extends ChangeNotifier {
  LudoProvider({required this.playerCount}) {
    _initializePlayers();
    // Set initial turn to first active player
    _currentTurn = players.first.type;
  }
  String? _currentMessage;
  Timer? _messageTimer;
  get currentMessage => _currentMessage;
  final int playerCount;
  bool _isMoving = false;
  bool _stopMoving = false;

  LudoGameState _gameState = LudoGameState.throwDice;

  LudoGameState get gameState => _gameState;

  LudoPlayerType _currentTurn = LudoPlayerType.green;

  int _diceResult = 0;
  late List<LudoPlayer> players;
  void sendPredefinedMessage(String category) {
    final messages = _predefinedMessages[category] ?? [];
    if (messages.isNotEmpty) {
      _currentMessage = messages[Random().nextInt(messages.length)];
      showMessageForPlayer(currentPlayer.type, _currentMessage ?? '');
      // Clear previous timer if exists
      _messageTimer?.cancel();

      // Set a new timer to clear the message after 5 seconds
      _messageTimer = Timer(const Duration(seconds: 3), () {
        _currentMessage = null;
        showMessageForPlayer(currentPlayer.type, _currentMessage ?? '');
        notifyListeners();
      });

      notifyListeners();
    }
  }

  void _initializePlayers() {
    players = [];
    // Get appropriate player types based on count
    List<LudoPlayerType> activeTypes =
        LudoPlayer.getPlayersForCount(playerCount);

    // Initialize all players but mark inactive ones
    List<LudoPlayerType> allTypes = [
      LudoPlayerType.green,
      LudoPlayerType.yellow,
      LudoPlayerType.blue,
      LudoPlayerType.red,
    ];

    for (var type in allTypes) {
      var player = LudoPlayer(type);
      player.isActive = activeTypes.contains(type);
      players.add(player);
    }
  }

  int get diceResult {
    if (_diceResult < 1) {
      return 1;
    } else {
      if (_diceResult > 6) {
        return 6;
      } else {
        return _diceResult;
      }
    }
  }

  Map<LudoPlayerType, int> _diceResults = {
    LudoPlayerType.green: 1,
    LudoPlayerType.yellow: 1,
    LudoPlayerType.blue: 1,
    LudoPlayerType.red: 1,
  };

  Map<LudoPlayerType, int> get diceResults => _diceResults;

  bool _diceStarted = false;
  bool get diceStarted => _diceStarted;

  LudoPlayer get currentPlayer =>
      players.firstWhere((element) => element.type == _currentTurn);

  // final List<LudoPlayer> players = [
  //   LudoPlayer(LudoPlayerType.green),
  //   LudoPlayer(LudoPlayerType.yellow),
  //   LudoPlayer(LudoPlayerType.blue),
  //   LudoPlayer(LudoPlayerType.red),
  // ];

  final List<LudoPlayerType> winners = [];

  LudoPlayer player(LudoPlayerType type) =>
      players.firstWhere((element) => element.type == type);

  void throwDice() async {
    if (_gameState != LudoGameState.throwDice) return;
    _diceStarted = true;
    notifyListeners();
    Audio.rollDice();

    if (winners.contains(currentPlayer.type)) {
      nextTurn();
      return;
    }

    currentPlayer.highlightAllPawns(false);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      _diceStarted = false;
      var random = Random();
      _diceResults[_currentTurn] =
          random.nextBool() ? 6 : random.nextInt(6) + 1;
      notifyListeners();

      _diceResult =
          random.nextBool() ? 6 : random.nextInt(6) + 1; //Random between 1 - 6
      notifyListeners();

      if (diceResult == 6) {
        currentPlayer.highlightAllPawns();
        _gameState = LudoGameState.pickPawn;
        notifyListeners();
      } else {
        /// all pawns are inside home
        if (currentPlayer.pawnInsideCount == 4) {
          return nextTurn();
        } else {
          currentPlayer.highlightOutside();
          _gameState = LudoGameState.pickPawn;
          notifyListeners();
        }
      }

      for (var i = 0; i < currentPlayer.pawns.length; i++) {
        var pawn = currentPlayer.pawns[i];
        if ((pawn.step + diceResult) > currentPlayer.path.length - 1) {
          currentPlayer.highlightPawn(i, false);
        }
      }

      var moveablePawn = currentPlayer.pawns.where((e) => e.highlight).toList();
      if (moveablePawn.length > 1) {
        var biggestStep = moveablePawn.map((e) => e.step).reduce(max);
        if (moveablePawn.every((element) => element.step == biggestStep)) {
          var random = 1 + Random().nextInt(moveablePawn.length - 1);
          if (moveablePawn[random].step == -1) {
            var thePawn = moveablePawn[random];
            move(thePawn.type, thePawn.index, (thePawn.step + 1) + 1);
            return;
          } else {
            var thePawn = moveablePawn[random];
            move(thePawn.type, thePawn.index, (thePawn.step + 1) + diceResult);
            return;
          }
        }
      }

      if (currentPlayer.pawns.every((element) => !element.highlight)) {
        if (diceResult == 6) {
          _gameState = LudoGameState.throwDice;
        } else {
          nextTurn();
          return;
        }
      }

      if (currentPlayer.pawns.where((element) => element.highlight).length ==
          1) {
        var index =
            currentPlayer.pawns.indexWhere((element) => element.highlight);
        move(currentPlayer.type, index,
            (currentPlayer.pawns[index].step + 1) + diceResult);
      }
    });
  }

  void move(LudoPlayerType type, int index, int step) async {
    if (_isMoving) return;
    _isMoving = true;
    _gameState = LudoGameState.moving;

    currentPlayer.highlightAllPawns(false);

    var selectedPlayer = player(type);
    for (int i = selectedPlayer.pawns[index].step; i < step; i++) {
      if (_stopMoving) break;
      if (selectedPlayer.pawns[index].step == i) continue;
      selectedPlayer.movePawn(index, i);
      await Audio.playMove();
      notifyListeners();
      if (_stopMoving) break;
    }
    if (checkToKill(type, index, step, selectedPlayer.path)) {
      _gameState = LudoGameState.throwDice;
      _isMoving = false;
      Audio.playKill();
      notifyListeners();
      return;
    }

    validateWin(type);

    if (diceResult == 6) {
      _gameState = LudoGameState.throwDice;
      notifyListeners();
    } else {
      nextTurn();
      notifyListeners();
    }
    _isMoving = false;
  }

  void nextTurn() {
    int currentIndex =
        players.indexWhere((player) => player.type == _currentTurn);
    do {
      currentIndex = (currentIndex + 1) % players.length;
      // Skip inactive players and winners
    } while (!players[currentIndex].isActive ||
        winners.contains(players[currentIndex].type));

    _currentTurn = players[currentIndex].type;
    _gameState = LudoGameState.throwDice;
    notifyListeners();
  }

  bool checkToKill(
      LudoPlayerType type, int index, int step, List<List<double>> path) {
    bool killSomeone = false;
    for (int i = 0; i < 4; i++) {
      var greenElement = player(LudoPlayerType.green).pawns[i];
      var blueElement = player(LudoPlayerType.blue).pawns[i];
      var redElement = player(LudoPlayerType.red).pawns[i];
      var yellowElement = player(LudoPlayerType.yellow).pawns[i];

      if ((greenElement.step > -1 &&
              !LudoPath.safeArea.map((e) => e.toString()).contains(
                  player(LudoPlayerType.green)
                      .path[greenElement.step]
                      .toString())) &&
          type != LudoPlayerType.green) {
        if (player(LudoPlayerType.green).path[greenElement.step].toString() ==
            path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.green).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((yellowElement.step > -1 &&
              !LudoPath.safeArea.map((e) => e.toString()).contains(
                  player(LudoPlayerType.yellow)
                      .path[yellowElement.step]
                      .toString())) &&
          type != LudoPlayerType.yellow) {
        if (player(LudoPlayerType.yellow).path[yellowElement.step].toString() ==
            path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.yellow).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((blueElement.step > -1 &&
              !LudoPath.safeArea.map((e) => e.toString()).contains(
                  player(LudoPlayerType.blue)
                      .path[blueElement.step]
                      .toString())) &&
          type != LudoPlayerType.blue) {
        if (player(LudoPlayerType.blue).path[blueElement.step].toString() ==
            path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.blue).movePawn(i, -1);
          notifyListeners();
        }
      }
      if ((redElement.step > -1 &&
              !LudoPath.safeArea.map((e) => e.toString()).contains(
                  player(LudoPlayerType.red)
                      .path[redElement.step]
                      .toString())) &&
          type != LudoPlayerType.red) {
        if (player(LudoPlayerType.red).path[redElement.step].toString() ==
            path[step - 1].toString()) {
          killSomeone = true;
          player(LudoPlayerType.red).movePawn(i, -1);
          notifyListeners();
        }
      }
    }
    return killSomeone;
  }

  void validateWin(LudoPlayerType color) {
    // Only validate for active players
    if (!players.firstWhere((p) => p.type == color).isActive) return;

    if (winners.map((e) => e.name).contains(color.name)) return;
    if (player(color)
        .pawns
        .map((e) => e.step)
        .every((element) => element == player(color).path.length - 1)) {
      winners.add(color);
      notifyListeners();
    }

    // Game ends when all but one active player has won
    int activePlayerCount = players.where((p) => p.isActive).length;
    if (winners.length == activePlayerCount - 1) {
      _gameState = LudoGameState.finish;
    }
  }

  void changePlayerTurn() {
    // Existing nextTurn logic
    nextTurn();

    // Add a brief visual/audio feedback
    _showPlayerChangeAnimation();
  }

  void _showPlayerChangeAnimation() {
    // Simulate a brief highlight/glow effect
    // This could be implemented with a state change that triggers
    // a visual indicator in the UI
    notifyListeners();

    // Optional: Play a sound effect
    // Audio.playPlayerChangeSound();
  }

  String getRandomMessage(String category) {
    final messages = _predefinedMessages[category] ?? [];
    return messages.isNotEmpty
        ? messages[Random().nextInt(messages.length)]
        : '';
  }

  final Map<String, List<String>> _predefinedMessages = {
    'greeting': [
      'Hello!',
      'Good luck!',
      'Let\'s play!',
      'Ready to win?',
    ],
    'encouragement': [
      'You can do it!',
      'Nice move!',
      'Keep going!',
      'Great strategy!',
    ],
    'taunt': [
      'Watch out!',
      'I\'m coming for you!',
      'Your move...',
      'Prepare to lose!',
    ]
  };
  void showMessageForPlayer(LudoPlayerType playerType, String message) {
    // Clear any existing timer
    _messageTimer?.cancel();

    // Set message for specific player
    _playerMessages[playerType] = message;

    // Set timer to clear message after 5 seconds
    _messageTimer = Timer(const Duration(seconds: 5), () {
      _playerMessages[playerType] = null;
      notifyListeners();
    });

    notifyListeners();
  }

  Map<String, List<String>> get predefinedMessages => _predefinedMessages;
  Map<LudoPlayerType, String?> _playerMessages = {
    LudoPlayerType.green: null,
    LudoPlayerType.yellow: null,
    LudoPlayerType.blue: null,
    LudoPlayerType.red: null,
  };
  String? getMessageForPlayer(LudoPlayerType playerType) {
    return _playerMessages[playerType];
  }

  @override
  void dispose() {
    _stopMoving = true;
    _messageTimer?.cancel();
    super.dispose();
  }
}

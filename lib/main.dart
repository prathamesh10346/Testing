import 'package:allgames/auth/login_screen.dart';
import 'package:allgames/home/home_screen.dart';
import 'package:allgames/ludo/main_screen.dart';
import 'package:allgames/providers/auth/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';

// Import chess-related files
import 'package:allgames/chess/model/app_model.dart';
import 'package:allgames/chess/views/main_menu_view.dart';
import 'package:allgames/chess/logic/shared_functions.dart';
import 'ludo/ludo_provider.dart';

// Create a provider to manage global app state
class GameStateProvider extends ChangeNotifier {
  int _playerCount = 2; // Default to 2 players

  int get playerCount => _playerCount;

  void setPlayerCount(int count) {
    _playerCount = count;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load chess assets
  await Hive.initFlutter();
  var highbox = await Hive.openBox("HighScore_db");
  _loadFlameAssets();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameStateProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(
            create: (_) => AppModel()), // Add chess AppModel provider
      ],
      child: const Root(),
    ),
  );
}

void _loadFlameAssets() async {
  List<String> pieceImages = [];
  for (var theme in PIECE_THEMES) {
    for (var color in ['black', 'white']) {
      for (var piece in ['king', 'queen', 'rook', 'bishop', 'knight', 'pawn']) {
        pieceImages
            .add('pieces/${formatPieceTheme(theme)}/${piece}_$color.png');
      }
    }
  }
  await Flame.images.loadAll(pieceImages);
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/images/thankyou.gif"), context);
    precacheImage(const AssetImage("assets/images/board.png"), context);
    precacheImage(const AssetImage("assets/images/dice/1.png"), context);
    precacheImage(const AssetImage("assets/images/dice/2.png"), context);
    precacheImage(const AssetImage("assets/images/dice/3.png"), context);
    precacheImage(const AssetImage("assets/images/dice/4.png"), context);
    precacheImage(const AssetImage("assets/images/dice/5.png"), context);
    precacheImage(const AssetImage("assets/images/dice/6.png"), context);
    precacheImage(const AssetImage("assets/images/dice/draw.gif"), context);
    precacheImage(const AssetImage("assets/images/crown/1st.png"), context);
    precacheImage(const AssetImage("assets/images/crown/2nd.png"), context);
    precacheImage(const AssetImage("assets/images/crown/3rd.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

extension MainScreenProvider on MainScreen {
  static Widget withProvider({required int playerCount}) {
    return ChangeNotifierProvider(
      create: (_) => LudoProvider(playerCount: playerCount),
      child: MainScreen(playerCount: playerCount),
    );
  }
}

import 'package:allgames/block_puzzle/block_puzzle_main.dart';
import 'package:allgames/carrom/carrom_home_screen.dart';
import 'package:allgames/carrom/home_main.dart';
import 'package:allgames/chess/views/main_menu_view.dart';
import 'package:allgames/fruit_ninja/initial_screen.dart';
import 'package:allgames/home/my_profile_screen.dart';
import 'package:allgames/home/wallet/wallet_history.dart';
import 'package:allgames/home/wallet/wallet_withdrawal.dart';
import 'package:allgames/ludo/home_screen/ludo_home_screen.dart';
import 'package:allgames/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:allgames/math_calculation/math_main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF1D1226),
      drawer: SideMenu(),
      body: _buildBody(context, appState),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildBody(BuildContext context, AppState appState) {
    Widget currentScreen;
    switch (appState.currentIndex) {
      case 0:
        currentScreen = WalletScreen();
        break;
      case 1:
        currentScreen = _buildHomeContent(context);
        break;
      case 2:
        currentScreen = Center(
            child:
                Text('Winnings Screen', style: TextStyle(color: Colors.white)));
        break;
      case 3:
        currentScreen = MyProfileScreen();
        break;
      default:
        currentScreen = _buildHomeContent(context);
    }

    return Column(
      children: [
        if (appState.currentIndex == 1) _buildAppBar(context),
        Expanded(child: currentScreen),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Color(0xFF1D1226),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Expanded(child: SizedBox(height: 40, child: SearchBar())),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/home/profile.png'),
                  radius: 25,
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 10),
            LudoBanner(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return Column(
      children: [
        Expanded(child: GameList()),
      ],
    );
  }
}

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF1C1A26),
        child: Column(
          children: [
            Container(
                color: Color(0xff3F375E),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          AssetImage('assets/images/home/profile.png'),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hi Name 9326547894',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                )),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/home/profileicon.png',
                  height: 25,
                ),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/home/withdrawal.png',
                  height: 25,
                ),
                title:
                    Text('Withdrawal', style: TextStyle(color: Colors.white)),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15),
            //   child: ListTile(
            //     leading: Image.asset(
            //       'assets/images/home/Recharge.png',
            //       height: 25,
            //     ),
            //     title: Text('Recharge', style: TextStyle(color: Colors.white)),
            //   ),
            // ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/home/share.png',
                  height: 55,
                ),
                Image.asset(
                  'assets/images/home/support.png',
                  height: 55,
                ),
                Image.asset(
                  'assets/images/home/logout.png',
                  height: 55,
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          contentPadding: EdgeInsets.all(
            8,
          ),
          fillColor: Color(0xFF3F375E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class LudoBanner extends StatefulWidget {
  @override
  _LudoBannerState createState() => _LudoBannerState();
}

class _LudoBannerState extends State<LudoBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Add your banner images here
  final List<String> bannerImages = [
    'assets/images/home/pos1.png',
    'assets/images/home/pos2.png',
    'assets/images/home/pos3.png',
    'assets/images/home/pos4.png',
    'assets/images/home/pos5.png',
    'assets/images/home/pos6.png',
    'assets/images/home/pos7.png',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll functionality
    Future.delayed(Duration(seconds: 1), () {
      autoScroll();
    });
  }

  void autoScroll() {
    Future.delayed(Duration(seconds: 3), () {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
      autoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      height: 100,
      child: Stack(
        children: [
          // PageView for sliding banners
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          // Dot indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bannerImages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GameList extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {
      'name': 'Ludo',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/ludo.png'
    },
    {
      'name': 'Carrom',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/carrom.png'
    },
    {
      'name': 'Chess',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/chess.png'
    },
    {
      'name': 'Fruit Ninja',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/fruitNinja.png'
    },
    {
      'name': 'Block Puzzle',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/puzzle.png'
    },
    {
      'name': 'Math Calculation',
      'rating': 3.5,
      'version': '1.1',
      'image': 'assets/images/home/calculation.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF24202E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(games[index]['image'],
                      fit: BoxFit.cover, width: 100, height: 100),
                ),
                title: Text(
                  games[index]['name'],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/home/strat.png",
                          height: 12,
                        ),
                        Text(
                          ' ${games[index]['rating']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      'Ver. ${games[index]['version']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    index == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LudoGameSelectionScreen()))
                        : index == 1
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CarromGameSelectionScreen()))
                            : index == 2
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chess()))
                                : index == 3
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InitialScreen()))
                                    : index == 5
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyMathHomePage()))
                                        : index == 4
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyblockPuzzleApp()))
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('Coming Soon')));
                  },
                  child: Container(
                    width: 75,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF3D3550).withOpacity(1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 18,
                        ),
                        Text(
                          " Play",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3F3660),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: appState.currentIndex,
          onTap: (index) => appState.setIndex(index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          items: [
            _buildNavItem(Icons.account_balance_wallet, 'WALLET', 0,
                appState.currentIndex),
            _buildNavItem(Icons.home, 'HOME', 1, appState.currentIndex),
            _buildNavItem(
                Icons.emoji_events, 'WINNINGS', 2, appState.currentIndex),
            _buildNavItem(Icons.person, 'PROFILE', 3, appState.currentIndex),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index, int currentIndex) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          SizedBox(height: 5),
          Icon(icon),
          SizedBox(height: 5),
          if (index == currentIndex)
            Container(
              width: 30,
              height: 3,
              color: Colors.yellow,
            ),
        ],
      ),
      label: label,
    );
  }
}

class Chess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess',
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: 'Jura', fontSize: 16),
          pickerTextStyle: TextStyle(fontFamily: 'Jura'),
        ),
      ),
      home: MainMenuView(),
    );
  }
}

class AppState extends ChangeNotifier {
  int _currentIndex = 1; // Start with HOME selected
  int get currentIndex => _currentIndex;
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {'type': 'Ludo', 'amount': -250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': '', 'amount': 250.00, 'timestamp': '24-12-2024 11:11:11'},
      {
        'type': 'Withdrawal',
        'amount': -250.00,
        'timestamp': '24-12-2024 11:11:11'
      },
      {'type': '', 'amount': 250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': '', 'amount': 250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': 'Ludo', 'amount': -250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': '', 'amount': 250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': 'Ludo', 'amount': -250.00, 'timestamp': '24-12-2024 11:11:11'},
      {'type': '', 'amount': 250.00, 'timestamp': '24-12-2024 11:11:11'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1D1226),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D1226),
        title: Text(
          'Wallet',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PoetsenOne-Regular",
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletHistoryScreen(),
                ),
              );
            },
            child: Image.asset(
              "assets/images/home/history.png",
              scale: 1.5,
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Balance Card
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1C052B),
                        Color(0xFF6F0385).withOpacity(0.8)
                      ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 35),
                        Icon(
                          Icons.account_balance_wallet,
                          color: Color(0xffA92AFF).withOpacity(0.7),
                          size: 64,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '₹ 40,00,000',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "PoetsenOne-Regular",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Image.asset("assets/images/home/back.png")
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: 130,
                      child: Text(
                        "Balance",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawalScreen(),
                  ),
                );
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF3F3660),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Withdraw Now",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )

            // // Action Buttons
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       // Recharge Button
            //       Column(
            //         children: [
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: const BoxDecoration(
            //               color: Color(0xFF2d2d44),
            //               shape: BoxShape.circle,
            //             ),
            //             child: const Icon(
            //               Icons.upload,
            //               color: Colors.white,
            //               size: 24,
            //             ),
            //           ),
            //           const SizedBox(height: 4),
            //           const Text(
            //             'Recharge',
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 15,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(width: 24),
            //       // Withdrawal Button
            //       Column(
            //         children: [
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: const BoxDecoration(
            //               color: Color(0xFF2d2d44),
            //               shape: BoxShape.circle,
            //             ),
            //             child: const Icon(
            //               Icons.file_download_sharp,
            //               color: Colors.white,
            //               size: 24,
            //             ),
            //           ),
            //           const SizedBox(height: 4),
            //           const Text(
            //             'Withdrawal',
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 15,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            // // Transactions Header
            // const Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Row(
            //     children: [
            //       Text(
            //         'Transactions',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Transactions List
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: transactions.length,
            //     itemBuilder: (context, index) {
            //       final transaction = transactions[index];
            //       return Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 12,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Color(0xff24202E),
            //           border: Border(
            //             bottom: BorderSide(
            //               color: Colors.white.withOpacity(0.1),
            //               width: 0.5,
            //             ),
            //           ),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   transaction['type'] as String,
            //                   style: const TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //                 const SizedBox(height: 4),
            //                 Text(
            //                   transaction['timestamp'] as String,
            //                   style: TextStyle(
            //                     color: Colors.white.withOpacity(0.6),
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             Text(
            //               '${transaction['amount'] > 0 ? '+' : ''}₹${transaction['amount'].abs()}',
            //               style: TextStyle(
            //                 color: transaction['amount'] > 0
            //                     ? Colors.green
            //                     : Colors.red,
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

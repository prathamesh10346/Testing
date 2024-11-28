import 'package:allgames/carrom/carrom_setting_screen.dart';
import 'package:allgames/carrom/home_main.dart';
import 'package:allgames/ludo/home_screen/ludo_setting_screen.dart';
import 'package:allgames/ludo/home_screen/select_color.dart';
import 'package:allgames/ludo/main_screen.dart';
import 'package:allgames/main.dart';
import 'package:flutter/material.dart';

class CarromChoosePlayerSelectionScreen extends StatefulWidget {
  final bool isOnline;

  const CarromChoosePlayerSelectionScreen({Key? key, required this.isOnline})
      : super(key: key);

  @override
  State<CarromChoosePlayerSelectionScreen> createState() =>
      _CarromChoosePlayerSelectionScreenState();
}

class _CarromChoosePlayerSelectionScreenState
    extends State<CarromChoosePlayerSelectionScreen> {
  GameMode _selectedMode = GameMode.twoPlayer;
  bool _isJoin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xffF8C0C0), Color(0xffF8C0C0), Color(0xff890015)],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/carrom/carron_blur_BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 40),
                  widget.isOnline
                      ? _buildOnlineContent()
                      : _buildOfflineContent(),
                ],
              ),
              _buildProfileCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: Image.asset("assets/images/carrom/back_carrom.png",
                width: 35, height: 35),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(height: 5, color: const Color(0xffBDBF52)),
        const SizedBox(height: 140),
        for (var image in ['1v1', '4player'])
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () {
                _showPlayerOptionsBottomSheet(context, image);
              },
              child:
                  Image.asset('assets/images/ludo/home/$image.png', width: 325),
            ),
          ),
      ],
    );
  }

  Widget _buildOfflineContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(height: 5, color: const Color(0xffBDBF52)),
        const SizedBox(height: 90),
        _buildToggleButtons(),
        const SizedBox(height: 20),
        _isJoin ? _buildJoinContainer() : _buildCreateContainer(),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton('Create', !_isJoin),
        const SizedBox(width: 20),
        _buildToggleButton('Join', _isJoin),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return InkWell(
      onTap: () => setState(() => _isJoin = text == 'Join'),
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [const Color(0xffFFEC48), const Color(0xffF19F03)]
                : [const Color(0xff030534), const Color(0xff030534)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinContainer() {
    return _buildContentContainer(
      children: [
        const Text("Enter Code",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        SizedBox(
          width: 150,
          height: 40,
          child: TextFormField(
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              fillColor: const Color(0xff030534),
              hintText: "Enter",
              contentPadding: const EdgeInsets.only(top: 40, left: 15),
              hintStyle: const TextStyle(
                  color: Color(0xff9C9C9C),
                  fontSize: 15,
                  fontFamily: "PoetsenOne-Regular",
                  fontWeight: FontWeight.w600),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xff606060))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xff606060))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xff606060))),
            ),
          ),
        ),
        const SizedBox(height: 60),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChooseColorSelectionScreen()));
            },
            child: Image.asset("assets/images/ludo/home/join.png", width: 120)),
      ],
    );
  }

  Widget _buildCreateContainer() {
    return _buildContentContainer(
      children: [
        const Text("Select number of players",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var number in [2, 4])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildNumberContainer(number),
              ),
          ],
        ),
        const SizedBox(height: 60),
        Image.asset("assets/images/ludo/home/create.png", width: 120),
      ],
    );
  }

  Widget _buildContentContainer({required List<Widget> children}) {
    return Container(
      width: MediaQuery.of(context).size.width - 120,
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xff721313),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget _buildNumberContainer(int number) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: const Color(0xff030534),
        borderRadius: BorderRadius.circular(5),
        border: number == 2 ? Border.all(color: Colors.yellow) : null,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "PoetsenOne-Regular",
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Positioned(
      top: 10,
      left: 20,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 250,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/ludo/home/homeitem.png'),
              fit: BoxFit.fitWidth),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const SizedBox(width: 60),
            Column(
              children: [
                const SizedBox(height: 80),
                Row(
                  children: [
                    Image.asset('assets/images/home/profile.png',
                        width: 50, height: 50),
                    const SizedBox(width: 10),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "PoetsenOne-Regular",
                                fontWeight: FontWeight.w600)),
                        Text("+91 1234567890",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "PoetsenOne-Regular",
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(width: 30),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CarromSettingsScreen()));
                        },
                        child: _buildIconButton(Icons.settings)),
                    const SizedBox(width: 10),
                    _buildIconButton(Icons.notifications_rounded,
                        color: Colors.yellow),
                  ],
                ),
                const SizedBox(height: 5),
                _buildWalletContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {Color color = Colors.white}) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: const Color(0xff003090),
        border: Border.all(color: Colors.white),
        shape: BoxShape.circle,
      ),
      child: Center(child: Icon(icon, size: 20, color: color)),
    );
  }

  Widget _buildWalletContainer() {
    return Container(
      width: 125,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xff003090),
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: const Color(0xff903000), width: 5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Center(
              child: Text('₹ 10', style: TextStyle(color: Colors.white))),
          Positioned(
              top: -29,
              left: -30,
              child: Image.asset('assets/images/ludo/home/walleticon.png',
                  width: 75, height: 75)),
          Positioned(
              top: -5,
              right: -10,
              child: Image.asset('assets/images/ludo/home/addIcon.png',
                  width: 31, height: 31)),
        ],
      ),
    );
  }

  void _showPlayerOptionsBottomSheet(BuildContext context, String playerType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF511111),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                playerType == '1v1' ? '1 vs 1' : '4 Players',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'PoetsenOne-Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff6C0B0B),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'To Join, you need to pay the bet amount.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'PoetsenOne-Regular',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/img/groupicon.png',
                              width: 30),
                          const SizedBox(width: 10),
                          Text(
                            playerType == '1v1' ? '100' : '400',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 24,
                              fontFamily: 'PoetsenOne-Regular',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xff52BB41),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _startSearchingForPlayer(
                                context, playerType == '1v1' ? 2 : 4);
                          },
                          child: const Center(
                            child: Text(
                              'Join',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  void _startSearchingForPlayer(BuildContext context, int PlayerCount) {
    if (context == null) return; // Add null check for context

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            // Check if the widget is still in the tree
            Navigator.of(context).pop();
            _showPleaseWaitDialog(context);
            Navigator.of(context).pop();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarromBoard(
                  gameMode: PlayerCount == 2
                      ? GameMode.twoPlayer
                      : GameMode.fourPlayer,
                ),
              ),
            );
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => MainScreen(
            //               playerCount: PlayerCount,
            //             )));
          }
        });
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF511111),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [],
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Searching for player',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'PoetsenOne-Regular',
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff6C0B0B),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Your game is about to begin',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PoetsenOne-Regular',
                              fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Please stay on this page',
                          style: TextStyle(
                            color: Color(0xffFFBC00),
                            fontFamily: 'PoetsenOne-Regular',
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );

    // Simulate finding a player after 3 seconds
  }

  void _showPleaseWaitDialog(BuildContext context) {
    //after 2 sec navigate to the screen

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.indigo[800],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Row(
                children: [],
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Please wait...!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

import 'package:allgames/ludo/home_screen/ludo_setting_screen.dart';
import 'package:allgames/ludo/main_screen.dart';
import 'package:flutter/material.dart';

class ChooseColorSelectionScreen extends StatefulWidget {
  @override
  State<ChooseColorSelectionScreen> createState() =>
      _ChooseColorSelectionScreenState();
}

class _ChooseColorSelectionScreenState
    extends State<ChooseColorSelectionScreen> {
  final List<Color> _colors = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.red
  ];
  final List<String> _colorName = ["blue", "yellow", "green", "red"];
  int? _selectedColorIndex;
  bool _isSelected = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[800],
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xff2539A5),
          image: DecorationImage(
            opacity: 0.11,
            image: AssetImage('assets/images/ludo/home/backgroundimg.png'),
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
                  _buildContent()
                ],
              ),
              _isSelected == true ? _buildStartButton() : SizedBox(),
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
            icon: Image.asset("assets/images/img/back.png",
                width: 35, height: 35),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(height: 5, color: const Color(0xffBDBF52)),
        const SizedBox(height: 90),
        const Text("Select your color",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "PoetsenOne-Regular",
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        _isSelected ? _buildLoadingScreen() : _buildColorSelection(),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      children: [
        const Text(
          "Waiting for Friends to connect",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "PoetsenOne-Regular",
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF0E163E),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Image.asset(
                "assets/images/pawn/${_colorName[_selectedColorIndex!]}.png",
                height: 40,
              ),
              const Spacer(),
              Text(
                "You",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "PoetsenOne-Regular",
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildStartButton() {
    return Positioned(
      bottom: 20,
      right: 120,
      child: InkWell(
        onTap: () {
          _isLoading
              ? null
              : Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen(
                    playerCount: 2,
                  )));
        },
        child: SizedBox(
            height: 60,
            width: 150,
            child: Opacity(
                opacity: _isLoading ? 0.5 : 1,
                child: Image.asset('assets/images/ludo/home/strat.png'))),
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
                                fontSize: 18,
                                fontFamily: "PoetsenOne-Regular",
                                fontWeight: FontWeight.w600)),
                        Text("+91 1234567890",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                  builder: (context) => SettingsScreen()));
                        },
                        child: _buildIconButton(Icons.settings)),
                    const SizedBox(width: 10),
                    _buildIconButton(Icons.notifications_rounded,
                        color: Colors.yellow),
                  ],
                ),
                const SizedBox(height: 10),
                _buildWalletContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        ...List.generate(
          _colors.length,
          (index) => _buildColorOption(index),
        ),
      ],
    );
  }

  Widget _buildColorOption(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF0E163E),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Image.asset(
              "assets/images/pawn/${_colorName[index]}.png",
              height: 40,
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedColorIndex = index;
                  _isSelected = true;
                  _isLoading = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _isLoading = false;
                  });
                });
              },
              child: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: _selectedColorIndex == index
                      ? Colors.green
                      : Color(0xff4143B5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Text(
                    _selectedColorIndex == index ? 'Selected' : 'Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
        border: Border.all(color: const Color(0xff03C3FF), width: 5),
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
}

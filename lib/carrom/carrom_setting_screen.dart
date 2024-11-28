import 'package:flutter/material.dart';

class CarromSettingsScreen extends StatefulWidget {
  @override
  _CarromSettingsScreenState createState() => _CarromSettingsScreenState();
}

class _CarromSettingsScreenState extends State<CarromSettingsScreen> {
  bool isMusicOn = true;
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(8),
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
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "assets/images/carrom/back_carrom.png",
                          width: 35,
                          height: 35,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PoetsenOne-Regular",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Settings Container
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: Color(0xFF511111),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildToggleSetting(
                                'Music', Icons.music_note, isMusicOn, (value) {
                              setState(() => isMusicOn = value);
                            }),
                            SizedBox(height: 16),
                            _buildToggleSetting(
                                'Sound', Icons.volume_up, isSoundOn, (value) {
                              setState(() => isSoundOn = value);
                            }),
                            SizedBox(height: 16),
                            _buildSettingItem(
                                'My Wallet', Icons.account_balance_wallet),
                            SizedBox(height: 16),
                            _buildSettingItem(
                                'How to play', Icons.help_outline),
                            SizedBox(height: 16),
                            _buildSettingItem('Help', Icons.help),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
      String title, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF6C0B0B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "PoetsenOne-Regular"),
                ),
              ],
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF6C0B0B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "PoetsenOne-Regular"),
            ),
          ],
        ),
      ),
    );
  }
}

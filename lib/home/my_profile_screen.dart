import 'package:allgames/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'My Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "PoetsenOne-Regular",
              ),
            ),
            SizedBox(height: 130),
            ProfileInfoCard(),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xFF3F3660),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ]),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 100,
            top: -80,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/home/profile.png'),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                width: 100,
                height: 25,
                decoration: BoxDecoration(
                  color: Color(0xff36206D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child:
                      Text('Change Pic', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              ProfileInfoItem(
                icon: Icons.person,
                text: 'Ram',
              ),
              SizedBox(height: 15),
              ProfileInfoItem(
                  icon: Icons.phone,
                  text: '+91 1234567890',
                  trailing: Container(
                    height: 28,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFF100659),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Center(
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 15),
              ProfileInfoItem(
                icon: Icons.email,
                text: 'ram@gmail.com',
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
              SizedBox(height: 15),
              ProfileInfoItem(
                icon: Icons.games,
                text: 'Games played',
                trailing: Text(
                  '15',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "PoetsenOne-Regular",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;

  const ProfileInfoItem({
    Key? key,
    required this.icon,
    required this.text,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Color(0xFF1D1226),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ]),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "PoetsenOne-Regular",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

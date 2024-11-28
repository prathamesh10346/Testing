import 'package:allgames/block_puzzle/pages/home.dart';
import 'package:allgames/block_puzzle/utils/routes.dart';
import 'package:allgames/block_puzzle/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



class MyblockPuzzleApp extends StatefulWidget {
  const MyblockPuzzleApp({super.key});

  @override
  State<MyblockPuzzleApp> createState() => _MyblockPuzzleAppState();
}

class _MyblockPuzzleAppState extends State<MyblockPuzzleApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromRGBO(
          27, 18, 18, 1), // Background color of the navigation bar
      statusBarColor:
          Color.fromRGBO(27, 18, 18, 1), // Background color of the status bar
    ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //removes debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: "/", //this route will open first

      routes: {
        //creating routes for different pages in app
        "/": (context) => HomePage(), //main root
        Myroutes.drawerRoute: (context) => DrawerPage(
              high: 0,
            ),
      },
    );
  }
}

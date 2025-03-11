// splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterappkideld/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart'; // ProfilePage



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isLandingPageFirstTime = prefs.getBool('isLandingPageFirstTime') ?? true;

    Timer(const Duration(seconds: 1), () {
      if (isLoggedIn) {
       // if (isLandingPageFirstTime) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        }
      //else {
        //  Navigator.of(context).pushReplacement(
        //    MaterialPageRoute(builder: (context) => ProfilePage()),
       //   );
      //  }
   //   }
      else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/splashlogo.png', // Your logo path
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

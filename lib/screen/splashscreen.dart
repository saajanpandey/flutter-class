import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_test_app/screen/auth/loginpage.dart';
import 'package:my_test_app/screen/bottomNavbar.dart';
import 'package:my_test_app/screen/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    timer();
  }

  timer() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigation);
  }

  navigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? status = prefs.getBool('loginStatus');
    if (status == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Image.asset('assets/splash.png'),
            const CircularProgressIndicator(),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}

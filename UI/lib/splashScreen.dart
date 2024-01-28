import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                shrinkWrap: true, // Set shrinkWrap to true
                children: [
                  Image.asset(
                    'assets/jebena.png',
                    width:
                        80, // Adjust the width and height based on your preference
                    height: 80,
                  ),
                  Image.asset(
                    'assets/axum.jpg',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/Lalibela.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/Fasil.jpeg',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/mesob.png',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/lalibela2.jpg',
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Ethiopic Artifacts Detector',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                shrinkWrap: true, // Set shrinkWrap to true
                children: [
                  Image.asset(
                    'assets/pillow.jpg',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/crown.jpg',
                    width: 80,
                    height: 80,
                  ),
                  Image.asset(
                    'assets/Sini.jpg',
                    width: 80,
                    height: 80,
                  ),
                  // Image.asset(
                  //   'assets/Berele.jpg',
                  //   width: 80,
                  //   height: 80,
                  // ),
                  // Image.asset(
                  //   'assets/baskets.jpg',
                  //   width: 80,
                  //   height: 80,
                  // ),
                  // Image.asset(
                  //   'assets/lalibela2.jpg',
                  //   width: 80,
                  //   height: 80,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

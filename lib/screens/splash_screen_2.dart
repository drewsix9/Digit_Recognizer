import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:baybayin_character_recognition/screens/draw_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(seconds: 3),
      nextScreen: const DrawScreen(),
      backgroundColor: Colors.black,
      splashScreenBody: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ba y ba y in',
              style: TextStyle(
                fontFamily: 'Bagwis_Baybayin_font',
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'BAYBAYIN',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 36,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color(0xFFDFB555),
                            Color(0xFFF5D895),
                            Color(0xFFC9BDA3),
                            Color(0xFFD5AD52),
                          ],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                  TextSpan(
                    text: 'SIGHT',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Color(0xFFDFB555),
                            Color(0xFFF5D895),
                            Color(0xFFC9BDA3),
                            Color(0xFFD5AD52),
                          ],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:baybayin_character_recognition/screens/draw_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const DrawScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Center(
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
      ),
    );
  }
}

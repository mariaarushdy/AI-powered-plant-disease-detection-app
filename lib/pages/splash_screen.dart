import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_application_1/pages/welcome.dart';
class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      backgroundColor: const Color.fromARGB(245, 226, 223, 210), // Set background color to #bcbeb9
      childWidget: Stack(
        children: [
          Align(    
          alignment: const Alignment(0.0,-0.1),
          child: SizedBox(
            height: 350,
            child: Image.asset(
              'assets/drone_logo.png',
            ), // Replace with your app's logo
          ),
          ),
          Align(
            alignment: const Alignment(0.0,0.35),
            child: Text(
              'PlantCare', // Replace with your company name
              style: GoogleFonts.oswald(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 13, 43, 2),
                ),
            ),
          ),
        ], 
      ),
      duration: const Duration(milliseconds: 2000),
      animationDuration: const Duration(milliseconds: 1000),
      onAnimationEnd: () => debugPrint("On Scale End"),
      nextScreen:const WelcomePage(), // Replace with your main app screen
    );
  }
}
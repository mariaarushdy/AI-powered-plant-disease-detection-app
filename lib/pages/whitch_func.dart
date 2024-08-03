import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for using a fancy font
import 'package:flutter_application_1/pages/my_home_page.dart';
import 'package:flutter_application_1/pages/drone_firebase.dart';

class Sysfunc extends StatefulWidget {
  const Sysfunc({super.key});

  @override
  State<Sysfunc> createState() => _SysfuncState();
}

class _SysfuncState extends State<Sysfunc> {
  void mobile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const MyHomePage()),
  );
}
  void drone(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const Drone()),
  );
}
  // Add a variable to store the picked image
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(245, 218, 216, 203),
      ),
      backgroundColor:const Color.fromARGB(245, 226, 223, 210),

      body: Center(
        // Wrap the entire content with Center
        // Allow content to scroll if it overflows
          //padding: const EdgeInsets.all(20.0), // Add some padding
          child: Stack(
            children:[
              Align(
                alignment: const Alignment(0.0,-0.7),
              child: Text(
                "PlantCare\n",
                style: GoogleFonts.oswald(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 13, 43, 2),
                ),
              ),
              ),
              const Align(
              alignment: Alignment(0.0,-0.5),
              child:  Image(
                image: AssetImage('assets/drone_logo.png'), // Replace with your image path
                height: 200.0, // Adjust image height as needed
              ),
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: const Alignment(0.0,0.1),
              child:Text(
                "Your Comprehensive Plant Health \nMonitoring Solution!",
                style: GoogleFonts.openSans(
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 13, 43, 2),
                ),
                textAlign: TextAlign.center,
              ),
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: const Alignment(0.0,0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => mobile(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(150, 50),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('Plant Classification'),
                  ),

                  const SizedBox(width: 10.0),

                  ElevatedButton(
                    onPressed: () => drone(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(150, 50),
                      ),

                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('Drone Monitoring'),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
    );
  }
}
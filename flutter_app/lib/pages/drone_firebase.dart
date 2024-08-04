import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for usi
import 'package:flutter_application_1/pages/autopilot.dart';
import 'package:flutter_application_1/pages/video_stream.dart';
import 'package:flutter_application_1/pages/database_img.dart';
import 'package:flutter_application_1/pages/selected_area.dart';
class Drone extends StatefulWidget {
  const Drone({super.key});
  @override
  State<Drone> createState() => _DroneState();
}

class _DroneState extends State<Drone> {
  void databaseImg(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const DatabaseImg()),
  );
}
  void videoStreem(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const VideoStream()),
  );
}
  void waypoints(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const Autopilot()),
  );
}
  void selected(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>const SelectedArea()),
  );
}
  // Add a variable to store the picked image
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drone Monitoring") ,
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
                "Drone Monitoring\n",
                style: GoogleFonts.oswald(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 13, 43, 2),
                ),
              ),
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: const Alignment(0.0,-0.5),
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
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => waypoints(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(170, 60),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('Autopilot'),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => selected(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(170, 60),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('select area'),
                  ),

                  const SizedBox(height: 20.0),
                   
                  ElevatedButton(
                    onPressed: () => videoStreem(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(170, 60),
                      ),
                      
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('Camera Stream'),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => databaseImg(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 13, 43, 2),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(170, 60),
                      ),
                      
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Text('Images Classification'),
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
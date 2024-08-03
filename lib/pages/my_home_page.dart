import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for using a fancy font
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/pages/second_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Add a variable to store the picked image
  XFile? pickedImage;

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery, // Change this to camera if needed
    );
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
      // Navigate to a new screen here with the picked image
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(image: pickedImage!)),
      );
    }
  }

  Future<void> takeImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera, // This is already set for camera
    );
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
      // Navigate to a new screen here with the picked image
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(image: pickedImage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(245, 218, 216, 203),
      ),
      backgroundColor: const Color.fromARGB(245, 226, 223, 210),

      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -0.7),
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
              alignment: Alignment(0.0, -0.5),
              child: Image(
                image: AssetImage('assets/drone_logo.png'),
                height: 200.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: const Alignment(0.0, 0.1),
              child: Text(
                "Please only enter images of Plants",
                style: GoogleFonts.openSans(
                  fontSize: 16.0,
                  color: const Color.fromARGB(255, 13, 43, 2),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: const Alignment(0.0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo_library),
                    label: Text('Pick Image'),
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 43, 2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Image'),
                    onPressed: takeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 13, 43, 2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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
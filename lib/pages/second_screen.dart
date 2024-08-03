import 'package:flutter_application_1/components/button.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

class SecondScreen extends StatefulWidget {
  final XFile? image;

  const SecondScreen({super.key, required this.image});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  //List<dynamic>? _recognitions;

  @override
  void initState() {
    super.initState();
    //loadModel();
  }

  void showAlertBox(String plantClass) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 13, 43, 2),
            title: const Text(
          'Result',
          style: TextStyle(
            color: Color.fromARGB(255, 133, 220, 152), // Set the text color to orange
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
            content: Text(
              'Input Image Is A $plantClass ',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 133, 220, 152)), // Set background color
                ),
                child:const Text(
                    'Okay',
                    style: TextStyle(
                           color: Colors.white,
                           fontSize: 18,
                           fontWeight: FontWeight.bold,), // Set text color to white
                    
                  ),
              ),
            ],
          );
        });
  }

  // Function to normalize the input image
  static Float32List normalizeInput(Uint8List inputImage) {
    int numPixels = inputImage.length;
    Float32List normalizedInput = Float32List(numPixels);
    for (int i = 0; i < numPixels; i++) {
      normalizedInput[i] = inputImage[i] / 1;
    }
    return normalizedInput;
  }

  Future<void> loadModel() async {
    try {
      // final interpreter =
      //     await tfl.Interpreter.fromAsset('assets/model_ver2.tflite');
      final interpreter =
          await Interpreter.fromAsset('assets/converted_model_plant.tflite');
      interpreter.allocateTensors();
      //var input = File(widget.image!.path).readAsBytesSync();

      // Process the image file and convert it to (224 x 224) as input
      img.Image? image =
          img.decodeImage(File(widget.image!.path).readAsBytesSync());
      img.Image resizedImage = img.copyResize(image!, width: 224, height: 224);
      Uint8List inputImage = resizedImage.getBytes();

      // Perform the classification
      Float32List normalizedInput = normalizeInput(inputImage);
      var input =
          normalizedInput.buffer.asFloat32List().reshape([1, 224, 224, 3]);
      var output = List.filled(39, 0.0).reshape([1, 39]);
      print("model outputttttttttttttttttttt");
      
      interpreter.run(input, output);
      print(output);
      double maximumValue = 0;
      int maxIndex = -1;
      String plantClass;
      for (int i = 0; i < output[0].length; i++) {
        if (output[0][i] > maximumValue) {
          maximumValue = output[0][i];
          maxIndex = i;
        }
      }
      
      
       List plantTypes = ["Apple scab","Apple Black rot","Apple Cedar apple rust","Apple healthy", "Background without leaves", "Blueberry healthy", "Cherry healthy","Cherry Powdery mildew","Corn Cercospora leaf spot Gray leaf spot", "Corn Common rust","Corn healthy", "Corn Northern Leaf Blight","Grape Black rot", "Grape Esca (Black Measles)","Grape healthy", "Grape Leaf blight (Isariopsis Leaf Spot)","Orange Haunglongbing (Citrus greening)","Peach Bacterial spot", "Peach healthy","Pepper, bell Bacterial spot", "Pepper, bell healthy", "Potato Early blight","Potato healthy","Potato Late blight","Raspberry healthy", "Soybean healthy","Squash Powdery mildew","Strawberry healthy","Strawberry Leaf scorch", "Tomato Bacterial spot", "Tomato Early blight","Tomato healthy", "Tomato Late blight", "Tomato Leaf Mold","Tomato Septoria leaf_spot","Tomato Spider mites Two-spotted spider mite","Tomato Target Spot","Tomato Tomato mosaic virus","Tomato Tomato Yellow Leaf Curl Virus"
      ];
      plantClass = plantTypes[maxIndex];
      showAlertBox(plantClass);

      // setState(() {
      //   _recognitions = output;
      // });
      interpreter.close();
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(245, 218, 216, 203),
        title: const Text('Result & Recovery'),
      ),
      backgroundColor: const Color.fromARGB(245, 218, 216, 203),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 13, 43, 2),
                  borderRadius: BorderRadius.circular(12)),
              height: 250,
              width: double.infinity,
              child: widget.image != null
                  ? Expanded(
                      child: Image.file(
                        File(widget.image!.path),
                      ),
                    )
                  : const Text('No image available'),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: MyButton(text: 'SCAN', onPressed: loadModel)),

            const SizedBox(height: 20),
            // if (_recognitions != null)
            //   Column(
            //     children: _recognitions!.map<Widget>((res) {
            //       return Text(
            //           '${res['label']}: ${res['confidence'].toStringAsFixed(2)}');
            //     }).toList(),
            //   ),
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';


Future<List<Reference>?> getUsersUplodedFiles() async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final uploads = await storageRef.listAll();
    return uploads.items;
  } catch (e) {
    print(e);
  }
  return null;
}

Float32List normalizeInput(Uint8List inputImage) {
    int numPixels = inputImage.length;
    Float32List normalizedInput = Float32List(numPixels);
    for (int i = 0; i < numPixels; i++) {
      normalizedInput[i] = inputImage[i] / 1;
    }
    return normalizedInput;
  }

  Future<String> loadModel(Uint8List leafimg) async {
    try {
      final interpreter =
          await Interpreter.fromAsset('assets/converted_model_plant.tflite');
      interpreter.allocateTensors();

      // Process the image file and convert it to (224 x 224) as input
      img.Image? image = img.decodeImage(leafimg);
      if (image == null) throw Exception('Failed to decode image');

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      Uint8List inputImage = resizedImage.getBytes();

      // Perform the classification
      Float32List normalizedInput = normalizeInput(inputImage);
      var input =
          normalizedInput.buffer.asFloat32List().reshape([1, 224, 224, 3]);
      var output = List.filled(39, 0.0).reshape([1, 39]);

      interpreter.run(input, output);
      double maximumValue = 0;
      int maxIndex = -1;
      String plantClass;
      for (int i = 0; i < output[0].length; i++) {
        if (output[0][i] > maximumValue) {
          maximumValue = output[0][i];
          maxIndex = i;
        }
      }

      List plantTypes = [
        "Apple scab",
        "Apple Black rot",
        "Apple Cedar apple rust",
        "Apple healthy",
        "Background without leaves",
        "Blueberry healthy",
        "Cherry healthy",
        "Cherry Powdery mildew",
        "Corn Cercospora leaf spot Gray leaf spot",
        "Corn Common rust",
        "Corn healthy",
        "Corn Northern Leaf Blight",
        "Grape Black rot",
        "Grape Esca (Black Measles)",
        "Grape healthy",
        "Grape Leaf blight (Isariopsis Leaf Spot)",
        "Orange Haunglongbing (Citrus greening)",
        "Peach Bacterial spot",
        "Peach healthy",
        "Pepper, bell Bacterial spot",
        "Pepper, bell healthy",
        "Potato Early blight",
        "Potato healthy",
        "Potato Late blight",
        "Raspberry healthy",
        "Soybean healthy",
        "Squash Powdery mildew",
        "Strawberry healthy",
        "Strawberry Leaf scorch",
        "Tomato Bacterial spot",
        "Tomato Early blight",
        "Tomato healthy",
        "Tomato Late blight",
        "Tomato Leaf Mold",
        "Tomato Septoria leaf_spot",
        "Tomato Spider mites Two-spotted spider mite",
        "Tomato Target Spot",
        "Tomato Tomato mosaic virus",
        "Tomato Tomato Yellow Leaf Curl Virus"
      ];
      plantClass = plantTypes[maxIndex];

      interpreter.close();
      return plantClass;
    } catch (e) {
      print('Error during model inference: $e');
      return "Error";
    }
  }

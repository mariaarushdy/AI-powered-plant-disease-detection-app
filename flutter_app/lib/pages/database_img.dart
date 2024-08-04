import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
String? txtClas = "";

class DatabaseImg extends StatefulWidget {
  const DatabaseImg({super.key});

  @override
  State<DatabaseImg> createState() => _DatabaseImgState();
}

class _DatabaseImgState extends State<DatabaseImg> {
  List<Reference> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    getUploadedFiles();
  }

  void getUploadedFiles() async {
    List<Reference>? result = await getUsersUplodedFiles();
    if (result != null) {
      setState(() {
        _uploadedFiles = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text(
          "Firebase Storage",
        ),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(245, 218, 216, 203),
      ),
      backgroundColor:const Color.fromARGB(245, 226, 223, 210),
      
      body: _buildUI(),
    );
  }

  Future<Uint8List> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image');
    }
  }

  Future<String> classifyImage(String imageUrl) async {
    try {
      Uint8List imageData = await downloadImage(imageUrl);
      return await loadModel(imageData);
    } catch (e) {
      print('Error processing image: $e');
      return "Error";
    }
  }

  void showImageDialog(BuildContext context, String imageUrl, String txtClas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color.fromARGB(255, 93, 154, 69), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("$txtClas",
                style: GoogleFonts.oswald(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                ),
                
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUI() {
    if (_uploadedFiles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Sort the files based on their names
    _uploadedFiles.sort((a, b) => a.name.compareTo(b.name));
    int x = 0;
    for (int i = 0; i < _uploadedFiles.length; i++) {
      if (_uploadedFiles[i].name != "10.JPG") {
        x++;
        print(_uploadedFiles[i].name);
      } else {
        break;
      }
    }
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : ");
    print(x);
    x =4;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Dynamically set based on image names
        childAspectRatio: 1.0,
      ),
      itemCount: _uploadedFiles.length,
      itemBuilder: (context, index) {
        Reference ref = _uploadedFiles[index];
        return FutureBuilder<String>(
          future: ref.getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading image'));
            } else if (snapshot.hasData) {
              return GestureDetector(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    FutureBuilder<String>(
                      future: classifyImage(snapshot.data!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Classifying...');
                        } else if (snapshot.hasError) {
                          return const Text('Error classifying image');
                        } else {
                          txtClas = snapshot.data;
                          return Text(snapshot.data!);
                        }
                      },
                    ),
                  ],
                ),
                onTap: () =>
                    showImageDialog(context, snapshot.data!, '$txtClas'),
              );
            } else {
              return const Center(child: Text('No URL available'));
            }
          },
        );
      },
    );
  }
}
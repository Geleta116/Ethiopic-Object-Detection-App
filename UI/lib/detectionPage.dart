import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class DetectionPage extends StatefulWidget {
  final File? croppedImage;

  const DetectionPage({Key? key, this.croppedImage}) : super(key: key);

  @override
  _DetectionPageState createState() => _DetectionPageState();
}

class DetectedObject {
  final String name;
  final String description;

  DetectedObject(this.name, this.description);

  factory DetectedObject.fromJson(Map<String, dynamic> json) {
    return DetectedObject(
      json['name'] ?? '',
      json['description'] ?? '',
    );
  }
}

class _DetectionPageState extends State<DetectionPage> {
  late Future<List<DetectedObject>> results;
  String? newImageFilename;

  @override
  void initState() {
    super.initState();
    if (widget.croppedImage != null) {
      results = sendImageToServer(widget.croppedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detection Page'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<DetectedObject>>(
                future: results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Display the processed image
                    return Column(
                      children: [
                        Container(
                          height: 300.0, // Adjust the height based on your needs
                          child: Image.network(
                            'http://192.168.133.126:5000/get_image/$newImageFilename',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          'Objects Detected:',
                          style: TextStyle(fontSize: 18),
                        ),
                        // Use a ListView.builder for the detected objects
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var object = snapshot.data![index];
                            return Column(
                              children: [
                                Text(
                                  '- ${object.name}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                buildItemWidget(object.name),
                                const SizedBox(height: 10.0),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Text('No image URL available');
                  }
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> rotateImage(File imgFile, int degrees) async {
    // Read the image file
    img.Image image = img.decodeImage(await imgFile.readAsBytes())!;

    // Rotate the image
    img.Image rotatedImage = img.copyRotate(image, angle: degrees);

    // Save the rotated image to a new file
    File rotatedFile = File('${imgFile.path}_rotated_$degrees.jpg');
    await rotatedFile.writeAsBytes(img.encodeJpg(rotatedImage));

    return rotatedFile;
  }

  Future<List<DetectedObject>> sendImageToServer(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.133.126:5000'),
      );
      print("has posted");

      File rotatedImage = await rotateImage(imageFile, 360);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Update the field name to match your server
          rotatedImage.path,
        ),
      );
      print("has added file");
      var response = await request.send();

      if (response.statusCode == 200) {
        print("success 1");
        var responseData = await response.stream.bytesToString();
        Map<String, dynamic> result = json.decode(responseData);
        print("success 2");
        newImageFilename = result['image_path']
            as String; // Receive the filename from the server
        List<String> namesList = (result['names'] as List).cast<String>();
        List<DetectedObject> detectedObjects = namesList.map((name) {
          return DetectedObject(
              name, ''); // Provide a description or handle it as needed
        }).toList();

        return detectedObjects;
      } else {
        throw 'Failed to upload image. Status code: ${response.statusCode}';
      }
    } catch (error) {
      throw 'Error uploading image: $error';
    }
  }
}

Widget buildItemWidget(String key) {
  switch (key) {
    case 'Jebena':
      return Column(
        children: [
          Image.asset('assets/jebena.png', width: 80, height: 80,), // Replace with the actual image path and adjust size
          SizedBox(height: 8), // Add some space between image and text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'A Jebena is a traditional Ethiopian coffee pot used in the Ethiopian coffee ceremony. It is typically made from clay or ceramic, contributing to the unique flavor of the coffee produced in the ceremony. The Jebena features a round bottom, a long neck, and a spout for pouring. Adorned with decorative motifs, the Jebena is a key element in the rich cultural heritage of Ethiopia. Used in the coffee ceremony, it facilitates the multi-step process of roasting, grinding, and brewing coffee to create a strong and flavorful beverage. The ceremony itself symbolizes hospitality, community, and social connection in Ethiopian culture.',
              style: TextStyle(fontSize: 14, color: Colors.black87), // Adjust font size and color
              textAlign: TextAlign.justify, // Justify text for a cleaner look
            ),
          ),
        ],
      );
    case 'Sini':
      return Column(
        children: [
          Image.asset('assets/Sini.jpg', width: 80, height: 80,), // Replace with the actual image path and adjust size
          SizedBox(height: 8), // Add some space between image and text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'The "Sini" is a vital component in the Ethiopian coffee ceremony, serving as a traditional serving tray or platter. Crafted from materials such as wood, metal, or woven materials, the Sini is often round or oval-shaped with raised edges and adorned with intricate designs. Its primary function is to hold small handle-less cups, known as "cini" or "fincan," during the coffee ceremony. Positioned alongside the central element, the "Jebena," on the Sini, freshly brewed coffee is poured into the cups, fostering a communal experience. Beyond its practical use, the Sini symbolizes the communal and social aspects of coffee consumption, embodying hospitality, friendship, and shared traditions in Ethiopian culture.',
              style: TextStyle(fontSize: 14, color: Colors.black87), // Adjust font size and color
              textAlign: TextAlign.justify, // Justify text for a cleaner look
            ),
          ),
        ],
      );
    default:
      return Text('Unknown Item');
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fla_app_2/Screens/CameraPage.dart';
import 'package:fla_app_2/Screens/FoodResult.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Log App')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraPage(cameras: value))));
                    },
                    icon: const Icon(Icons.close)),
                IconButton(
                    onPressed: () => {
                          uploadImage('input.jpeg'),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FoodResult()),
                          )
                        },
                    icon: const Icon(Icons.check)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future uploadImage(String title) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://18.223.74.63:8000/api/images/"));
    //request.fields['title'] = "Input.jpg";
    //request.headers['Authorization'] = "";
    debugPrint(picture.path);
    var file = File(picture.path);
    var image = await http.MultipartFile.fromPath('image', file.path);
    request.files.add(image);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    debugPrint(result);
  }
}

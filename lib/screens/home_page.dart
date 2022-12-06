import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:capstone_draft_flutter/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  pickImageFromGallery() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
      });
    } else {
      print('No image selected');
    }
  }

  pickImageFromCamera() async {
    var _image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 256,
        maxWidth: 256,
        imageQuality: 80);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
      });
    } else {
      print('No image captured');
    }
  }

  onUploadImage(File img) async {
    // log('${img.path}', name: 'file-name');
    var request = http.MultipartRequest(
      'POST',
      // Uri.parse('https://techfarmtest.herokuapp.com/upload'),
      // Uri.parse('http://10.0.2.2:8080/upload'),
      Uri.parse(
          'http://ec2-54-153-53-185.us-west-1.compute.amazonaws.com:8080/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('image', img.path),
    );
    var res = await request.send();
    print('------------------------------------------------------');
    log('${res.statusCode}', name: 'POST-request-statusCode');
    log('${res.reasonPhrase}', name: 'POST-request-status');
    print('------------------------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100.0),
              height: 256,
              width: 256,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Center(
                child: image != null
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(
                              image!.readAsBytesSync() as Uint8List,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Image preview',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[600],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('Camera option is selected.');
                      pickImageFromCamera();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1.0,
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[600],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      print('Gallery option clicked.');
                      pickImageFromGallery();
                    },
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
              height: 70.0,
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.lightGreen[600],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextButton(
                onPressed: () async {
                  await onUploadImage(image!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return ResultPage(
                          selectedImage: image!,
                        );
                      }),
                    ),
                  );
                },
                child: const Center(
                  child: Text(
                    'Predict',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

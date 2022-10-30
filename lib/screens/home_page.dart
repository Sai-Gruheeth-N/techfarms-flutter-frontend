import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:capstone_draft_flutter/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:capstone_draft_flutter/SharedPreferences.dart';
// import 'package:capstone_draft_flutter/screens/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  // SharedPreference _pref = SharedPreference();

  // pickImage(ImageSource source) async {
  //   final ImagePicker picker = ImagePicker();
  //   XFile? file = await picker.pickImage(source: source);
  //   if (file != null) {
  //     return file.readAsBytes();
  //   } else {
  //     throw Exception('No image selected');
  //     // print('No image selected.');
  //   }
  // }

  pickImageFromGallery() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
        // _pref.saveImage(image);
      });
    } else {
      print('No image selected');
    }
  }

  pickImageFromCamera() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (_image != null) {
      setState(() {
        image = File(_image.path);
        // _pref.saveImage(image);
      });
    } else {
      print('No image captured');
    }
  }

  onUploadImage(File img) async {
    // log('${img.path}', name: 'file-name');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5000/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('image', img.path),
    );
    var res = await request.send();
    log(res.reasonPhrase!);

    // var request = http.get(Uri.parse('0.0.0.0:5000/'));
    // var request = http.MultipartRequest(
    //   'POST',
    //   Uri.parse('0.0.0.0:5000/'),
    // );
    // Map<String, String> headers = {"Content-type": "multipart/form-data"};
    // request.files.add(
    //   http.MultipartFile(
    //     widget.selectedImage.toString(),
    //     widget.selectedImage.readAsBytes().asStream(),
    //     widget.selectedImage.lengthSync(),
    //     filename: widget.selectedImage.path.split('/').last,
    //   ),
    // );
    // request.headers.addAll(headers);
    // log("${request.files.first}", name: 'Request-files');
    // log("Request : ${request.toString()}", name: "Request");
    // print('sending');
    // var res = await request.send();
    // print('sent');
    // var response = await http.get(Uri.parse('http://10.0.2.2:5000/'));
    // log('${response.statusCode}', name: 'API-Response-StatusCode');
    // var data = jsonDecode(response.body);
    // return data;
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

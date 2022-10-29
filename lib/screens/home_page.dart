import 'dart:io';
import 'dart:typed_data';
import 'package:capstone_draft_flutter/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:image_picker/image_picker.dart';
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
    setState(() {
      image = File(_image!.path);
      // _pref.saveImage(image);
    });
  }

  pickImageFromCamera() async {
    var _image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = File(_image!.path);
      // _pref.saveImage(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                image!.readAsBytesSync() as Uint8List),
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
                onPressed: () {
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

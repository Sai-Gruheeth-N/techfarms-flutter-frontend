import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:http_parser/http_parser.dart';

class ResultPage extends StatefulWidget {
  File selectedImage;
  ResultPage({super.key, required this.selectedImage});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  predict() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:5000/predict'));
    log('${response.statusCode}', name: 'API-Response-StatusCode');
    var data = jsonDecode(response.body);
    return data;
  }
  // onUploadImage() async {
  //   var postUri = Uri.parse('https://techfarmtest.herokuapp.com/upload');
  //   var request = http.MultipartRequest('POST', postUri);
  //   // request.fields['image'] = widget.selectedImage.path;
  //   request.files.add(
  //     http.MultipartFile();
  //   );
  //   // http.MultipartFile.fromBytes('file', await File.fromRawPath(widget.selectedImage as Uint8List).readAsBytes(), contentType: MediaType('image', 'jpg'),);
  //   // var multipart = http.MultipartFile();
  // }

  // Future<Map> getData() async {
  //   final String response = await rootBundle.loadString('assets/sample.json');
  //   Map data = json.decode(response);
  //   return data;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: FutureBuilder(
        future: predict(),
        builder: (context, snapshot) {
          log('${snapshot.data}', name: 'SnapShot data');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Result(data: snapshot.data as Map);
            } else if (snapshot.hasError) {
              print('snapshot contains no data');
              return const Center(
                child: Text('Empty'),
              );
            }
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class Result extends StatelessWidget {
  const Result({super.key, required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 75.0),
            // child: Image.asset(data['result']),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                data['result'],
                // data['label'],
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

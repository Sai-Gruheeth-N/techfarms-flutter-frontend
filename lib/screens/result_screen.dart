import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class ResultPage extends StatefulWidget {
  File selectedImage;
  ResultPage({super.key, required this.selectedImage});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  onUploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://techfarmtest.herokuapp.com/upload'),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        widget.selectedImage.toString(),
        widget.selectedImage.readAsBytes().asStream(),
        widget.selectedImage.lengthSync(),
        filename: widget.selectedImage.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    // log("${request.contentLength}", name: 'Request-contentLength');
    log("Request : ${request.toString()}", name: "Request");
    print('sending');
    var res = await request.send();
    print('sent');
    http.Response response = await http.Response.fromStream(res);
    log('${response.statusCode}', name: 'API-Response-StatusCode');
    var data = jsonDecode(response.body);
    return data;
  }

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
        future: onUploadImage(),
        builder: (context, snapshot) {
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
            child: Image.asset(data['sample']),
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
                data['label'],
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

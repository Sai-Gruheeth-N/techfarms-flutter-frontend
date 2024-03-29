import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';

class ResultPage extends StatefulWidget {
  File selectedImage;
  ResultPage({super.key, required this.selectedImage});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  predict(String fileName) async {
    final String file = fileName.split('/').last;
    // final response = await http
    //     .get(Uri.parse('https://techfarmtest.herokuapp.com/predict/$file'));
    // final response =
        // await http.get(Uri.parse('http://10.0.2.2:8080/predict/$file'));
    final response = await http.get(Uri.parse(
        'http://ec2-54-153-53-185.us-west-1.compute.amazonaws.com:8080/predict/$file'));
    var data = jsonDecode(response.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: FutureBuilder(
        future: predict(widget.selectedImage.path),
        builder: (context, snapshot) {
          log('${snapshot.data}', name: 'SnapShot data');
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Result(data: snapshot.data as Map);
            } else if (snapshot.hasError) {
              print('snapshot contains no data');
              return const Center(
                child: Text('Something went wrong'),
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
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            child: Image(
              image: NetworkImage(
                  'https://techfarmstest.s3.us-west-1.amazonaws.com/${data['Sample']}'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Result : ${data['Label']}',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: (data['Label'].toString().contains('Healthy') |
                      data['Label'].toString().contains('healthy'))
                  ? Colors.green
                  : Colors.red,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                (data['Label'].toString().contains('Healthy') |
                        data['Label'].toString().contains('healthy'))
                    ? 'Status : Healthy'
                    : 'Status : Diseased',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w500),
              ),
            ),
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
                'Confidence : ${double.parse(data['Confidence']) * 100}%',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

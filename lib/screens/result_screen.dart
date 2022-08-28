import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Future<Map> getData() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    Map data = json.decode(response);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Result(data: snapshot.data as Map);
          }
          if (snapshot.hasError) {
            print('snapshot contains no data');
            return const Center(
              child: Text('Empty'),
            );
          } else {
            return const CircularProgressIndicator();
          }
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

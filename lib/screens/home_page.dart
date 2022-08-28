import 'package:capstone_draft_flutter/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_draft_flutter/appBar/main_appbar.dart';
// import 'package:capstone_draft_flutter/screens/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  primary: Colors.green[600]),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return const ResultPage();
                    }),
                  ),
                );
              },
              child: const Text(
                'Click here to capture image.',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

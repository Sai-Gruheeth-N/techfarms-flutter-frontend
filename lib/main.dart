import 'package:flutter/material.dart';
import 'package:capstone_draft_flutter/screens/welcome_screen.dart';

void main() => runApp(const TechFarms());

class TechFarms extends StatelessWidget {
  const TechFarms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2.0,
          shadowColor: Colors.grey[900],
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

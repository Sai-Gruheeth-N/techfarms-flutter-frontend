import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  getImage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.getString('image');
  }

  saveImage(File? image) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('image', image!.toString());
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RealDBProvider with ChangeNotifier {
  var database = FirebaseDatabase.instance.ref("User");

  void addData(String text) {
    database.child("name").set(text);
  }
}

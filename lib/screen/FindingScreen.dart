import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class FindingScreen extends StatefulWidget {
  const FindingScreen({Key? key}) : super(key: key);

  @override
  State<FindingScreen> createState() => _FindingScreenState();
}

class _FindingScreenState extends State<FindingScreen> {
  DatabaseReference onlineRef = FirebaseDatabase.instance.ref("Online");
  FirebaseAuth auth  = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initStat
    // make user online
    Map<String,String> map = {"${auth.currentUser?.uid}":"${auth.currentUser?.email}"};
    onlineRef.set(map).then((value) => {
      Fluttertoast.showToast(msg: "you are online")
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
         await onlineRef.child('${auth.currentUser?.uid}').remove().then((value) => {
           Fluttertoast.showToast(msg: "out of game")
         });
         return true;
      },
      child: Scaffold(
        body: Center(
          child:  Lottie.network(
              'https://assets1.lottiefiles.com/packages/lf20_8zr8zyt5.json'),
        ),
      ),
    );
  }

}

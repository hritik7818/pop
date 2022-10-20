import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/RoomScreen.dart';
import 'package:pop/screen/play_online.dart';
import 'package:pop/screen/play_with_ai.dart';
import 'package:pop/screen/two_player.dart';

import 'FindingScreen.dart';
import 'login.dart';

class JoinRoomScreen extends StatefulWidget {
  JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 166, 56, 56),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "P",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 30.h,
                ),
                const Text(
                  "0",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(
                  width: 30.h,
                ),
                const Text(
                  "P",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 90,
                      color: Colors.blue),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text != '') {
                  joinRoom(context, controller.text);
                } else {
                  Fluttertoast.showToast(msg: "Enter game code");
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240.w, 50.h),
                backgroundColor: const Color.fromARGB(255, 255, 230, 0),
              ),
              child: const Text(
                "JOIN ROOM",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> joinRoom(BuildContext context, String gameID) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/$gameID");

    ref.once().then((value) async => {
          if (value.snapshot.exists)
            {
              await ref.update({"player2": "Hritik"}).then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoomScreen(gameID: gameID,userType: 'JOIN',),));
              })
            }
          else {Fluttertoast.showToast(msg: "not room exists")}
        });
  }
}

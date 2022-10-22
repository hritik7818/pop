import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/onlineGame/RoomScreen.dart';
import 'package:pop/screen/LoginScreen.dart';
import 'package:pop/screen/play_with_ai.dart';
import 'package:pop/screen/two_player.dart';

import '../FindingScreen.dart';
import '../login.dart';

class JoinRoomScreen extends StatefulWidget {
  String tag;
  JoinRoomScreen({required this.tag});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  TextEditingController room_code_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();

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
            widget.tag=='JOIN ROOM'?Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: room_code_controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      label: Text("Enter room code"),
                      labelStyle: TextStyle(color: Colors.white),
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
              ],
            ):SizedBox(),
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                controller: name_controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  label: Text("Enter your name"),
                  labelStyle: TextStyle(color: Colors.white),
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
                FocusManager.instance.primaryFocus?.unfocus();
                if(widget.tag=='JOIN ROOM'){
                  if (room_code_controller.text.trim() != '' && name_controller.text.trim() != '') {
                    joinRoom(context, room_code_controller.text,name_controller.text);
                    // Fluttertoast.showToast(msg: "all ok ");
                  } else {
                    Fluttertoast.showToast(msg: "Enter all fields");
                  }
                }else{
                  if ( name_controller.text.trim() != '') {
                    createRoom(context,name_controller.text);

                  } else {
                    Fluttertoast.showToast(msg: "Enter name");
                  }

                }


              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240.w, 50.h),
                backgroundColor: const Color.fromARGB(255, 255, 230, 0),
              ),
              child:  Text(
                widget.tag,
                style: const TextStyle(
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

  Future<void> joinRoom(BuildContext context, String gameID,String name) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/$gameID");

    ref.once().then((value) async => {
          if (value.snapshot.exists)
            {
              await ref.update({"player2": name}).then((value){
                room_code_controller.text = "";
                name_controller.text = "";
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  RoomScreen(gameID: gameID,userType: 'JOIN',),));
              })
            }
          else {Fluttertoast.showToast(msg: "not room exists")}
        });
  }

  Future<void> createRoom(BuildContext context,String name) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms");
    String gameKey = "123";
    Map<String, String>  map = {
      "move":",,,,,,,,",
      "player1":name,
      "player2":"Waiting...",
      "turn":"P",
      'winner':"N/A",
      'isStart':"NO",

    };
    await ref.child(gameKey).set(map);
    name_controller.text = "";

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        RoomScreen(gameID: gameKey,userType: "CREATE",),));
  }
}

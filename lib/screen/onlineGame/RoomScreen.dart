import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/onlineGame/onlinePlay.dart';

class RoomScreen extends StatefulWidget {
  RoomScreen({required this.gameID, required this.userType});
  String gameID;
  String userType;
  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms");
  bool flag = false;

  @override
  void initState() {
    super.initState();
    onBack();
    sendToGameScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ref.child(widget.gameID).remove();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 166, 56, 56),
          title: const Text("Room",style: TextStyle(color: Colors.white),),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ROOM CODE: ${widget.gameID}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        FlutterClipboard.copy(widget.gameID).then(
                            (value) => Fluttertoast.showToast(msg: "copied"));
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              StreamBuilder(
                  stream: ref.child(widget.gameID.toString()).onValue,
                  builder: (context, snapshot) {
                    // Map<dynamic, dynamic> map = snapshot.data?.snapshot.value as dynamic;
                    // print(map);
                    DataSnapshot? data = snapshot.data?.snapshot;
                    String? player2 = data?.child("player2").value.toString().trim();

                    return snapshot.data != null
                        ? Column(
                          children: [
                            Row(
                                children: [
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Image.asset(
                                        "images/icon${randomNoGeneratorInRange(1, 9)}.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        data!.child("player1").value.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "VS",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Image.asset(
                                        "images/icon${randomNoGeneratorInRange(1, 9)}.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        data.child("player2").value.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            const SizedBox(
                              height: 50,
                            ),
                            (widget.userType == 'CREATE') ? ElevatedButton(
                              onPressed: player2 !="Waiting..."?() {
                                startGame();
                              }:null,
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(240.w, 50.h),
                                backgroundColor: player2 =="Waiting..."?Colors.grey:const Color.fromARGB(255, 255, 230, 0),
                              ),
                              child:  Text(
                                player2 =="Waiting..."?"Waiting...":"START GAME",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ) : const SizedBox()
                          ],
                        )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void onBack() {
    ref.child(widget.gameID.toString()).onValue.listen((event) {
      if (event.snapshot.value == null) {
        Navigator.pop(context);
      }
    });
  }

  void sendToGameScreen() {
    ref.child("${widget.gameID}/isStart").onValue.listen((event) {
      if (event.snapshot.value.toString() == 'YES') {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => OnlinePlay(gameID: widget.gameID, usrType: widget.userType,),
            ));
      }
    });
  }

  Future<void> startGame() async {
    Map<String, String> map = {
      "isStart": "YES",
    };
    await ref.child(widget.gameID.toString()).update(map);
  }
  int randomNoGeneratorInRange(int min, int max){
    Random rnd;
    rnd = Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }
}

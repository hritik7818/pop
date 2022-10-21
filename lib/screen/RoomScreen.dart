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

  @override
  void initState() {
    super.initState();
    onBack();
    gameStarter();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ref.child(widget.gameID).remove();
        return true;
      },
      child: Scaffold(
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
                    return snapshot.data != null
                        ? Row(
                            children: [
                              const Spacer(),
                              Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.white,
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
                                  Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.white,
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
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                  }),
              const SizedBox(
                height: 50,
              ),
              (widget.userType == 'CREATE')
                  ? ElevatedButton(
                      onPressed: () {
                        startGame();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(240.w, 50.h),
                        backgroundColor: const Color.fromARGB(255, 255, 230, 0),
                      ),
                      child: const Text(
                        "START GAME  ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : const SizedBox()
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

  void gameStarter() {
    ref.child("${widget.gameID}/isStart").onValue.listen((event) {
      if (widget.userType == 'JOIN' &&
          event.snapshot.value.toString() == 'YES') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OnlinePlay(gameID: widget.gameID),
            ));
      }
    });
  }

  Future<void> startGame() async {
    Map<String, String> map = {
      "isStart": "YES",
    };
    await ref.child(widget.gameID.toString()).update(map);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnlinePlay(
            gameID: widget.gameID,
          ),
        ));
  }
}

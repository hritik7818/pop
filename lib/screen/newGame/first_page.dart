import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pop/screen/newGame/choose_page.dart';
import 'package:socket_io_client/socket_io_client.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String text = "";

  late Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });

          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ChoosePage(
                      text: 'ai',
                      gameId: "",
                      userType: "",
                    )),
          );
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  late Socket socket;
  String status = "connecting...";
  String message = "message";
  String partner = "message";
  String game = "message";
  String testUrl = 'http://localhost:3003/';
  String serverUrl = 'https://limitless-meadow-86321.herokuapp.com/';
  String testonPhone = 'http://10.0.0:3003/';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();

    socket.disconnect();
  }

  void initializeSocket() {
    //SOCKET EVENTS
    // --> listening for connection
    socket.on('connect', (data) {
      socket.emit("add user", "rahul");
      setState(() {
        status = "connected ${socket.id}";
      });
    });

    //listen for incoming messages from the Server.
    socket.on('message', (data) {
      Map<dynamic, dynamic> map = data;
      setState(() {
        message = map["someProperty"] ?? "";
      });
    });

    socket.on('init', (data) {
      Map<dynamic, dynamic> map = data;
    });

    socket.on('partner', (data) {
      Map<dynamic, dynamic> map = data;
      setState(() {
        partner = map['partnerSocketID'];
        game = map['gameID'];
      });

      createRoom(
        context,
        map['gameID'],
        map['TYPE'],
      );
    });

    //listens when the client is disconnected from the Server
    socket.on('disconnect', (data) {
      Navigator.pop(context);
    });
  }

  Future<void> createRoom(BuildContext context, GAMEID, type) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms");
    // String gameKey = "123";
    // String gameKey = ref.push().key.toString();
    Map<String, String> map = {
      "move": ",,,,,,,,",
      "turn": "CREATE",
      'winner': "N/A",
      'isStart': "NO",
    };
    await ref.child(GAMEID).set(map);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChoosePage(text: "online", gameId: GAMEID, userType: type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: const Color.fromARGB(245, 234, 85, 59),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/pop.png"),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  AudioPlayer().play(AssetSource('click.mp3'));
                  setState(() {
                    text = "Preparing a match ...";
                  });
                  socket = io(serverUrl, <String, dynamic>{
                    "transports": ["websocket"],
                    "autoConnect": false,
                  });
                  socket.connect(); //connect the Socket.IO Client to the Server
                  initializeSocket();
                  startTimer();
                },
                child: Image.asset("assets/images/PLAY.png", width: 300),
              ),
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  AudioPlayer().play(AssetSource('click.mp3'));
                },
                child: Image.asset(
                  "assets/images/LEARDERBOARD.png",
                  width: 300,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 470),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

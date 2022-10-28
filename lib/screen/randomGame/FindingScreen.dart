import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pop/screen/onlineGame/onlinePlay.dart';
import 'package:pop/uitls/uid.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../onlineGame/RoomScreen.dart';

class FindingScreen extends StatefulWidget {
  String name;
  FindingScreen({required this.name});

  @override
  State<FindingScreen> createState() => _FindingScreenState();
}

class _FindingScreenState extends State<FindingScreen> {
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
    socket = io(serverUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect(); //connect the Socket.IO Client to the Server
    initializeSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(status),
          Text(message),
          const SizedBox(
            height: 20,
          ),
          Text('partner id: $partner'),
          Text('gameID: $game'),
          Lottie.network(
              'https://assets1.lottiefiles.com/packages/lf20_8zr8zyt5.json'),
        ],
      ),
    );
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
      print("data: $data");

      Map<dynamic, dynamic> map = data;
      print("data: ${map["someProperty"] ?? ""}");
      setState(() {
        message = map["someProperty"] ?? "";
      });
    });

    socket.on('init', (data) {
      Map<dynamic, dynamic> map = data;
      print("MY-INFO: $data");
    });

    socket.on('partner', (data) {
      Map<dynamic, dynamic> map = data;
      print("PARTNER: $data");
      setState(() {
        partner = map['partnerSocketID'];
        game = map['gameID'];
      });

      createRoom(context, map['gameID'], map['TYPE'], map['name']);
    });

    //listens when the client is disconnected from the Server
    socket.on('disconnect', (data) {
      Navigator.pop(context);
    });
  }

  Future<void> createRoom(BuildContext context, GAMEID, type, name) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms");
    // String gameKey = "123";
    // String gameKey = ref.push().key.toString();
    Map<String, String> map = {
      "move": ",,,,,,,,",
      "turn": "P",
      'winner': "N/A",
      'isStart': "NO",
    };
    await ref.child(GAMEID).set(map);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnlinePlay(
            gameID: GAMEID,
            usrType: type,
          ),
        ));
  }
}

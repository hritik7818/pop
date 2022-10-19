import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pop/screen/online_game.dart';
import 'package:pop/screen/play_with_ai.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../firebase_services/authentication_services.dart';
import '../uitls/uid.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var ref1 = FirebaseDatabase.instance.ref("Online");
  var ref2 = FirebaseDatabase.instance.ref("GameSession");
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });
    // await ref2.child(gameId).remove();
    var provider = Provider.of<FirebaseService>(context, listen: false);
    print("initState method is called !");
    fetchUid().then((value) {
      if (value == "Matched") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const OnlineGame()));
        Future.delayed(const Duration(seconds: 15), () {
          ref1.child(uid).remove();
        });
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const AiPlay()));
        Future.delayed(const Duration(seconds: 15), () {
          ref1.child(uid).remove();
        });
        provider.signOut();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
            ),
            SizedBox(
              height: 50,
            ),
            Text("Searching...",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Future<String> fetchUid() async {
    print("inter in the fetchUid method body");
    await ref1.child(uid).set({
      "uid": uid,
    });
    print("uid is set in the database");
// Get the data once
    String res = "Not Matched";
    for (var i = 0; i < 15; i++) {
      DatabaseEvent event = await ref1.once();

// Print the data of the snapshot
      var map1 = event.snapshot.value as dynamic;

      if (map1 != null) {
        if (res != "Not Matched") {
          break;
        }
        await Future.delayed(const Duration(seconds: 1), () async {
          for (var key in map1.keys) {
            if (key != uid) {
              gameId = uid + key;
              int sum1 = calculateSum(uid);
              int sum2 = calculateSum(key);
              if (sum1 > sum2) {
                gotTurn = "P";
                await ref2.child(gameId).child("playersData").set({
                  "player1": uid,
                  "player2": key,
                });
              } else {
                gotTurn = "O";
                gameId = key + uid;
                await ref2.child(gameId).child("playersData").set({
                  "player1": key,
                  "player2": uid,
                });
              }

              await ref2
                  .child(gameId)
                  .child("winCount")
                  .set({"player1": 0, "player2": 0, "ties": 0});
              await ref2.child(gameId).child("check").set({"check": "0"});
              await ref2.child(gameId).child("opponentMove").set({
                "opponentMove": "9",
              });
              res = "Matched";
              break;
            }
          }
        });
      }
    }
    return res;
  }

  int calculateSum(String id) {
    int sum = 0;
    for (int i = 0; i < id.length; i++) {
      sum += id[i].codeUnits[0];
    }
    return sum;
  }
}

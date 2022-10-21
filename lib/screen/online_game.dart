import 'package:flutter/material.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/uitls/uid.dart';
import 'package:pop/widgets/onlineGameGrid.dart';
import 'package:pop/widgets/onlineGameStatus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pop/widgets/Score_board.dart';

class OnlineGame extends StatefulWidget {
   OnlineGame({required this.gameId});

  String gameId;
  @override
  State<OnlineGame> createState() => _OnlineGameState();
}

class _OnlineGameState extends State<OnlineGame> {
  int moveCount = 0;
  bool gameComplete = false;
  List move = ["", "", "", "", "", "", "", "", ""];
  int pWinCount = 0;
  int oWinCount = 0;
  int tiesCount = 0;

  String turn = "P";

  @override
  void initState() {
    super.initState();
    // functions
    //update moves

  }

  incrementMoveCount() {
    setState(() {
      moveCount++;
    });
  }

  toggleMove() {
    setState(() {
      turn = turn == "P" ? "O" : "P";
    });
  }

  resetMove() {
    setState(() {
      move = ["", "", "", "", "", "", "", "", ""];
      turn = "P";
    });
  }

  winCheck() {
    List win = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var i = 0; i < win.length; i++) {
      if ((move[win[i][0]] == "P" &&
          move[win[i][1]] == "O" &&
          move[win[i][2]] == "P")) {
        setState(() {
          gameComplete = true;
          if (gameComplete) {
            if (turn == "O") {
              setState(() {
                pWinCount++;
              });
            } else {
              setState(() {
                oWinCount++;
              });
            }

            Future.delayed(const Duration(milliseconds: 500), (() {
              showDialogBox((turn == "P") ? "O" : "P");
            }));
            moveCount = 0;

            return;
          }
        });
      }
    }
    if (moveCount == 9) {
      Future.delayed(const Duration(milliseconds: 500), (() {
        showDialogBox("Draw");
      }));
      moveCount = 0;
      setState(() {
        tiesCount++;
      });
    }
  }

  Future<dynamic> showDialogBox(text) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (cxt) => AlertDialog(
        title: Center(child: Text("$text win !")),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                resetMove();
                Navigator.of(context).pop();
              },
              child: const Text("RESTART"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName("homepage"));
              },
              child: const Text("EXIT"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FirebaseService>(context);
    print("move count$moveCount");
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 1, 29, 51),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              OnlineGameStatus(turn, resetMove),
              SizedBox(
                height: 50.h,
              ),
              Text(
                turn == gotTurn ? "YOUR MOVE" : "OPPONENT MOVE",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Expanded(
                child: OnlineGameGrid(
                  move: move,
                  turn: turn,
                  moveCount: moveCount,
                  toggleMove: toggleMove,
                  winCheck: winCheck,
                  incrementMoveCount: incrementMoveCount,
                ),
              ),
              ScoreCard(pWinCount, tiesCount, oWinCount, "P1", "P2"),
            ],
          ),
        ),
      ),
    );
  }
}

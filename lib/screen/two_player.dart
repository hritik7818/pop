import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pop/widgets/Score_board.dart';
import 'package:pop/widgets/game_status.dart';
import 'package:pop/widgets/grid.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int moveCount = 0;
  bool gameComplete = false;
  List move = ["", "", "", "", "", "", "", "", ""];
  int pWinCount = 0;
  int oWinCount = 0;
  int tiesCount = 0;

  String turn = "P";

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
    // if (moveCount == 9) {
    //   showDialogBox();
    // }
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
              Status(turn, resetMove),
              SizedBox(
                height: 150.h,
              ),
              Expanded(
                  child: GameGrid(
                      move: move,
                      turn: turn,
                      moveCount: moveCount,
                      toggleMove: toggleMove,
                      winCheck: winCheck,
                      incrementMoveCount: incrementMoveCount,
                      findAndFindBlankBox: null,
                      isPlayerWin: null)),
              ScoreCard(pWinCount, tiesCount, oWinCount, "P1", "P2"),
            ],
          ),
        ),
      ),
    );
  }
}

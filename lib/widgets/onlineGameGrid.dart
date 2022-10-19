import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pop/uitls/uid.dart';

class OnlineGameGrid extends StatefulWidget {
  final move;
  final toggleMove;
  final moveCount;
  final incrementMoveCount;
  final winCheck;
  final findAndFindBlankBox;
  final turn;
  final isPlayerWin;
  const OnlineGameGrid({
    this.move,
    this.turn,
    this.moveCount,
    this.toggleMove,
    this.winCheck,
    this.incrementMoveCount,
    this.findAndFindBlankBox,
    this.isPlayerWin,
  });

  @override
  State<OnlineGameGrid> createState() => _OnlineGameGridState();
}

class _OnlineGameGridState extends State<OnlineGameGrid> {
  var ref1 = FirebaseDatabase.instance.ref("GameSession");
  var ref2 = FirebaseDatabase.instance.ref("GameSession/$gameId");
  @override
  void deactivate() {
    // TODO: implement deactivate

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 9,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return StreamBuilder(
            stream: ref2.onValue,
            builder: (context, snapshot) {
              String check = "";
              String opponentMove = "";
              if (snapshot.data != null) {
                check = snapshot.data!.snapshot
                    .child("check/check")
                    .value
                    .toString();
                opponentMove = snapshot.data!.snapshot
                    .child("opponentMove/opponentMove")
                    .value
                    .toString();
              }
              //code for update the screen of the waiting player
              if (int.parse(opponentMove) == index && check == "1") {
                widget.move[index] = widget.turn;
                updateCheck();

                widget.toggleMove();
              }
              return GestureDetector(
                onTap: () {
                  widget.move[index] == ""
                      ? setState(() {
                          setOpponentMove(index);
                          var value = snapshot.data?.snapshot.value.toString();
                          value = value.toString();

                          widget.move[index] = widget.turn;
                          widget.toggleMove();
                          widget.incrementMoveCount();
                        })
                      : null;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black,
                    ),
                    height: 90.h,
                    width: 90.h,
                    child: Text(
                      widget.move[index],
                      style: TextStyle(
                        color: widget.move[index] == "P"
                            ? Colors.blue
                            : Colors.yellow,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void setOpponentMove(int index) async {
    await ref1
        .child(gameId)
        .child("opponentMove")
        .update({"opponentMove": index});
    await ref1.child(gameId).child("check").update({"check": "1"});
    final snackBar = SnackBar(
      content: const Text("check toggled"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void toggleMove() {
    widget.toggleMove();
    final snackBar = SnackBar(
      content: const Text("move toggled"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateCheck() async {
    await ref1.child(gameId).child("check").set({"check": "0"});
    final snackBar = SnackBar(
      content: const Text("check toggled"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

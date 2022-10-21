import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameGridOnline extends StatefulWidget {
  final List move;
  final Function toggleMove;
  final int moveCount;
  final Function incrementMoveCount;
  final Function winCheck;
  final String turn;
  final String gameId;
  const GameGridOnline({
    required this.move,
    required this.turn,
    required this.moveCount,
    required this.toggleMove,
    required this.winCheck,
    required this.incrementMoveCount,
    required this.gameId,
  });

  @override
  State<GameGridOnline> createState() => _GameGridOnlineState();
}

class _GameGridOnlineState extends State<GameGridOnline> {
  bool isGridActive = true;
  @override
  Widget build(BuildContext context) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    return GridView.builder(
      itemCount: 9,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.move[index] == "" && isGridActive
                ? setState(() {
                    updateMove(ref);
                    widget.move[index] = widget.turn;
                    widget.toggleMove();
                    widget.incrementMoveCount();

                    widget.winCheck();
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
                  color:
                      widget.move[index] == "P" ? Colors.blue : Colors.yellow,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void updateMove(DatabaseReference ref) async {
    print("update move run");
    await ref.update({"move": "fkjdsa"});
  }
}

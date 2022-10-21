import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameGridOnline extends StatefulWidget {
  final List move;
  final Function toggleMove;
  final int moveCount;
  final Function incrementMoveCount;
  final Function winCheck;
  final Function findAndFindBlankBox;
  final String turn;
  final bool isPlayerWin;
  final String gameId;
  const GameGridOnline({
    required this.move,
    required this.turn,
    required this.moveCount,
    required this.toggleMove,
    required this.winCheck,
    required this.incrementMoveCount,
    required this.findAndFindBlankBox,
    required this.isPlayerWin,
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
                    if (widget.isPlayerWin != null) {
                      isGridActive = false;
                    }
                    widget.move[index] = widget.turn;
                    widget.toggleMove();
                    widget.incrementMoveCount();

                    widget.winCheck();

                    if (widget.findAndFindBlankBox != null) {
                      Future.delayed(const Duration(seconds: 1), () {
                        if (widget.isPlayerWin != null) {
                          isGridActive = true;
                        }
                        if (widget.moveCount < 9 && !widget.isPlayerWin) {
                          for (var i = 0; i < widget.move.length; i++) {
                            if (widget.move[i] == "") {
                              widget.findAndFindBlankBox();
                              break;
                            }
                          }
                        }
                      });
                    }
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
}

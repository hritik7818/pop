import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameGrid extends StatefulWidget {
  final move;
  final toggleMove;
  final moveCount;
  final incrementMoveCount;
  final winCheck;
  final findAndFindBlankBox;
  final turn;
  final isPlayerWin;
  const GameGrid({
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
  State<GameGrid> createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  bool isGridActive = true;
  @override
  Widget build(BuildContext context) {
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

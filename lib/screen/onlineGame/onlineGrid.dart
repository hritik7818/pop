import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameGridOnline extends StatefulWidget {
  List move;
  final Function toggleMove;
  final int moveCount;
  final Function incrementMoveCount;
  final Function winCheck;
  late final String turn;
  final String gameId;
   GameGridOnline({
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
  void initState() {
    // TODO: implement initState
    updatelist();
    toggleturn();
    super.initState();
  }

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
            setState(() {
              widget.move[index] = widget.turn;
              updateMove(ref);
              widget.toggleMove();
              widget.incrementMoveCount();

              widget.winCheck();
            });
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
                  color: widget.move[index] == "P" ? Colors.blue : Colors.yellow,
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

  void updatelist() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    ref.child("move").onValue.listen((event) {
      setState(() {
       widget.move = event.snapshot.value.toString().split(',');
      });
    });
  }

  void updateMove(DatabaseReference ref) async {
    String move =  widget.move.toString();
    move = move.substring(1,move.length-1);
    await ref.update({"move": move});
    await ref.update({"turn": widget.turn=='P'?'O':'P'});
    updatelist();
  }

  void toggleturn() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    ref.child("turn").onValue.listen((event) {
      setState(() {
        widget.turn = event.snapshot.value.toString();
      });
    });
  }


}

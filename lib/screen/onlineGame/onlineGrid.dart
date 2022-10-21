import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameGridOnline extends StatefulWidget {
  // List move;
  final Function toggleMove;
  final int moveCount;
  final Function incrementMoveCount;
  final Function winCheck;
  // late final String turn;
  final String gameId;
   GameGridOnline({
    // required this.move,
    // required this.turn,
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
  late DatabaseReference ref;
  bool isGridActive = true;
  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    // TODO: implement initState
    // updatelist();
    // toggleturn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      itemCount: 9,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        return StreamBuilder(
          stream: ref.onValue,
          builder: (context,snapshot) {
            List<String>? move2 = snapshot.data?.snapshot.child("move").value.toString().split(",")??
                ["","","","","","","","",""];
            String turn = snapshot.data!.snapshot.child("turn").value.toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  updateMove(ref,move2,index,turn);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black,
                  ),
                  height: 90.h,
                  width: 90.h,
                  child: Center(
                    child: Text(
                      move2[index]??"",
                      style: TextStyle(
                        color: move2[index] == "P" ? Colors.blue : Colors.yellow,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
  // get list

  // void updatelist() {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
  //   ref.child("move").onValue.listen((event) {
  //     setState(() {
  //      widget.move = event.snapshot.value.toString().split(',');
  //     });
  //   });
  // }

  void updateMove(DatabaseReference ref,List<String> list,int index,String turn) async {
    list[index] = turn;
    String move =  list.toString();
    move = move.substring(1,move.length-1);
    await ref.update({"move": move});
    await ref.update({"turn": turn=='P'?'O':'P'});
  }

  // void toggleturn() {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
  //   ref.child("turn").onValue.listen((event) {
  //     setState(() {
  //       widget.turn = event.snapshot.value.toString();
  //     });
  //   });
  // }


}

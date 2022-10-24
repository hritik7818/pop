import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class GameGridOnline extends StatefulWidget {
  // List move;
  final Function toggleMove;
  final int moveCount;
  final Function incrementMoveCount;
  final Function winCheck;
  late final String userType;
  final String gameId;
   GameGridOnline({
    // required this.move,
    required this.userType,
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
  List<String> move2 = [];
  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    // onUpdateList();
    onMoveUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: ref.onValue,
      builder: (context,snapshot) {
        String turn = "P";
          if(snapshot.data!=null && snapshot.data?.snapshot!=null){
            move2 = snapshot.data!.snapshot.child("move").value.toString().split(",");
            turn = snapshot.data!.snapshot.child("turn").value.toString();
          }
        return GridView.builder(
          itemCount: 9,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  if(turn=='O' && widget.userType=='JOIN' && move2[index].toString().trim() == ""){
                    Fluttertoast.showToast(msg: "OO: turn: $turn user: ${widget.userType}");
                    updateMove(ref,move2,index,turn.trim());
                  }
                  if(turn=='P' && widget.userType=='CREATE' && move2[index].toString().trim() == ""){
                    Fluttertoast.showToast(msg: "PP: turn: $turn user: ${widget.userType}");
                    updateMove(ref,move2,index,turn.trim());
                  }
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
                      move2!=null? move2[index].toString().trim() ?? "":"",
                      style: TextStyle(
                        color: move2[index].trim() == "P" ? Colors.blue : Colors.yellow,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
        // fake grid
        // GridView.builder(
        //   itemCount: 9,
        //   gridDelegate:
        //   const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(8.r),
        //           color: Colors.black,
        //         ),
        //         height: 90.h,
        //         width: 90.h,
        //         child: const Center(
        //           child: Text(
        //             "",
        //             style: TextStyle(
        //               fontSize: 40,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );
      }
    );
  }

  void updateMove(DatabaseReference ref,List<String> list,int index,String turn) async {
    for(int i = 0; i<list.length; i++){
      list[i] = list[i].trim();
    }
    list[index] = turn;
    String move =  list.toString();
    move = move.substring(1,move.length-1);
    await ref.update({"move": move});
    await ref.update({"turn": turn=='P'?'O':'P'});

  }


  winCheck(List move, String turn,int count) {
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
      if (move[win[i][0]].toString().trim() == "P"
          && move[win[i][1]].toString().trim() == "O"
          && move[win[i][2]].toString().trim() == "P") {

        showDialogBox("$turn win $count");
      }
    }

  }

  onMoveUpdate(){
    ref.onValue.listen((event) {
      String turn = event.snapshot.child("turn").value.toString();
      if(move2.length!=0){
        winCheck(move2, turn,0);
        }
    });
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
              onPressed: () async {
                move2 = [];
                Navigator.of(context).pop();
                await ref.update({"move":",,,,,,,,"});

              },
              child: const Text("Play Again"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).popUntil(ModalRoute.withName("homepage"));
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

}

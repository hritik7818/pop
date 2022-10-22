import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:pop/uitls/uid.dart';
import 'package:provider/provider.dart';

class GameStatusFirebase extends StatefulWidget {
  final gameId;
  const GameStatusFirebase(this.gameId);

  @override
  State<GameStatusFirebase> createState() => _GameStatusFirebaseState();
}

class _GameStatusFirebaseState extends State<GameStatusFirebase> {
  late DatabaseReference ref;
  @override
  void initState() {
    ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "P",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "0",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "P",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FittedBox(
                  child: StreamBuilder(
                      stream: ref.onValue,
                    builder: (context,snapshot) {
                      String turn = snapshot.data!.snapshot.child("turn").value.toString();
                      return Text(
                        turn,
                        style: TextStyle(
                          color: turn=="P"?Colors.blue:Colors.yellow,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,

                        ),
                      );
                    }
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "Turn",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "hind",
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            DatabaseReference ref = FirebaseDatabase.instance.ref("GameRooms");
             ref.child(gameId).remove().then((value){
               Navigator.pop(context);
             });
          },
          icon: const Icon(
            Icons.exit_to_app_outlined,
            size: 30,
          ),
          color: Colors.blue,
        )
      ],
    );
  }

  void removeGameSession(ref) async {
    await ref.remove();
  }
}

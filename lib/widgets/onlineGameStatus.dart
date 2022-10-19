import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pop/firebase_services/authentication_services.dart';
import 'package:provider/provider.dart';

class OnlineGameStatus extends StatefulWidget {
  final turn;
  final resetMove;
  const OnlineGameStatus(this.turn, this.resetMove);

  @override
  State<OnlineGameStatus> createState() => _OnlineGameStatusState();
}

class _OnlineGameStatusState extends State<OnlineGameStatus> {
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseDatabase.instance.ref("GameSession");
    var provider = Provider.of<FirebaseService>(context);
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
                  child: Text(
                    widget.turn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
            widget.resetMove();
            provider.signOut();
            removeGameSession(ref);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.logout_sharp,
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

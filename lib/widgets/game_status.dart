import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Status extends StatefulWidget {
  final turn;
  final resetMove;
  const Status(this.turn, this.resetMove);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
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
                Text(
                  widget.turn,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
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
        Card(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: widget.resetMove,
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 30,
                )),
          ),
        )
      ],
    );
  }
}

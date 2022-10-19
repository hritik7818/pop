import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Board extends StatelessWidget {
  final color;
  final text1;
  final text2;
  final score;
  const Board(this.color, this.text1, this.text2, this.score);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 110.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 3.h),
            Text(
              text1,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 37, 62),
                fontSize: 20.sp,
              ),
            ),
            Text(
              text2,
              style: TextStyle(
                color: const Color.fromARGB(255, 5, 37, 62),
                fontSize: 20.sp,
              ),
            ),
            Text(
              score.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: const Color.fromARGB(255, 5, 37, 62),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

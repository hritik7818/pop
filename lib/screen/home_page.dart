import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/play_online.dart';
import 'package:pop/screen/play_with_ai.dart';
import 'package:pop/screen/two_player.dart';

import 'FindingScreen.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 166, 56, 56),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "P",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 30.h,
                ),
                const Text(
                  "0",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(
                  width: 30.h,
                ),
                const Text(
                  "P",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 90,
                      color: Colors.blue),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: "homepage"),
                    builder: (context) => const GamePage()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240.w, 50.h),
                backgroundColor: const Color.fromARGB(255, 65, 164, 245),
              ),
              child: const Text(
                "2 PLAYER",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: "homepage"),
                    builder: (context) => const AiPlay()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240.w, 50.h),
                backgroundColor: const Color.fromARGB(255, 255, 230, 0),
              ),
              child: const Text(
                "PLAY WITH BOT",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth auth  = FirebaseAuth.instance;
                if(auth.currentUser==null)
                  {
                    // not login
                    Fluttertoast.showToast(msg: "not login");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));

                  }else{
                  Fluttertoast.showToast(msg: "user is login");
                  //login
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindingScreen(),));
                }

                // Navigator.of(context).push(MaterialPageRoute(settings: const RouteSettings(name: "homepage"),
                //     builder: (context) => const PlayOnline()));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(240.w, 50.h),
                backgroundColor: const Color.fromARGB(255, 255, 230, 0),
              ),
              child: const Text(
                "PLAY ONLINE  ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

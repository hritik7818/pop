import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pop/screen/newGame/new_game_page.dart';
import 'package:pop/screen/newGame/online_game.dart';

class ChoosePage extends StatefulWidget {
  final String text;
  String? gameId;
  final String userType;
  ChoosePage(
      {super.key, required this.text, required this.userType, this.gameId});

  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  late Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          if (widget.text == "ai") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewGamePage(
                  (pSelect != ""
                      ? "P"
                      : oSelect != ""
                          ? "O"
                          : ""),
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OnlineRandomPage(
                    chooseString: pSelect != ""
                        ? "P"
                        : oSelect != "O"
                            ? "O"
                            : "",
                    gameId: widget.gameId!,
                    userType: widget.userType),
              ),
            );
          }
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String pSelect = "";
  String oSelect = "";

  selectP() {
    setState(() {
      pSelect = "Selected";
    });
  }

  selectO() {
    setState(() {
      oSelect = "Selected";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 100,
                width: 1000,
                color: Colors.red,
                child: Image.asset("assets/images/pop.png"),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      "P-O-P",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Agrandir-GrandHeavy",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You get the choose your first letter. After which, your letters will keep alternating. For example, if you begin with O, your next letter is P, and so on. Some rules for your opponent.",
                      style: GoogleFonts.balooBhai2(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "PICK YOUR FIRST LETTER",
                      style: TextStyle(
                        fontFamily: "Agrandir-GrandHeavy",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (oSelect == "") {
                                  AudioPlayer().play(AssetSource('click.mp3'));
                                  selectP();
                                }
                              },
                              child: Image.asset(
                                "assets/images/P.png",
                                width: 100, height: 100,
                                fit: BoxFit.contain, // Fixes border issues
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              pSelect,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          "assets/images/dotted-line.png",
                          height: 200,
                        ),
                        // Container(
                        //   width: 2,
                        //   height: 200,
                        //   color: Colors.white,
                        // ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (pSelect == "") {
                                  AudioPlayer().play(AssetSource('click.mp3'));
                                  selectO();
                                }
                              },
                              child: Image.asset(
                                "assets/images/O.png",
                                width: 100, height: 100,
                                fit: BoxFit.contain, // Fixes border issues
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              oSelect,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                        // Image.asset(
                        //   "images/O.png",
                        //   width: 65,height: 55,
                        //     fit:BoxFit.contain,
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Game Starts in ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Agrandir-GrandHeavy",
                              fontSize: 20),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Center(
                              child: Text(
                            "$_start",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

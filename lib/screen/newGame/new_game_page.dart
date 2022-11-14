import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pop/screen/newGame/gameover.dart';

class NewGamePage extends StatefulWidget {
  final String chooseString;
  const NewGamePage(this.chooseString);

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  late Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            Future.delayed(const Duration(seconds: 1), () {
              if (moveCount < 9 && !isPlayerWin) {
                for (var i = 0; i < move.length; i++) {
                  if (move[i] == "") {
                    findAndFillBlankBox();
                    Future.delayed(const Duration(seconds: 1), () {
                      if (moveCount < 9 && !isPlayerWin) {
                        for (var i = 0; i < move.length; i++) {
                          if (move[i] == "") {
                            findAndFillBlankBox();
                            AudioPlayer().play(AssetSource('click.mp3'));
                            break;
                          }
                        }
                      }
                    });
                    AudioPlayer().play(AssetSource('click.mp3'));
                    break;
                  }
                }
              }
            });

            timer.cancel();
          });
        } else {
          setState(() {
            if (_start < 5) {
              AudioPlayer().play(AssetSource('clock-sound.mp3'));
            }
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int moveCount = 0;
  int bothMoveCount = 0;
  bool gameComplete = false;
  List move = ["", "", "", "", "", "", "", "", ""];

  bool isPlayerWin = false;
  String lineType = "";

  String turn = "P";

  List startWithP = ["P", "O", "P", "O", "P", "O", "P", "O", "P"];

  List startWithO = ["O", "P", "O", "P", "O", "P", "O", "P", "O"];

  late List playerMoves;
  late List aiMoves;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    if (widget.chooseString == "") {
      var randomInt = Random().nextInt(2);
      playerMoves = (randomInt == 1) ? startWithO : startWithP;
    } else {
      playerMoves = (widget.chooseString == "P") ? startWithP : startWithO;
    }
    var randomInt = Random().nextInt(2);
    aiMoves = (randomInt == 1) ? startWithO : startWithP;
  }

  findAndFillBlankBox() {
    var randomInt = Random().nextInt(9);

    if (move[randomInt] == "") {
      setState(() {
        move[randomInt] = aiMoves[bothMoveCount];
        toggleMove();
        incrementMoveCount();
        incrementBothMoveCount();
        _timer.cancel();
        _start = 10;
        startTimer();
        winCheck();
      });

      return;
    } else {
      findAndFillBlankBox();
    }
  }

  incrementBothMoveCount() {
    setState(() {
      bothMoveCount++;
    });
  }

  incrementMoveCount() {
    setState(() {
      moveCount++;
    });
  }

  toggleMove() {
    setState(() {
      turn = turn == "P" ? "O" : "P";
    });
  }

  resetMove() {
    setState(() {
      move = ["", "", "", "", "", "", "", "", ""];
      turn = "P";
      moveCount = 0;
      isPlayerWin = false;
    });
  }

  winCheck() {
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
      if ((move[win[i][0]] == "P" &&
          move[win[i][1]] == "O" &&
          move[win[i][2]] == "P")) {
        setState(() {
          gameComplete = true;
          if (gameComplete) {
            if (turn == "O") {
              setState(() {
                isPlayerWin = true;
              });
            } else {
              setState(() {
                isPlayerWin = true;
              });
            }

            if (i == 0) {
              lineType = "top-horizontal";
            } else if (i == 1) {
              lineType = "middle-horizontal";
            } else if (i == 2) {
              lineType = "down-horizontal";
            } else if (i == 3) {
              lineType = "left-vertical";
            } else if (i == 4) {
              lineType = "middle-vertical";
            } else if (i == 5) {
              lineType = "right-vertical";
            } else if (i == 6) {
              lineType = "cross-down";
            } else if (i == 7) {
              lineType = "cross-up";
            }

            Future.delayed(const Duration(seconds: 1), (() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GameOver(turn == "P" ? "win" : "lose")));
              _timer.cancel();
            }));
            return;
          }
        });
      }
    }

    if (moveCount == 9) {
      Future.delayed(const Duration(milliseconds: 500), (() {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const GameOver("tie")));
        _timer.cancel();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 130,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: 100,
                                  color: (moveCount % 2 == 0)
                                      ? Colors.red
                                      : const Color.fromARGB(255, 113, 38, 32),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "YOU",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text("CURRENT MOVE :"),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              playerMoves[bothMoveCount],
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Container(
                                  height: 100,
                                  color: (moveCount % 2 != 0)
                                      ? Colors.blue
                                      : const Color.fromARGB(255, 32, 75, 110),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text(
                                              "OPPONENT",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Text("CURRENT MOVE :"),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              aiMoves[bothMoveCount],
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/circle.png",
                                  width: 85,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("$_start",
                                    style: const TextStyle(
                                      fontSize: 30,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              "assets/images/line.png",
                              height: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .5,
                              child: GridView.builder(
                                itemCount: 9,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      (move[index] == "" && moveCount % 2 == 0)
                                          ? setState(() {
                                              move[index] =
                                                  playerMoves[bothMoveCount];
                                              toggleMove();
                                              _timer.cancel();
                                              _start = 10;
                                              startTimer();
                                              incrementMoveCount();
                                              winCheck();
                                              AudioPlayer().play(
                                                  AssetSource('click.mp3'));

                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                if (moveCount < 9 &&
                                                    !isPlayerWin) {
                                                  for (var i = 0;
                                                      i < move.length;
                                                      i++) {
                                                    if (move[i] == "") {
                                                      findAndFillBlankBox();

                                                      AudioPlayer().play(
                                                          AssetSource(
                                                              'click.mp3'));
                                                      break;
                                                    }
                                                  }
                                                }
                                              });
                                            })
                                          : null;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        constraints:
                                            const BoxConstraints.expand(),
                                        child: (move[index] != "")
                                            ? Image.asset(
                                                "assets/images/${move[index]}.png",
                                                height: 70,
                                              )
                                            : const Text(""),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            (lineType == "top-horizontal")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0, top: 35),
                                    child: Image.asset(
                                      "assets/images/cross-horizontal.png",
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "middle-horizontal")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0, top: 170),
                                    child: Image.asset(
                                      "assets/images/cross-horizontal.png",
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "down-horizontal")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0, top: 295),
                                    child: Image.asset(
                                      "assets/images/cross-horizontal.png",
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "left-vertical")
                                ? Positioned(
                                    left: -110,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Image.asset(
                                        "assets/images/cross-vertical.png",
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        fit: BoxFit.contain,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "middle-vertical")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 18.0, top: 10),
                                    child: Image.asset(
                                      "assets/images/cross-vertical.png",
                                      height: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "right-vertical")
                                ? Positioned(
                                    right: -110,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Image.asset(
                                        "assets/images/cross-vertical.png",
                                        height:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        fit: BoxFit.contain,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const Text(""),
                            (lineType == "cross-up")
                                ? Image.asset(
                                    "assets/images/cross-up.png",
                                    height: MediaQuery.of(context).size.width,
                                    fit: BoxFit.contain,
                                    color: Colors.red,
                                  )
                                : const Text(""),
                            (lineType == "cross-down")
                                ? Image.asset(
                                    "assets/images/cross-down.png",
                                    height: MediaQuery.of(context).size.width,
                                    fit: BoxFit.contain,
                                    color: Colors.red,
                                  )
                                : const Text(""),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(70),
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        (moveCount % 2 != 0) ? "OPPONENT MOVE" : "YOUR MOVE",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}

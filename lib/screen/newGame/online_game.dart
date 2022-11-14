import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/newGame/gameover.dart';

import 'package:firebase_database/firebase_database.dart';

class OnlineRandomPage extends StatefulWidget {
  final String chooseString;
  final String gameId;
  final String userType;

  const OnlineRandomPage(
      {required this.chooseString,
      required this.gameId,
      required this.userType});

  @override
  State<OnlineRandomPage> createState() => _OnlineRandomPageState();
}

class _OnlineRandomPageState extends State<OnlineRandomPage> {
  late Timer _timer;
  int _start = 10;

  late DatabaseReference ref;

  int moveCount = 0;
  bool gameComplete = false;
  List move = ["", "", "", "", "", "", "", "", ""];

  bool isPlayerWin = false;
  String lineType = "";

  String turn = "";

  List startWithP = ["P", "O", "P", "O", "P", "O", "P", "O", "P"];

  List startWithO = ["O", "P", "O", "P", "O", "P", "O", "P", "O"];

  late List playerMoves;
  String opponentMove = "";
  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           if (_start < 5) {
  //             AudioPlayer().play(AssetSource('clock-sound.mp3'));
  //           }
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          // setState(() {
          //   Future.delayed(const Duration(seconds: 1), () {
          //     if (moveCount < 9 && !isPlayerWin) {
          //       for (var i = 0; i < move.length; i++) {
          //         if (move[i] == "") {
          //           findAndFillBlankBox();
          //           Future.delayed(const Duration(seconds: 1), () {
          //             if (moveCount < 9 && !isPlayerWin) {
          //               for (var i = 0; i < move.length; i++) {
          //                 if (move[i] == "") {
          //                   findAndFillBlankBox();
          //                   AudioPlayer().play(AssetSource('click.mp3'));
          //                   break;
          //                 }
          //               }
          //             }
          //           });
          //           AudioPlayer().play(AssetSource('click.mp3'));
          //           break;
          //         }
          //       }
          //     }
          //   });

          //   timer.cancel();
          // });
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

  findAndFillBlankBox() {
    var randomInt = Random().nextInt(9);

    if (move[randomInt] == "") {
      if ((widget.userType == 'JOIN' && turn == "JOIN" ||
              widget.userType == 'CREATE' && turn == "CREATE") &&
          move[randomInt].toString().trim() == "") {
        setState(() {
          move[randomInt] = playerMoves[moveCount];
          updateMove(ref, move, randomInt, playerMoves[moveCount]);
          winCheck();
          move[randomInt] = playerMoves[moveCount];
          incrementMoveCount();
          _timer.cancel();
          _start = 10;
          startTimer();
        });
      }
      return;
    } else {
      findAndFillBlankBox();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
    ref = FirebaseDatabase.instance.ref("GameRooms/${widget.gameId}");
    setMOve(ref);
    _start = 10;
    startTimer();
    // onUpdateList();
    onMoveUpdate();
    ongameIdDelete(ref);
    getOpponentMove(ref);
    getTurn();
  }

  void updateMove(
      DatabaseReference ref, List list, int index, String value) async {
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].trim();
    }
    list[index] = value.trim();
    String move = list.toString();
    move = move.substring(1, move.length - 1);
    await ref.update({"move": move});
    await ref.update({"turn": turn == 'JOIN' ? 'CREATE' : 'JOIN'});

    if (widget.userType == "CREATE") {
      await ref.update({'CREATE': playerMoves[moveCount]});
    }
    if (widget.userType == "JOIN") {
      await ref.update({'JOIN': playerMoves[moveCount]});
    }
  }

  onMoveUpdate() {
    ref.onValue.listen((event) {
      if (move.isNotEmpty) {
        winCheck();
        Fluttertoast.showToast(msg: "move count : $moveCount");
      }
    });
  }

  incrementMoveCount() {
    setState(() {
      moveCount++;
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
        Fluttertoast.showToast(msg: "Win occur !");
        setState(() async {
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

            await Future.delayed(const Duration(seconds: 1), (() async {
              await ref.update({'winner': 'yes'});
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const GameOver("win")),
                  (route) => false);
              _timer.cancel();
            }));
            return;
          }
        });
      }
    }

    if (moveCount == 5) {
      Future.delayed(const Duration(milliseconds: 500), (() async {
        await ref.update({'winner': 'tie'});
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const GameOver("tie")),
            (route) => false);
        _timer.cancel();
      }));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
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
                                    color: ((widget.userType == 'JOIN' &&
                                                turn == "JOIN" ||
                                            widget.userType == 'CREATE' &&
                                                turn == "CREATE"))
                                        ? const Color.fromARGB(255, 255, 33, 18)
                                        : const Color.fromARGB(
                                            255, 187, 76, 76),
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
                                                playerMoves[moveCount],
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
                                    color: ((widget.userType == 'JOIN' &&
                                                turn == "JOIN" ||
                                            widget.userType == 'CREATE' &&
                                                turn == "CREATE"))
                                        ? const Color.fromARGB(
                                            255, 74, 114, 148)
                                        : const Color.fromARGB(
                                            255, 28, 153, 255),
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
                                                "opponentMove",
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
                                                opponentMove,
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
                                child: StreamBuilder(
                                    stream: ref.onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null &&
                                          snapshot.data?.snapshot != null) {
                                        move = snapshot.data!.snapshot
                                            .child("move")
                                            .value
                                            .toString()
                                            .split(",");
                                        turn = snapshot.data!.snapshot
                                            .child("turn")
                                            .value
                                            .toString();
                                      }

                                      // ref
                                      //     .child("winner")
                                      //     .onValue
                                      //     .listen((event) async {
                                      //   if (event.snapshot.exists) {
                                      //     // if (event.snapshot.value == 'yes') {
                                      //     //   Navigator.of(context).push(
                                      //     //       MaterialPageRoute(builder: (context) => const GameOver("lose")));
                                      //     //   _timer.cancel();
                                      //     //   await ref.remove();
                                      //     // }

                                      //   } else {

                                      //   }
                                      // });

                                      return GridView.builder(
                                        itemCount: 9,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if ((widget.userType == 'JOIN' &&
                                                          turn == "JOIN" ||
                                                      widget.userType ==
                                                              'CREATE' &&
                                                          turn == "CREATE") &&
                                                  move[index]
                                                          .toString()
                                                          .trim() ==
                                                      "") {
                                                updateMove(ref, move, index,
                                                    playerMoves[moveCount]);
                                                print(
                                                    "move count :$moveCount and usertype is ${widget.userType}");
                                                setState(() {
                                                  winCheck();
                                                  move[index] =
                                                      playerMoves[moveCount];
                                                  incrementMoveCount();
                                                  _timer.cancel();
                                                  _start = 10;
                                                  startTimer();

                                                  AudioPlayer().play(
                                                      AssetSource('click.mp3'));
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "opponent move");
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                color: Colors.black,
                                                constraints:
                                                    const BoxConstraints
                                                        .expand(),
                                                child:
                                                    (move[index].trim() != "")
                                                        ? Image.asset(
                                                            "assets/images/${move[index].trim() == "P" ? "P.png" : "O.png"}",
                                                            height: 70,
                                                          )
                                                        : const Text(""),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                              (lineType == "top-horizontal")
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18.0, top: 35),
                                      child: Image.asset(
                                        "assets/images/cross-horizontal.png",
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                        height:
                                            MediaQuery.of(context).size.width,
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
            const SizedBox(
              height: 30,
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
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     color: Colors.yellow,
            //     width: double.infinity,
            //     child: Row(
            //       children: [
            //         const SizedBox(
            //           width: 30,
            //         ),
            //         Expanded(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 "NEXT TURN :",
            //                 style: TextStyle(fontSize: 18),
            //               ),
            //               const SizedBox(
            //                 height: 9,
            //               ),
            //               Text(
            //                 "Player ${(turn == "P") ? "2" : "1"}",
            //                 style: const TextStyle(fontSize: 25),
            //               ),
            //             ],
            //           ),
            //         ),
            //         const SizedBox(
            //           width: 30,
            //         ),
            //         Expanded(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 "CURRENT MOVE :",
            //                 style: TextStyle(fontSize: 18),
            //               ),
            //               const SizedBox(
            //                 height: 9,
            //               ),
            //               Row(
            //                 children: [
            //                   Text(
            //                     playerMoves[moveCount],
            //                     style: const TextStyle(
            //                       fontSize: 35,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                   const SizedBox(
            //                     width: 10,
            //                   ),
            //                   Text(
            //                     playerMoves[moveCount + 1],
            //                     style: const TextStyle(
            //                       fontSize: 25,
            //                       color: Color.fromARGB(201, 0, 0, 0),
            //                     ),
            //                   ),
            //                   const SizedBox(
            //                     width: 10,
            //                   ),
            //                   Text(
            //                     playerMoves[moveCount + 2],
            //                     style: const TextStyle(
            //                       fontSize: 25,
            //                       color: Color.fromARGB(201, 0, 0, 0),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }

  void ongameIdDelete(DatabaseReference ref) {
    ref.child("winner").onValue.listen((event) async {
      if (event.snapshot.exists) {
        if (event.snapshot.value == 'yes') {
          // if (!(widget.userType == 'JOIN' && turn == "JOIN" ||
          //     widget.userType == 'CREATE' && turn == "CREATE")) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const GameOver("lose")),
              (route) => false);
          // }
          _timer.cancel();

          Future.delayed(const Duration(seconds: 3), (() async {
            await ref.remove();
          }));
        }
      }
    });
    ref.child("winner").onValue.listen((event) async {
      if (event.snapshot.exists) {
        if (event.snapshot.value == 'tie') {
          // if (!(widget.userType == 'JOIN' && turn == "JOIN" ||
          //     widget.userType == 'CREATE' && turn == "CREATE")) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const GameOver("tie")),
              (route) => false);
          // }

          _timer.cancel();
          Future.delayed(const Duration(seconds: 3), (() async {
            await ref.remove();
          }));
        }
      }
    });
  }

  void setMOve(ref) async {
    if (moveCount == 0) {
      if (widget.userType == "CREATE") {
        await ref.update({'CREATE': playerMoves[moveCount]}); 
      }
      if (widget.userType == "JOIN") {
        await ref.update({'JOIN': playerMoves[moveCount]});
      }
    }
  }

  void getOpponentMove(DatabaseReference ref) {
    if (widget.userType == "CREATE") {
      ref.child("JOIN").onValue.listen((event) async {
        if (event.snapshot.exists) {
          opponentMove = event.snapshot.value as String;
        }
      });
    } else {
      ref.child("CREATE").onValue.listen((event) async {
        if (event.snapshot.exists) {
          opponentMove = event.snapshot.value as String;
        }
      });
    }
    setState(() {});
  }

  void getTurn() {
    ref.child("turn").onValue.listen((event) async {
      if (event.snapshot.exists) {
        turn = event.snapshot.value as String;
      }
    });
  }
}

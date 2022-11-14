import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pop/screen/newGame/first_page.dart';

class GameOver extends StatelessWidget {
  final String result;
  const GameOver(this.result);

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: "lksdjflsdf");
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(245, 234, 85, 59),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimateList(
              interval: 100.ms,
              effects: [FadeEffect(duration: 300.ms)],
              children: [
                Image.asset(
                  "assets/images/pop.png",
                  height: 120,
                ),
                const SizedBox(
                  height: 30,
                ),
                (result == "win")
                    ? Image.asset(
                        "assets/images/smile.png",
                        height: 240,
                      )
                    : (result == "lose")
                        ? Image.asset(
                            "assets/images/sad.png",
                            height: 240,
                          )
                        : Image.asset(
                            "assets/images/tie-emoji.png",
                            height: 240,
                          ),
                const SizedBox(
                  height: 30,
                ),
                (result == "win")
                    ? Image.asset(
                        "assets/images/youwin.png",
                        height: 150,
                      )
                    : (result == "lose")
                        ? Image.asset(
                            "assets/images/youlose.png",
                            height: 150,
                          )
                        : Image.asset(
                            "assets/images/TIE.png",
                            height: 150,
                          ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    AudioPlayer().play(AssetSource('click.mp3'));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const FirstScreen()),
                        (route) => false);
                  },
                  child: Image.asset(
                    "assets/images/play-again.png",
                    width: 350,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    AudioPlayer().play(AssetSource('click.mp3'));
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const FirstScreen()),
                        (route) => false);
                  },
                  child: Image.asset(
                    "assets/images/lEARDERBOARD.png",
                    width: 350,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

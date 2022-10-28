import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pop/screen/newGame/choose_page.dart';

class GameOver extends StatelessWidget {
  final String result;
  const GameOver(this.result);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/pink-bg.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (result == "win")
                      ? Image.asset("assets/images/you-lose.png")
                      : (result == "lose")
                          ? Image.asset("assets/images/youwon.png")
                          : const Text(
                              "TIE",
                              style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset("assets/images/gameover.png"),
                  const SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                      onTap: () {
                        AudioPlayer().play(AssetSource('click.mp3'));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChoosePage()));
                      },
                      child: Image.asset(
                        "assets/images/play-again.png",
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

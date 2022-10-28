import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pop/screen/newGame/new_game_page.dart';
import 'package:pop/screen/newGame/choose_page.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          color: const Color.fromARGB(245, 234, 85, 59),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/pop.png"),
              const SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () {
                  AudioPlayer().play(AssetSource('click.mp3'));
                  setState(() {
                    text = "Preparing a match ...";
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChoosePage()));
                },
                child: Image.asset("assets/images/play_button.png"),
              ),
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                onTap: () {
                  AudioPlayer().play(AssetSource('click.mp3'));
                },
                child: Image.asset(
                  "assets/images/leaderboard.png",
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

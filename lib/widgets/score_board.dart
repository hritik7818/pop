import 'package:flutter/material.dart';
import 'package:pop/widgets/board.dart';

class ScoreCard extends StatelessWidget {
  final pWinCount;
  final oWinCount;
  final tiesCount;
  final p1Name;
  final p2Name;

  const ScoreCard(
      this.pWinCount, this.tiesCount, this.oWinCount, this.p1Name, this.p2Name);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Board(Colors.blue, "P", "($p1Name)", pWinCount),
        Board(Colors.white70, "TIES", "", tiesCount),
        Board(Colors.yellow, "O", "($p2Name)", oWinCount),
      ],
    );
  }
}

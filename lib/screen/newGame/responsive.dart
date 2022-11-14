import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget child;
  const Responsive(this.child);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 490,
        ),
        child: child,
      ),
    );
  }
}

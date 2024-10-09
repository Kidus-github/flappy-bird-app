import 'package:flutter/material.dart';

class flappy_bird extends StatelessWidget {
  const flappy_bird(
      {super.key,
      required this.birdY,
      required this.birdHeight,
      required this.birdWidth});
  final double birdY;
  final double birdWidth;
  final double birdHeight;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        'assets/images/flappyBirds.png',
        width: MediaQuery.of(context).size.width * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
      ),
    );
  }
}

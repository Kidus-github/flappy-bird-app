import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  bool isStarted = false;
  double time = 0;
  double gravit = -4.9;
  double velocity = 3.50;
  double initalpos = birdY;
  double height = 0;

  void startGame() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravit * time * time + velocity * time;
      setState(() {
        birdY = initalpos - height;
        isStarted = true;
        print(birdY);
        if (birdY < -1 || birdY > 1) {
          timer.cancel();
        }
      });
      time += 0.01;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initalpos = birdY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isStarted ? jump : startGame,
              child: Container(
                color: Colors.blue,
                child: Stack(
                  children: [
                    flappy_bird(
                      birdY: birdY,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.brown,
          ))
        ],
      ),
    );
  }
}

class flappy_bird extends StatelessWidget {
  const flappy_bird({super.key, required this.birdY});
  final double birdY;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        'assets/images/flappyBirds.png',
        width: 80,
      ),
    );
  }
}

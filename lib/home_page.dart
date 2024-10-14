import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'my_barrier.dart';
import 'flappy_bird.dart';
import 'cover_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird
  static double birdY = 0;
  double birdWidth = 0.3;
  double birdHeight = 0.25;

  double gravit = -4.9;
  double height = 0;
  double velocity = 2.50;
  double initalpos = birdY;
  int score = 0;
  int max = 0;
  double space = 0.3;
  bool isStarted = false;
  double time = 0;
  double Speed = 0.02;
  //Barrier value
  static double barrierWidth = 0.3;

  static List<double> barrierX = [
    1,
    3,
  ];
  List<List<double>> barrierHeight = [
    [0.6, 0.2],
    [0.3, 0.7]
  ];

  void startGame() {
    Timer.periodic(Duration(milliseconds: 40), (timer) {
      height = gravit * time * time + velocity * time;
      setState(() {
        birdY = initalpos - height;
        isStarted = true;

        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= Speed; // Move barriers left
          // Reset barrier when it goes off the left of the screen
          if (barrierX[i] < -1.5) {
            barrierX[i] += 3.5; // Re-position to the right side of the screen
            barrierHeight[i] = [randomHeight(), randomHeight()];
            ++score; // Generate new random heights for barriers
          }
          if (score > 5 && Speed <= 0.05) {
            Speed = Speed + 0.0001;
            if (space <= 0.37) space = space + 0.01;
          }
        }

        if (BirdIsDead()) {
          timer.cancel();
          _showDialog();
        }
      });
      time += 0.01;
    });
  }

  double randomHeight() {
    return (space +
        0.3 * (new Random().nextDouble())); // Random height between 0.2 and 0.5
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      max > score ? max : max = score;
      birdY = 0;
      time = 0;
      isStarted = false;
      initalpos = birdY;
      barrierX = [1, 3];
      score = 0;
      Speed = 0.02;
      space = 0.3;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
              child: Text(
                'G A M E  O V E R ',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'PLAY AGAIN',
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initalpos = birdY;
      velocity = 2.5; // Reset or apply initial jump velocity
    });
  }

  bool BirdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true; // Bird is out of bounds (top or bottom of the screen)
    }

    for (int i = 0; i < barrierX.length; i++) {
      // Check if bird is within horizontal bounds of the barrier
      if (barrierX[i] - barrierWidth / 2 <= 0 &&
          barrierX[i] + barrierWidth / 2 >= 0) {
        // Check vertical collision with the barrier
        if (birdY <= -1 + barrierHeight[i][0] ||
            birdY + birdHeight >= 1 - barrierHeight[i][1]) {
          return true; // Collision detected
        }
      }
    }

    return false; // No collision
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Stack(
                  children: [
                    flappy_bird(
                      birdY: birdY,
                      birdHeight: birdHeight,
                      birdWidth: birdWidth,
                    ),
                    CoverScreen(isStarted: isStarted),
                    MyBarrier(
                      barrierHeight: barrierHeight[0][0],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[0],
                      isBottomBarrier: false,
                    ),
                    MyBarrier(
                      barrierHeight: barrierHeight[0][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[0],
                      isBottomBarrier: true,
                    ),
                    MyBarrier(
                      barrierHeight: barrierHeight[1][0],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[1], // Change to barrierX[1]
                      isBottomBarrier: false,
                    ),
                    MyBarrier(
                      barrierHeight: barrierHeight[1][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[1], // Change to barrierX[1]
                      isBottomBarrier: true,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
                child: Center(
              child: Container(
                color: Colors.brown,
                child: !isStarted
                    ? Center(
                        child: RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Created By:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            TextSpan(
                              text: '\tTech Hill',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            )
                          ],
                        )),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Score',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                              Text(
                                score.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Best',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                              Text(
                                max.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              )
                            ],
                          )
                        ],
                      ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

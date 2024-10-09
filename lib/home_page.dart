import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
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
  double birdHeight = 0.3;

  double gravit = -4.9;
  double height = 0;
  double velocity = 2.50;
  double initalpos = birdY;
  int score = 0;
  int max = 0;

  bool isStarted = false;
  double time = 0;

  //Barrier value
  static double barrierWidth = 0.3;

  static List<double> barrierX = [
    2,
    3.5,
  ];
  List<List<double>> barrierHeight = [
    [0.6, 0.2],
    [0.3, 0.7]
  ];

  void startGame() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravit * time * time + velocity * time;
      setState(() {
        birdY = initalpos - height;
        isStarted = true;
        print(birdY);

        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= 0.02; // Move barriers left
          // Reset barrier when it goes off the left of the screen
          if (barrierX[i] < -2) {
            barrierX[i] += 3.5; // Re-position to the right side of the screen
            barrierHeight[i] = [randomHeight(), randomHeight()];
            ++score;
            // Generate new random heights for barriers
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
    return (0.4 +
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
      barrierX = [2, 2 + 1.5];
      score = 0;
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
                            style: TextStyle(color: Colors.white, fontSize: 24),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                            Text(
                              score.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                            Text(
                              max.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            )
                          ],
                        )
                      ],
                    ),
            ),
          ))
        ],
      ),
    );
  }
}

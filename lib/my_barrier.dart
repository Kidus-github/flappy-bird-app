import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  const MyBarrier({
    super.key,
    required this.barrierHeight,
    required this.barrierWidth,
    required this.barrierX,
    required this.isBottomBarrier,
  });

  final double barrierHeight, barrierWidth, barrierX;
  final bool isBottomBarrier;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isBottomBarrier ? 1 : -1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height *
            barrierHeight /
            2, // Use barrierHeight instead of barrierWidth
      ),
    );
  }
}

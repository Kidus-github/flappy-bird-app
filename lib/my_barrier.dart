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
    return AnimatedContainer(
      alignment: Alignment(barrierX, isBottomBarrier ? 1.2 : -1.2),
      duration: const Duration(milliseconds: 0),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * barrierHeight / 2,
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(width: 10, color: Colors.green.shade800),
            borderRadius: BorderRadius.circular(10)),
        // Use barrierHeight instead of barrierWidth
      ),
    );
  }
}

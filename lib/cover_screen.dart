import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({
    super.key,
    required this.isStarted,
  });

  final bool isStarted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.5),
      child: Text(
        isStarted ? '' : 'T A P  T O  P L A Y',
        style: TextStyle(fontSize: 28, color: Colors.white),
      ),
    );
  }
}

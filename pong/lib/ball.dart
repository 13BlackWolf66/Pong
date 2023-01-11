import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double x;
  final double y;
  const MyBall({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: Container(
        width: MediaQuery.of(context).size.width / 23,
        height: MediaQuery.of(context).size.width / 23,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final double x;
  final double y;
  final Color color;
  const MyBrick(
      {super.key, required this.x, required this.y, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(x, y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: color,
          height: MediaQuery.of(context).size.width / 23,
          width: MediaQuery.of(context).size.width / 5,
        ),
      ),
    );
  }
}

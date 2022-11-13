import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  final bool gameStarted;
  const CoverScreen({super.key, required this.gameStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.2),
      child: Text(
        gameStarted ? '' : 'TAP TO PLAY',
        style: GoogleFonts.turretRoad(
          fontSize: 35,
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

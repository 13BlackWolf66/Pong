import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pong/ball.dart';
import 'package:pong/brick.dart';
import 'package:pong/cover_screen.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  Random r = Random();
  bool direction = false;
  bool gameStarted = false;
  double ballX = 0;
  double ballY = 0;
  double brickX = 0;
  double brickWidth = 0.4; // 2/5 = 0.4 because width of a brick == 1/5 width of a screen
  double ballSpeed = 0.001;

  int score = 0;
  int bestScore = 0;

  var ballDirectionX = Direction.up;
  var ballDirectionY = Direction.left;

  @override
  void initState() {
    super.initState();
    readFromFile().then((value) {
      setState(() {
        bestScore = value;
      });
    });
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setState(() {
        updateDirection();
        moveBall();
        if (ballY >= 0.98) {
          if (bestScore <= score) {
            bestScore = score;
            writeToFile(bestScore);
          }

          timer.cancel();
          resetGame();
        }
      });
    });
  }

  void resetGame() {
    setState(() {
      gameStarted = false;
      ballX = 0;
      ballY = 0;
      brickX = 0;
      score = 0;
      ballSpeed = 0.001;
    });
  }

  void updateDirection() {
    setState(() {
      if (ballY <= -0.9 + 0.043) {
        ballDirectionX = Direction.down;
      } else if ((ballDirectionX == Direction.down) &&
          (ballY >= 0.9 - 0.043) &&
          ((ballX >= 0)
              ? (ballX >= (brickX - 0.2 - 0.2 * brickX) &&
                  (ballX - 0.045 * ballX <= (brickX + 0.2 - 0.2 * brickX)))
              : ((ballX + 0.045 * ballX.abs() >=
                      (brickX - 0.2 + 0.2 * brickX.abs())) &&
                  (ballX <= (brickX + 0.2 + 0.2 * brickX.abs()))))) {
        ballDirectionX = Direction.up;

        score++;
        if (((score + 1) % 4) == 0) ballSpeed += 0.0003;

        direction = r.nextBool();

        if (direction) {
          ballDirectionY = Direction.right;
        } else {
          ballDirectionY = Direction.left;
        }
      }
      if (ballX <= -1) {
        ballDirectionY = Direction.right;
      } else if (ballX >= 1) {
        ballDirectionY = Direction.left;
      }
    });
  }

  void moveBall() {
    setState(() {
      (ballDirectionX == Direction.up)
          ? ballY -= ballSpeed
          : ballY += ballSpeed;
      (ballDirectionY == Direction.left)
          ? ballX -= ballSpeed
          : ballX += ballSpeed;
    });
  }

  void moveBrick(details) {
    setState(() {
      if (brickX <= 1 && brickX >= -1) {
        //debugPrint('$details.delta.dx');
        brickX += details.delta.dx / 155;
      } else if (brickX < 0) {
        brickX = -1;
      } else {
        brickX = 1;
      }
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/score.txt');
  }

  Future<int> readFromFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeToFile(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        moveBrick(details);
      },
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Score: $bestScore',
                style: GoogleFonts.turretRoad(
                  fontSize: 25,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Score: $score',
                style: GoogleFonts.turretRoad(
                  fontSize: 25,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black12,
        ),
        body: Center(
          child: Stack(
            children: [
              CoverScreen(
                gameStarted: gameStarted,
              ),
              MyBrick(
                x: ballX,
                y: -0.9,
                color: Colors.purple,
              ),
              MyBrick(
                x: brickX,
                y: 0.9,
                color: Colors.amber,
              ),
              MyBall(x: ballX, y: ballY),
            ],
          ),
        ),
      ),
    );
  }
}

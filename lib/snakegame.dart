
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGamePage());
}
class SnakeGamePage extends StatefulWidget {
  @override
  _SnakeGamePageState createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int gridSize = 20;
  static const double speed = 0.3; // Snake speed in seconds

  List<Offset> snakePositions = [
    Offset(10, 10),
  ];

  Offset foodPosition = Offset(5, 5);
  String direction = 'RIGHT';
  Timer? timer;
  bool isGameOver = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateFood();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: (speed * 1000).toInt()), (_) {
      setState(() {
        moveSnake();
      });
    });
  }

  void generateFood() {
    Random random = Random();
    foodPosition = Offset(
      random.nextInt(gridSize).toDouble(),
      random.nextInt(gridSize).toDouble(),
    );
  }

  void moveSnake() {
    if (isGameOver) return;

    Offset newHeadPosition = snakePositions.last;

    switch (direction) {
      case 'UP':
        newHeadPosition += Offset(0, -1);
        break;
      case 'DOWN':
        newHeadPosition += Offset(0, 1);
        break;
      case 'LEFT':
        newHeadPosition += Offset(-1, 0);
        break;
      case 'RIGHT':
        newHeadPosition += Offset(1, 0);
        break;
    }

    // Check for collisions with walls or itself
    if (
    newHeadPosition.dx < 0 ||
        newHeadPosition.dx >= gridSize ||
        newHeadPosition.dy < 0 ||
        newHeadPosition.dy >= gridSize ||
        snakePositions.contains(newHeadPosition)) {
      gameOver();
      return;
    }

    snakePositions.add(newHeadPosition);

    // Check for food collision
    if (newHeadPosition == foodPosition) {
      score++;
      generateFood();
    } else {
      snakePositions.removeAt(0);
    }
  }

  void gameOver() {
    timer?.cancel();
    setState(() {
      isGameOver = true;
    });
  }

  void restartGame() {
    setState(() {
      snakePositions = [Offset(10, 10)];
      direction = 'RIGHT';
      isGameOver = false;
      score = 0;
      generateFood();
      startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 && direction != 'UP') {
            direction = 'DOWN';
          } else if (details.delta.dy < 0 && direction != 'DOWN') {
            direction = 'UP';
          }
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0 && direction != 'LEFT') {
            direction = 'RIGHT';
          } else if (details.delta.dx < 0 && direction != 'RIGHT') {
            direction = 'LEFT';
          }
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  int x = index % gridSize;
                  int y = index ~/ gridSize;
                  Offset position = Offset(x.toDouble(), y.toDouble());

                  bool isSnakeBody = snakePositions.contains(position);
                  bool isFood = position == foodPosition;

                  return Container(
                    margin: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: isSnakeBody
                          ? Colors.green
                          : isFood
                          ? Colors.red
                          : Colors.black,
                      shape: BoxShape.rectangle,
                    ),
                  );
                },
              ),
            ),
            if (isGameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Game Over',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartGame,
                      child: Text('Restart'),
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 40,
              left: 20,
              child: Text(
                'Score: $score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


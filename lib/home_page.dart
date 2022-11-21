import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake/widgets/blank_pixel.dart';
import 'package:snake/widgets/food_pixel.dart';
import 'package:snake/widgets/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: camel_case_types
enum snakeDiraction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  int rowSquers = 10;

  int totalNumberOfSquers = 140;

  List<int> snakePos = [0, 1, 2];

  int foodPos = 65;

  var curruntDiraction = snakeDiraction.right;

  int currentScore = 0;

  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(() {
          moveSnake();

          if (gameOver()) {
            timer.cancel();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Game Over',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  content: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    'your score is: ' + currentScore.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Restart();
                        newGame();
                      },
                      // ignore: sort_child_properties_last
                      child: const Text(
                        'Play Again',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.teal,
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  void Restart() {}

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = Random().nextInt(totalNumberOfSquers);
      curruntDiraction = snakeDiraction.right;
      currentScore = 0;
      gameHasStarted = false;
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'your score',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 23,
                  ),
                ),
                Text(
                  currentScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    curruntDiraction != snakeDiraction.up) {
                  curruntDiraction = snakeDiraction.down;
                } else if (details.delta.dy < 0 &&
                    curruntDiraction != snakeDiraction.down) {
                  curruntDiraction = snakeDiraction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    curruntDiraction != snakeDiraction.left) {
                  curruntDiraction = snakeDiraction.right;
                } else if (details.delta.dx < 0 &&
                    curruntDiraction != snakeDiraction.right) {
                  curruntDiraction = snakeDiraction.left;
                }
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowSquers,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalNumberOfSquers,
                itemBuilder: (context, index) {
                  if (snakePos.contains(index)) {
                    return const SnakePixel();
                  } else if (foodPos == index) {
                    return const FoosPixel();
                  } else {
                    return const BlankPixel();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  color: gameHasStarted ? Colors.grey[900] : Colors.pink,
                  onPressed: gameHasStarted ? () {} : startGame,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveSnake() {
    switch (curruntDiraction) {
      case snakeDiraction.right:
        {
          if (snakePos.last % rowSquers == 9) {
            snakePos.add(snakePos.last + 1 - rowSquers);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }

        break;
      case snakeDiraction.left:
        {
          if (snakePos.last % rowSquers == 0) {
            snakePos.add(snakePos.last - 1 + rowSquers);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }

        break;
      case snakeDiraction.up:
        {
          if (snakePos.last < rowSquers) {
            snakePos.add(snakePos.last - rowSquers + totalNumberOfSquers);
          } else {
            snakePos.add(snakePos.last - rowSquers);
          }
        }

        break;
      case snakeDiraction.down:
        {
          if (snakePos.last + rowSquers > totalNumberOfSquers) {
            snakePos.add(snakePos.last + rowSquers - totalNumberOfSquers);
          } else {
            snakePos.add(snakePos.last + rowSquers);
          }
        }

        break;

      default:
    }
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }
}

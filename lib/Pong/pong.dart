import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double increment = 5;

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  late Animation<double> animation;
  late AnimationController controller;

  late double width;
  late double height;
  double posX = 0;
  double posY = 0;

  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  double randX = 1;
  double randY = 1;

  int score = 0;

  // bool showDialog = false;

  double randomNumber() {
    //this is a number between 0.5 and 1.5;
    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: const Text('Would you like to play again?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () {
                  try {
                    setState(() {
                      posX = 0;
                      posY = 0;
                      score = 0;
                    });
                    Navigator.of(context).pop();
                    controller.repeat();
                  } catch (e) {}
                },
              ),
              ElevatedButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    posX = 0;
    posY = 0;
    controller = AnimationController(
      duration: const Duration(minutes: 100000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    controller.forward();
    super.initState();
    return;
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    //check the bat position as well
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      //check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  @override
  Widget build(BuildContext context) {

    


    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batHeight = height / 20;

      return Stack(
        children: <Widget>[
          Center(
              child: Positioned(
                  top: 0,
                  right: 10,
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontFamily: 'IndieFlower',
                      color: Colors.blueGrey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ))),
          Positioned(top: posY, left: posX, child: const Ball()),
          Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails update) =>
                      moveBat(update),
                  child: Bat(batWidth, batHeight))),
        ],
      );
    });
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }

  @override
  void dispose() {
    try {
      controller.dispose();
      super.dispose();
    } catch (e) {}
  }

  void safeSetState(Function function) {
    // we call the dispose() method on an object, the object is no longer usable.
    // Any subsequent call will raise an error. To prevent getting errors in our app,
    // we can create a method that, prior to calling the setState() method,
    // will check whether the controller is still mounted and the controller is active
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }
}

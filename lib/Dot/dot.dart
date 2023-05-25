import 'package:flutter/material.dart';
import 'dart:math';

// // void main() => runApp(TapTheDot());

// class TapTheDot extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title:
//       'Tap the Dot',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: GamePage(),
//     );
//   }
// }

class TapTheDot extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<TapTheDot> {
  Random random = Random();
  double dotTop = 100;
  double dotLeft = 100;
  int score = 0;

  void updateDotPosition() {
    setState(() {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;

      double offset = 100; // Adjust the dot size here

      dotTop = random.nextDouble() * (screenHeight - offset);
      dotLeft = random.nextDouble() * (screenWidth - offset);
    });
  }

  void incrementScore() {
    setState(() {
      score++;
    });
  }

  bool isTappedOnDot(Offset tapPosition) {
    // Check if the tap position is within the dot's boundaries

    double dotSize = 100;
    double dotRadius = dotSize / 2;
    double dotCenterX = dotLeft;
    double dotCenterY = dotTop;

    double distance = sqrt(pow(tapPosition.dx - dotCenterX, 2) +
        pow((tapPosition.dy - 120) - dotCenterY, 2));

    print(dotLeft);

    print(dotTop);
    print(tapPosition);

    print(distance);

    return distance <= dotRadius;
  }

  void handleTapDown(TapDownDetails tapDetails) {
    Offset tapPosition = tapDetails.globalPosition;

    if (isTappedOnDot(tapPosition)) {
      incrementScore();
      updateDotPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tap the Dot',
          style: TextStyle(
            fontFamily: 'IndieFlower',
            // Set the font size of the app bar title
            fontWeight:
                FontWeight.bold, // Set the font weight of the app bar title
            color: Colors.white, // Set the color of the app bar title
            // You can also use other TextStyle properties like fontFamily, letterSpacing, etc. to further customize the font
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red, // Set the color of the app bar background
      ),
      body: GestureDetector(
        onTapDown: handleTapDown,
        child: Container(
          color: Colors.grey[300],
          child: Stack(
            children: [
              Positioned(
                top: dotTop,
                left: dotLeft,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Text(
                  'Score: $score',
                  style: TextStyle(fontFamily: 'IndieFlower', fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ConfettiDefault extends StatefulWidget {
  const ConfettiDefault({super.key});

  @override
  State<ConfettiDefault> createState() => _ConfettiDefaultState();
}

class _ConfettiDefaultState extends State<ConfettiDefault> {
  late ConfettiController _confettiController;

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    Future.delayed(
        const Duration(
          milliseconds: 300,
        ), () {
      startConfetti();
    });
  }

  void startConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality
          .explosive, // don't specify a direction, blast randomly
      shouldLoop: false, // start again as soon as the animation is finished
      numberOfParticles: 100,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ], // manually specify the colors to be used
      createParticlePath: drawStar, // define a custom shape/path.
    );
  }
}

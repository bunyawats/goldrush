import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

class Player extends PositionComponent
    with GestureHitboxes, CollisionCallbacks {
  static const int squareSpeed = 250;
  static final squarePaint = BasicPalette.green.paint();
  static const squareWidth = 100.0, squareHeight = 100.0;
  late Rect sqarePos;
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Get the width and height of our screen canvas
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    // Calculate the center of the screen, allowing for the adjustment for the squares size
    centerX = (screenWidth / 2) - (squareWidth / 2);
    centerY = (screenHeight / 2) - (squareHeight / 2);

    // Set the initial position of the green square at the center of the screen with a size of 100 width and height
    position = Vector2(centerX, centerY);
    size = Vector2(squareWidth, squareHeight);

    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      if (squareDirection == 1) {
        squareDirection = -1;
      } else {
        squareDirection = 1;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += squareSpeed * squareDirection * dt;
  }
}

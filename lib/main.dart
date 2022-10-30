import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';

void main() async {
  final goldRush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(
    GameWidget(game: goldRush),
  );
}

class GoldRush extends Game {
  static const int squareSpeed = 250;
  static final squrePaint = BasicPalette.green.paint();
  static const squareWidth = 100.0, squareHeight = 100.0;
  static const squreWidth = 100.0, squreHight = 100.0;
  late Rect sqarePos;
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, certerY;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    centerX = (screenWidth / 2) - (squreWidth / 2);
    certerY = (screenHeight / 2) - (squreHight / 2);
    sqarePos = Rect.fromLTRB(centerX, certerY, screenWidth, squreHight);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(sqarePos, squrePaint);
  }

  @override
  void update(double dt) {
    sqarePos = sqarePos.translate(
      squareSpeed * squareDirection * dt,
      0,
    );

    if (squareDirection == 1 && sqarePos.right > screenWidth) {
      squareDirection = -1;
    } else if (squareDirection == -1 && sqarePos.left < 0) {
      squareDirection = 1;
    }
  }
}

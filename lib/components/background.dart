import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'george.dart';

class Backgroud extends PositionComponent with Tappable {
  static final backgroudPaint = BasicPalette.white.paint();
  late double screenWidth, screenHeight;
  final George george;

  Backgroud(this.george);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    position = Vector2(0, 0);
    size = Vector2(screenWidth, screenHeight);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromPoints(
        position.toOffset(),
        size.toOffset(),
      ),
      backgroudPaint,
    );
  }

  @override
  bool onTapUp(TapUpInfo info) {
    george.moveToLocation(info.eventPosition.game);
    return true;
  }
}

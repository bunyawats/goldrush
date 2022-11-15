import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

import '../utils/math_utils.dart';
import 'george.dart';

class Backgroud extends PositionComponent with Tappable {
  final George george;

  Backgroud(this.george) : super(priority: 20);

  @override
  bool onTapUp(TapUpInfo info) {
    george.moveToLocation(info.eventPosition.game);
    return true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    Rect gameScreenBounds = getGameScreenBounds(size);
    if (size.x > 1600) {
      double xAdjust = (size.x - 1600) / 2;
      position = Vector2(
        gameScreenBounds.left + xAdjust,
        gameScreenBounds.top,
      );
    } else {
      position = Vector2(
        gameScreenBounds.left,
        gameScreenBounds.top,
      );
    }
    this.size = Vector2(1600, 1600);
  }
}

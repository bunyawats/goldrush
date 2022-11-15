import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../utils/math_utils.dart';

class Water extends PositionComponent with GestureHitboxes, CollisionCallbacks {
  int id;
  late Vector2 originalPosition;

  Water({
    required Vector2 position,
    required Vector2 size,
    required this.id,
  })  : originalPosition = position,
        super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    Rect gameScreenBounds = getGameScreenBounds(size);
    position = Vector2(
      originalPosition.x + gameScreenBounds.left,
      originalPosition.y + gameScreenBounds.top,
    );
  }
}

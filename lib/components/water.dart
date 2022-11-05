import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Water extends PositionComponent with GestureHitboxes, CollisionCallbacks {
  int id;

  Water({
    required Vector2 position,
    required Vector2 size,
    required this.id,
  }) : super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}

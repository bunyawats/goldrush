import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import '../utils/math_utils.dart';
import '../utils/effects.dart';

class Coin extends SpriteAnimationComponent with GestureHitboxes {
  late Vector2 originalPosition;
  late ShadowLayer shadowLayer;

  Coin({
    required Vector2 position,
    required Vector2 size,
  })  : originalPosition = position,
        super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    shadowLayer = ShadowLayer(super.render);

    var spriteImages = await Flame.images.load('coins.png');
    final spriteSheet = SpriteSheet(image: spriteImages, srcSize: size);
    animation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      from: 0,
      to: 7,
    );

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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    shadowLayer.render(canvas);
  }
}

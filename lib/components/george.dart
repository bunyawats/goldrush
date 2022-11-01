import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flame/input.dart';
import 'character.dart';
import '/utils/math_utils.dart';

import 'hud/hud.dart';
import 'skeleton.dart';
import 'zombie.dart';

class George extends Character {
  late final double walkingSpeed, runnungSpeed;
  late Vector2 targetLocation;
  bool movingToTouchLacation = false;

  final HudComponent hud;

  George({
    required this.hud,
    required Vector2 position,
    required Vector2 size,
    required double speed,
  }) : super(
          position: position,
          size: size,
          speed: speed,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    walkingSpeed = speed;
    runnungSpeed = speed * 2;

    var spriteImages = await Flame.images.load('george.png');
    final spriteSheet =
        SpriteSheet(image: spriteImages, srcSize: Vector2(width, height));
    downAnimation = spriteSheet.createAnimationByColumn(
      column: 0,
      stepTime: 0.2,
    );
    leftAnimation = spriteSheet.createAnimationByColumn(
      column: 1,
      stepTime: 0.2,
    );
    upAnimation = spriteSheet.createAnimationByColumn(
      column: 2,
      stepTime: 0.2,
    );
    rightAnimation = spriteSheet.createAnimationByColumn(
      column: 3,
      stepTime: 0.2,
    );

    anchor = Anchor.center;
    addHitbox(HitboxRectangle());

    animation = downAnimation;
    playing = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Zombie || other is Skeleton) {
      other.removeFromParent();
      hud.scoreText.setScore(10);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    speed = hud.runButton.buttonPressed ? runnungSpeed : walkingSpeed;

    if (!hud.joystick.delta.isZero()) {
      position.add(hud.joystick.relativeDelta * speed * dt);
      playing = true;
      movingToTouchLacation = false;

      switch (hud.joystick.direction) {
        case JoystickDirection.up:
        case JoystickDirection.upRight:
        case JoystickDirection.upLeft:
          animation = upAnimation;
          currentDirection = Character.up;
          break;
        case JoystickDirection.down:
        case JoystickDirection.downRight:
        case JoystickDirection.downLeft:
          animation = downAnimation;
          currentDirection = Character.down;
          break;
        case JoystickDirection.left:
          animation = leftAnimation;
          currentDirection = Character.left;
          break;
        case JoystickDirection.right:
          animation = rightAnimation;
          currentDirection = Character.right;
          break;
        case JoystickDirection.idle:
          animation = null;
          break;
      }
    } else {
      if (movingToTouchLacation) {
        position += (targetLocation - position).normalized() * (speed * dt);

        const threshold = 1.0;
        var difference = targetLocation - position;
        if (difference.x.abs() < threshold && difference.y.abs() < threshold) {
          stopAnimation();
          movingToTouchLacation = false;
          return;
        }

        playing = true;
        var angle = getAngle(position, targetLocation);
        if ((angle > 315 && angle < 360) || (angle > 0 && angle < 45)) {
          animation = rightAnimation;
          currentDirection = Character.right;
        } else if (angle > 45 && angle < 135) {
          animation = upAnimation;
          currentDirection = Character.down;
        } else if (angle > 135 && angle < 225) {
          animation = leftAnimation;
          currentDirection = Character.left;
        } else if (angle > 225 && angle < 315) {
          animation = downAnimation;
          currentDirection = Character.up;
        }
      } else {
        if (playing) {
          stopAnimation();
        }
      }
    }
  }

  void stopAnimation() {
    animation?.currentIndex = 0;
    playing = false;
  }

  void moveToLocation(Vector2 targetLocation) {
    this.targetLocation = targetLocation;
    movingToTouchLacation = true;
  }
}

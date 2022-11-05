import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:audioplayers/audioplayers.dart';

import '/utils/math_utils.dart';
import 'character.dart';
import 'hud/hud.dart';
import 'skeleton.dart';
import 'zombie.dart';

class George extends Character {
  final HudComponent hud;
  late final double walkingSpeed, runnungSpeed;
  late Vector2 targetLocation;
  bool movingToTouchLacation = false;
  bool isMoving = false;
  late AudioPlayer audioPlayerRunning;

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

    animation = downAnimation;
    playing = false;
    anchor = Anchor.center;

    add(RectangleHitbox());

    await FlameAudio.audioCache.loadAll(
      [
        'sounds/enemy_dies.wav',
        'sounds/running.wav',
        'sounds/coin.wav',
      ],
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Zombie || other is Skeleton) {
      other.removeFromParent();
      hud.scoreText.setScore(20);

      FlameAudio.play('sounds/coin.wav', volume: 1.0);
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);
    speed = hud.runButton.buttonPressed ? runnungSpeed : walkingSpeed;

    if (!hud.joystick.delta.isZero()) {
      position.add(hud.joystick.relativeDelta * speed * dt);
      playing = true;
      movingToTouchLacation = false;

      if (!isMoving) {
        isMoving = true;
        audioPlayerRunning = await FlameAudio.loopLongAudio(
          'sounds/running.wav',
          volume: 1.0,
        );
      }

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
        if (!isMoving) {
          isMoving = true;
          audioPlayerRunning = await FlameAudio.loopLongAudio(
            'sounds/running.wav',
            volume: 1.0,
          );
        }

        position += (targetLocation - position).normalized() * (speed * dt);

        const threshold = 1.0;
        var difference = targetLocation - position;
        if (difference.x.abs() < threshold && difference.y.abs() < threshold) {
          stopAnimation();

          audioPlayerRunning.stop();
          isMoving = false;

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
        if (isMoving) {
          isMoving = false;
          audioPlayerRunning.stop();
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

  void stopAnimations() {
    animation?.currentIndex = 0;
    playing = false;
  }

  @override
  void onPaused() {
    if (isMoving) {
      audioPlayerRunning.pause();
    }
  }

  @override
  void onResumed() async {
    if (isMoving) {
      audioPlayerRunning.resume();
    }
  }
}

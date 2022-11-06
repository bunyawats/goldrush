import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:audioplayers/audioplayers.dart';

import '/utils/math_utils.dart';
import 'character.dart';
import 'coin.dart';
import 'hud/hud.dart';
import 'skeleton.dart';
import 'zombie.dart';
import 'water.dart';

class George extends Character {
  final HudComponent hud;
  late final double walkingSpeed, runnungSpeed;
  late Vector2 targetLocation;
  bool movingToTouchedLocation = false;
  bool isMoving = false;
  late AudioPlayer audioPlayerRunning;
  int collisionDirection = Character.down;
  bool hasWaterCollided = false;

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

      FlameAudio.play('sounds/enemy_dies.wav', volume: 1.0);
    }

    if (other is Coin) {
      other.removeFromParent();
      hud.scoreText.setScore(20);

      FlameAudio.play('sounds/coin.wav', volume: 1.0);
    }

    if (other is Water) {
      if (movingToTouchedLocation) {
        movingToTouchedLocation = false;
      }
      if (!hasWaterCollided) {
        collisionDirection = currentDirection;
      }
      hasWaterCollided = true;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    hasWaterCollided = false;
  }

  void movePlayer(double delta) {
    if (!(hasWaterCollided && (collisionDirection == currentDirection))) {
      if (movingToTouchedLocation) {
        position
            .add((targetLocation - position).normalized() * (speed * delta));
      } else {
        switch (currentDirection) {
          case Character.left:
            position.add(Vector2(delta * -speed, 0));
            break;
          case Character.right:
            position.add(Vector2(delta * speed, 0));
            break;
          case Character.up:
            position.add(Vector2(0, delta * -speed));
            break;
          case Character.down:
            position.add(Vector2(0, delta * speed));
            break;
        }
      }
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);
    speed = hud.runButton.buttonPressed ? runnungSpeed : walkingSpeed;

    if (!hud.joystick.delta.isZero()) {
      movePlayer(dt);
      playing = true;
      movingToTouchedLocation = false;

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
      if (movingToTouchedLocation) {
        if (!isMoving) {
          isMoving = true;
          audioPlayerRunning = await FlameAudio.loopLongAudio(
            'sounds/running.wav',
            volume: 1.0,
          );
        }

        movePlayer(dt);

        const threshold = 1.0;
        var difference = targetLocation - position;
        if (difference.x.abs() < threshold && difference.y.abs() < threshold) {
          stopAnimation();

          audioPlayerRunning.stop();
          isMoving = false;

          movingToTouchedLocation = false;
          return;
        }

        playing = true;
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
    movingToTouchedLocation = true;
    setNewDirection(targetLocation);
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

  void setNewDirection(Vector2 targetLocation) {
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
  }
}

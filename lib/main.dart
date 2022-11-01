import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

import 'components/background.dart';
import 'components/character.dart';
import 'components/george.dart';
import 'components/skeleton.dart';
import 'components/zombie.dart';
import 'components/hud/hud.dart';

void main() async {
  final goldRush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(
    GameWidget(game: goldRush),
  );
}

class GoldRush extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.load('music/music.mp3');
    await FlameAudio.bgm.play(
      'music/music.mp3',
      volume: 0.1,
    );

    var hud = HudComponent();
    var george = George(
      hud: hud,
      position: Vector2(200, 400),
      size: Vector2(48.0, 48.0),
      speed: 40.0,
    );

    add(Backgroud(george));
    add(george);
    add(Zombie(
      position: Vector2(100, 200),
      size: Vector2(32.0, 64.0),
      speed: 20.0,
    ));
    add(Zombie(
      position: Vector2(300, 200),
      size: Vector2(32.0, 64.0),
      speed: 20.0,
    ));
    add(Skeleton(
      position: Vector2(100, 300),
      size: Vector2(32.0, 64.0),
      speed: 60.0,
    ));
    add(Skeleton(
      position: Vector2(300, 300),
      size: Vector2(32.0, 64.0),
      speed: 60.0,
    ));
    add(ScreenCollidable());
    add(hud);
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.clearAll();

    super.onRemove();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        for (var component in children) {
          if (component is Character) {
            component.onPaused();
          }
        }
        break;
      case AppLifecycleState.resumed:
        for (var component in children) {
          if (component is Character) {
            component.onResumed();
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}

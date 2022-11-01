import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import 'components/background.dart';
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
}

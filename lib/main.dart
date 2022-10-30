
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:goldrush/components/player.dart';

void main() async {
  final goldRush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(
    GameWidget(game: goldRush),
  );
}

class GoldRush extends FlameGame with HasCollidables {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Player());
    add(ScreenCollidable());
  }
}

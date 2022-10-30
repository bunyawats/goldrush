import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import 'components/background.dart';
import 'components/george.dart';

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
    add(Backgroud());
    add(George());
  }
}

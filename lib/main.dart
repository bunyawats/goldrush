import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:tiled/tiled.dart';

import 'components/background.dart';
import 'components/character.dart';
import 'components/coin.dart';
import 'components/george.dart';
import 'components/hud/hud.dart';
import 'components/skeleton.dart';
import 'components/tilemap.dart';
import 'components/water.dart';
import 'components/zombie.dart';
import 'utils/map_utils.dart';
import 'utils/math_utils.dart';
import 'widgets/screen_gameover.dart';
import 'widgets/screen_menu.dart';
import 'widgets/screen_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glod Rush',
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/gameover': (context) => const GameOverScreen(),
        '/game': (context) => GameWidget(
              game: GoldRush(),
            ),
      },
    ),
  );
}

class GoldRush extends FlameGame
    with
        HasDraggables,
        HasTappables,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    debugMode = false;

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);

    var musicVolume = 25.0;
    await SharedPreferences.getInstance()
        .then((prefs) => prefs.getDouble('musicVolume') ?? 25.0)
        .then((savedMusicVolume) => musicVolume = savedMusicVolume);

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play(
      'music/music.mp3',
      volume: musicVolume / 100,
    );

    final tiledMap = await TiledComponent.load(
      'tiles.tmx',
      Vector2.all(32),
    );
    add(TileMapComponent(tiledMap));

    List<Offset> barrierOffsets = [];
    final water = tiledMap.tileMap.getLayer<ObjectGroup>('Water');
    for (final tiled in water!.objects) {
      if (tiled.width == 32 && tiled.height == 32) {
        barrierOffsets.add(
          worldToGridOffset(Vector2(tiled.x, tiled.y)),
        );
      }
      add(
        Water(
          position: Vector2(
            tiled.x + gameScreenBounds.left,
            tiled.y + gameScreenBounds.top,
          ),
          size: Vector2(tiled.width, tiled.height),
          id: tiled.id,
        ),
      );
    }

    var hud = HudComponent();
    var george = George(
      barrierOffsets: barrierOffsets,
      hud: hud,
      position: Vector2(
        gameScreenBounds.left + 300,
        gameScreenBounds.top + 300,
      ),
      size: Vector2(32.0, 32.0),
      speed: 40.0,
    );
    add(george);
    children.changePriority(george, 15);

    add(Backgroud(george));
    add(hud);

    final enemies = tiledMap.tileMap.getLayer<ObjectGroup>('Enemies');
    for (int index = 0; index < enemies!.objects.length; index++) {
      TiledObject tiled = enemies.objects[index];
      if (index % 2 == 0) {
        var skeleton = Skeleton(
          player: george,
          position: Vector2(
            tiled.x + gameScreenBounds.left,
            tiled.y + gameScreenBounds.top,
          ),
          size: Vector2(32.0, 64.0),
          speed: 60.0,
        );
        children.changePriority(skeleton, 15);
        add(skeleton);
      } else {
        var zombie = Zombie(
          player: george,
          position: Vector2(
            tiled.x + gameScreenBounds.left,
            tiled.y + gameScreenBounds.top,
          ),
          size: Vector2(32.0, 64.0),
          speed: 20.0,
        );
        children.changePriority(zombie, 15);
        add(zombie);
      }
    }

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    for (int i = 0; i < 50; i++) {
      int randomX = random.nextInt(48) + 1;
      int randomY = random.nextInt(48) + 1;
      double posCoinX = (randomX * 32) + 5 + gameScreenBounds.left;
      double posCoinY = (randomY * 32) + 5 + gameScreenBounds.top;

      var coin = Coin(
        position: Vector2(posCoinX, posCoinY),
        size: Vector2(20, 20),
      );
      children.changePriority(coin, 15);
      add(coin);
    }

    camera.speed = 1;
    camera.followComponent(
      george,
      worldBounds: Rect.fromLTWH(
        gameScreenBounds.left,
        gameScreenBounds.top,
        1600,
        1600,
      ),
    );
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();

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

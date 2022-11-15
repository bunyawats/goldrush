import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '../../utils/math_utils.dart';
import 'health_text.dart';
import 'joystick.dart';
import 'run_button.dart';
import 'score_text.dart';

class HudComponent extends PositionComponent {
  late Joystick joystick;
  late RunButton runButton;
  late ScoreText scoreText;
  late HealthText healthText;
  bool isInitialised = false;

  HudComponent() : super(priority: 20);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    Rect gameScreenBounds = getGameScreenBounds(size);
    if (!isInitialised) {
      joystick = Joystick(
        knob: CircleComponent(
          radius: 20.0,
          paint: BasicPalette.blue.withAlpha(200).paint(),
        ),
        background: CircleComponent(
          radius: 40.0,
          paint: BasicPalette.blue.withAlpha(100).paint(),
        ),
        position: Vector2(
          gameScreenBounds.left + 100,
          gameScreenBounds.bottom - 80,
        ),
      );

      runButton = RunButton(
        button: CircleComponent(
          radius: 25.0,
          paint: BasicPalette.red.withAlpha(200).paint(),
        ),
        buttonDown: CircleComponent(
          radius: 25.0,
          paint: BasicPalette.red.withAlpha(100).paint(),
        ),
        position: Vector2(
          gameScreenBounds.right - 80,
          gameScreenBounds.bottom - 80,
        ),
        onPressed: () => {},
      );

      scoreText = ScoreText(
        position: Vector2(
          gameScreenBounds.left + 60,
          gameScreenBounds.top + 60,
        ),
      );

      healthText = HealthText(
        position: Vector2(
          gameScreenBounds.right - 200,
          gameScreenBounds.top + 60,
        ),
      );

      add(joystick);
      add(runButton);
      add(scoreText);
      add(healthText);

      positionType = PositionType.viewport;
      isInitialised = true;
    } else {
      joystick.position = Vector2(
        gameScreenBounds.left + 80,
        gameScreenBounds.bottom - 80,
      );
      runButton.position = Vector2(
        gameScreenBounds.right - 80,
        gameScreenBounds.bottom - 80,
      );
      scoreText.position = Vector2(
        gameScreenBounds.left + 80,
        gameScreenBounds.top + 60,
      );
      healthText.position = Vector2(
        gameScreenBounds.right - 200,
        gameScreenBounds.top + 60,
      );
    }
  }
}

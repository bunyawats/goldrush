import 'package:flame/components.dart';
import 'run_button.dart';
import 'score_text.dart';
import 'joystick.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class HudComponent extends PositionComponent {
  late Joystick joystick;
  late RunButton runButton;
  late ScoreText scoreText;

  HudComponent() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    joystick = Joystick(
      knob: CircleComponent(
        radius: 20.0,
        paint: BasicPalette.blue.withAlpha(200).paint(),
      ),
      background: CircleComponent(
        radius: 40.0,
        paint: BasicPalette.blue.withAlpha(100).paint(),
      ),
      magin: const EdgeInsets.only(
        left: 40,
        bottom: 40,
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
      margin: const EdgeInsets.only(
        right: 20,
        bottom: 50,
      ),
      onPressed: () => {},
    );

    scoreText = ScoreText(
      margin: const EdgeInsets.only(
        left: 40,
        top: 60,
      ),
    );

    add(joystick);
    add(runButton);
    add(scoreText);

    positionType = PositionType.viewport;
  }
}

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

class ScoreText extends HudMarginComponent {
  int score = 0;
  late TextComponent scoreTextComponent;

  ScoreText({Vector2? position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    scoreTextComponent = TextComponent(
      text: 'Score: $score',
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.blue.color,
          fontSize: 30.0,
        ),
      ),
    );
    add(scoreTextComponent);
  }

  void setScore(int s) {
    score += s;
    scoreTextComponent.text = 'Score: $score';
  }
}

import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'george.dart';

class Backgroud extends PositionComponent with Tappable {
  final George george;

  Backgroud(this.george);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(0, 0);
    size = Vector2(1600, 1600);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    george.moveToLocation(info.eventPosition.game);
    return true;
  }
}

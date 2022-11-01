import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Joystick extends JoystickComponent {
  Joystick({
    required PositionComponent knob,
    PositionComponent? background,
    EdgeInsets? magin,
  }) : super(
          knob: knob,
          background: background,
          margin: magin,
        );
}

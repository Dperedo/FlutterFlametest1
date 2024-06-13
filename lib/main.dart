import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flutter/material.dart';
import 'package:pruebasflame/components/player_sprite_sheet_component.dart';

class MyGame extends FlameGame
    with
        TapDetector,
        TapDetector,
        KeyboardEvents,
        TapDetector,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {

  @override
  void onLoad() {
    add(PlayerSpriteSheetComponent());
    add(ScreenHitbox());
  }
}

void main(List<String> args) {
  runApp(GameWidget(game: MyGame()));
}
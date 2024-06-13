import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class PlayerImageSpriteComponent extends SpriteComponent
    with KeyboardHandler, HasGameRef {
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteWidth = 512.0, spriteHeight = 512.0;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('tiger.png');

    screenWidth = gameRef.size.x;
    screenHeight = gameRef.size.y;

    size = Vector2(spriteWidth, spriteHeight);

    centerX = (screenWidth / 2) - (spriteWidth / 2);
    centerY = (screenHeight / 2) - (spriteHeight / 2);

    position = Vector2(centerX, centerY);

    return super.onLoad();
  }

  @override
  void update(double dt) {

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      //W
      position = Vector2(centerX, centerY--);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      //S
      position = Vector2(centerX, centerY++);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      // D
      position = Vector2(centerX++, centerY);
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      // A
      position = Vector2(centerX--, centerY);
    }
    return false;
  }
}
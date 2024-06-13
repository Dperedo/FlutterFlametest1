import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/components.dart';

import 'package:flutter/services.dart';

class PlayerSpriteSheetComponent extends SpriteAnimationComponent
    with TapCallbacks, KeyboardHandler, CollisionCallbacks, HasGameRef {
  late double screenWidth, screenHeight, centerX, centerY;
  final double spriteSheetWidth = 680, spriteSheetHeight = 472;
  int posX = 0, posY = 0;
  double playerSpeed = 500;

  int animationIndex = 0;

  bool right = true;

  late SpriteAnimation dinoDeadAnimation,
      dinoIdleAnimation,
      dinoJumpAnimation,
      dinoRunAnimation,
      dinoWalkAnimation;

  @override
  Future<void>? onLoad() async {

    anchor = Anchor.center;
    debugMode = true;

    final spriteImage = await Flame.images.load('dinofull.png');
    final spriteSheet = SpriteSheet(
        image: spriteImage,
        srcSize: Vector2(spriteSheetWidth, spriteSheetHeight));

    dinoDeadAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    dinoIdleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 2, step: 10, sizeX: 5, stepTime: .08);
    dinoJumpAnimation = spriteSheet.createAnimationByLimit(
        xInit: 3, yInit: 0, step: 12, sizeX: 5, stepTime: .08);
    dinoRunAnimation = spriteSheet.createAnimationByLimit(
        xInit: 5, yInit: 0, step: 8, sizeX: 5, stepTime: .08);
    dinoWalkAnimation = spriteSheet.createAnimationByLimit(
        xInit: 6, yInit: 2, step: 10, sizeX: 5, stepTime: .08);

    animation = dinoIdleAnimation;

    screenWidth = gameRef.size.x;
    screenHeight = gameRef.size.y;

    size = Vector2(spriteSheetWidth / 4, spriteSheetHeight / 4);

    centerX = (screenWidth / 2) - (spriteSheetWidth / 2);
    centerY = (screenHeight / 2) - (spriteSheetHeight / 2);

    position = Vector2(centerX, centerY);

    add(RectangleHitbox(
        size: Vector2(spriteSheetWidth / 4 - 70, spriteSheetHeight / 4),
        position: Vector2(25, 0)));

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.isEmpty) {
      animation = dinoIdleAnimation;
    }

    // correr
    if ((keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      animation = dinoRunAnimation;

      playerSpeed = 1500;

      if (!right) flipHorizontally();
      right = true;
      posX++;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      animation = dinoWalkAnimation;
      playerSpeed = 500;
      if (!right) flipHorizontally();
      right = true;
      posX++;
    }

    if ((keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA)) &&
        keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
      animation = dinoRunAnimation;

      playerSpeed = 1500;

      if (right) flipHorizontally();
      right = false;

      posX--;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      animation = dinoWalkAnimation;

      playerSpeed = 500;

      if (right) flipHorizontally();
      right = false;

      posX--;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      animation = dinoWalkAnimation;

      posY--;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      animation = dinoWalkAnimation;
      posY++;
    }

    return true;
  }

  @override
  void update(double dt) {
    position.x += playerSpeed * dt * posX;
    position.y += playerSpeed * dt * posY;
    posX = 0;
    posY = 0;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    print('colision');
    super.onCollision(points, other);
  }
}

extension CreateAnimationByLimit on SpriteSheet {
  SpriteAnimation createAnimationByLimit({
    required int xInit,
    required int yInit,
    required int step,
    required int sizeX,
    required double stepTime,
    bool loop = true,
  }) {
    final List<Sprite> spriteList = [];

    int x = xInit;
    int y = yInit - 1;

    for (var i = 0; i < step; i++) {
      if (y >= sizeX) {
        y = 0;
        x++;
      } else {
        y++;
      }

      spriteList.add(getSprite(x, y));
    }

    return SpriteAnimation.spriteList(spriteList,
        stepTime: stepTime, loop: loop);
  }
}
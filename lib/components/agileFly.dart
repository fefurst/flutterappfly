

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/game-loop.dart';

class AgileFly extends Fly {
  
  double get speed => gameLoop.tileSize * 5;

  AgileFly(GameLoop gameLoop, double x, double y) : super(gameLoop) {
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/agile-fly-1.png"));
    flyingSprite.add(Sprite("flies/agile-fly-2.png"));
    deadSprite = Sprite("flies/agile-fly-dead.png");

    flyRect = Rect.fromLTWH(
      x, 
      y, 
      gameLoop.tileSize * 1.5, 
      gameLoop.tileSize * 1.5);
  }
}
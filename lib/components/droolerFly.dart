

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/game-loop.dart';

class DroolerFly extends Fly {
  
  DroolerFly(GameLoop gameLoop, double x, double y) : super(gameLoop) {
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/drooler-fly-1.png"));
    flyingSprite.add(Sprite("flies/drooler-fly-2.png"));
    deadSprite = Sprite("flies/drooler-fly-dead.png");

    flyRect = Rect.fromLTWH(
      x, 
      y, 
      gameLoop.tileSize * 1, 
      gameLoop.tileSize * 1);
  }

}
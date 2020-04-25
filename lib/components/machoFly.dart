

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/game-loop.dart';

class MachoFly extends Fly {
  
  double get speed => gameLoop.tileSize * 2.2;

  MachoFly(GameLoop gameLoop, double x, double y) : super(gameLoop) {
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("flies/macho-fly-1.png"));
    flyingSprite.add(Sprite("flies/macho-fly-2.png"));
    deadSprite = Sprite("flies/macho-fly-dead.png");
    flyRect = Rect.fromLTWH(
      x, 
      y, 
      gameLoop.tileSize * 2.0, 
      gameLoop.tileSize * 2.0);
  }

}
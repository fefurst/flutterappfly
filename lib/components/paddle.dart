import 'dart:ui';
import 'package:flutterappfly/game-loop.dart';

class Paddle {
  Rect paddleRect;
  Paint paddlePaint;
  final GameLoop gameLoop;

  double x, y;
  int direction = 1;

  Paddle(this.gameLoop, this.x, this.y) {
    paddleRect = Rect.fromLTWH(x, y, gameLoop.tileSize * 2 , gameLoop.tileSize / 2);
    paddlePaint = Paint();
    paddlePaint.color = Color(0xff6ab04c);
  }

  void render(Canvas canvas) {
    canvas.drawRect(paddleRect, paddlePaint);
  }

  void update(double t) {
    x += 10*direction;
    if(x > gameLoop.screenSize.width-(gameLoop.tileSize * 2)) {
      direction *=-1;
    }
    if(x < 0) {
      direction *=-1;
    }
    paddleRect = Rect.fromLTWH(x, y, gameLoop.tileSize * 2 , gameLoop.tileSize / 2);
  }
}
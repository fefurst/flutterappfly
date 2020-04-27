import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:flutterappfly/components/fly.dart';

class Life {
  final Fly fly;
  Rect rect;
  Sprite sprite;
  double value;

  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Life(this.fly) {
    sprite = Sprite('ui/callout.png');
    value = 1;
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 15,
    );
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
    tp.paint(c, textOffset);  
  }

  void update(double t) {
    rect = Rect.fromLTWH(
      fly.flyRect.left - (fly.gameLoop.tileSize * -0.75),
      fly.flyRect.top - (fly.gameLoop.tileSize * 0.5),
      fly.gameLoop.tileSize * .75,
      fly.gameLoop.tileSize * .75,
    );
    tp.text = TextSpan(
      text: (fly.life).toInt().toString(),
      style: textStyle,
    );
    tp.layout();
    textOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.top + (rect.height * .4) - (tp.height / 2),
    );
  }

  
}
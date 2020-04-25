import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappfly/bgm.dart';
import 'package:flutterappfly/components/agileFly.dart';
import 'package:flutterappfly/components/backyard.dart';
import 'package:flutterappfly/components/credits-button.dart';
import 'package:flutterappfly/components/droolerFly.dart';
import 'package:flutterappfly/components/fly.dart';
import 'package:flutterappfly/components/help-button.dart';
import 'package:flutterappfly/components/highscore-display.dart';
import 'package:flutterappfly/components/houseFly.dart';
import 'package:flutterappfly/components/hungryFly.dart';
import 'package:flutterappfly/components/machoFly.dart';
import 'package:flutterappfly/components/music-button.dart';
import 'package:flutterappfly/components/score-display.dart';
import 'package:flutterappfly/components/sound-button.dart';
import 'package:flutterappfly/controllers/spawner.dart';
import 'package:flutterappfly/view.dart';
import 'package:flutterappfly/views/credits-view.dart';
import 'package:flutterappfly/views/help-view.dart';
import 'package:flutterappfly/views/home-view.dart';
import 'package:flutterappfly/components/start-button.dart';
import 'package:flutterappfly/views/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutterappfly/components/paddle.dart';


class GameLoop extends Game {

  final SharedPreferences storage;

  View activeView = View.home;

  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;

  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;

  MusicButton musicButton;
  SoundButton soundButton;

  ScoreDisplay scoreDisplay;

  FlySpawner spawner;

  Size screenSize;  
  double tileSize;
  List<Fly> flies;

  //Paddle paddleLeft;
  //Paddle paddleRight;

  HighscoreDisplay highscoreDisplay;
  int score;

  Random rnd;

  Backyard backyard;

  GameLoop(this.storage) {
    initialize();
  }

  void initialize() async {

    score = 0;

    rnd = Random();
    flies = List<Fly>();
    resize(await Flame.util.initialDimensions());

    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);

    spawner = FlySpawner(this);

    backyard = Backyard(this);

    highscoreDisplay = HighscoreDisplay(this);
    scoreDisplay = ScoreDisplay(this);

    await BGM.add('bgm/home.mp3');
    await BGM.add('bgm/playing.mp3');
    playMusic();
        
  }

  void playMusic() async {
    if(musicButton.isEnabled) {
      //await BGM.stop();
      await BGM.play(0);
    }
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 2.0);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.0);

    switch(rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(AgileFly(this, x, y));
        break;
      case 2:
        flies.add(HungryFly(this, x, y));
        break;
      case 3:
        flies.add(DroolerFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  //void spawnPaddles() {

    //paddleLeft = Paddle(this, 0.0, 0.0);
    //paddleRight = Paddle(this, 0.0, (screenSize.height - tileSize/2));

  //}


  void render(Canvas canvas) {
    backyard.render(canvas);
    highscoreDisplay.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);

    flies.forEach((fly) {
      fly.render(canvas);
    });

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }

    if(activeView != View.help && activeView != View.credits) {
      musicButton.render(canvas);
      soundButton.render(canvas);
    }

    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);

  }

  void update(double t) {

    backyard.update(t);

    spawner.update(t);

    flies.forEach((fly) {
      fly.update(t);
    });

    flies.removeWhere((fly) => fly.isOffScreen);

    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {

    screenSize = size;
    super.resize(size);

    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails details) {

    // dialog boxes
    if (activeView == View.help || activeView == View.credits) {
      activeView = View.home;
      return;
    }
    else {
      // music button
      if (musicButton.rect.contains(details.globalPosition)) {
        musicButton.onTapDown();
        return;
      }

      // sound button
      if (soundButton.rect.contains(details.globalPosition)) {
        soundButton.onTapDown();
        return;
      }
    }
    

    // help button
    
    if (helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        return;
      }
    }

    // credits button
    if (creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        return;
      }
    }

    if (startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        return;
      }
    }
  
    bool didHitAFly = false;
    List<Fly>.from(flies).forEach((fly) {
      if(fly.flyRect.contains(details.globalPosition) && !fly.isDead) {
        fly.onTapDown();
        didHitAFly = true;
      }
    });
    if (activeView == View.playing && !didHitAFly) {
      if (soundButton.isEnabled) {
        Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
      }
      
      playMusic();
      activeView = View.lost;
    }
    return;

  }

  

}

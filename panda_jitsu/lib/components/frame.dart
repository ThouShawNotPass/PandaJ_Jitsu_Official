// TODO - Make the card tray scale with size of screen

import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:panda_jitsu/jitsu_game.dart';

// This is the frame the outlines the dojo background, including the card tray.
// Note: Most mobile devices have a screen width of 9:12-18.5 so our bg is 9:23.
class Frame {
	final JitsuGame game;
  Rect frameRect;
	Sprite frameSprite;

	Frame(this.game) {
		frameSprite = Sprite('background/frame-with-tray.png');
		frameRect = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
	}

	void render(Canvas c) {
		frameSprite.renderRect(c, frameRect);
	}

	void update(double t) {}
}
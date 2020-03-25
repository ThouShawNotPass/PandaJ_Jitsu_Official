import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This is the dojo background class which defines behavior for the background.
// Note: Most mobile devices have a screen width of 9:12-18.5 so our bg is 9:23.
class Dojo {
	final JitsuGame game;
  Rect bgRect;
	Sprite bgSprite;

	Dojo(this.game) {
		bgSprite = Sprite('background/dojo-no-tray.png');
		// for a background image 1080:2760px (9:23)
		bgRect = Rect.fromLTWH(
			game.screenSize.width / 2 - (game.tileSize * 11.5), // Left: center the image on screen
			0, // Top: starts on top edge
			game.tileSize * 23, // width: full width
			game.screenSize.height // Height: full height
		);
	}

	void render(Canvas c) {
		bgSprite.renderRect(c, bgRect);
	}

	void update(double t) {}
}
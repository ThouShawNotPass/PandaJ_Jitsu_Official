import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:panda_jitsu/jitsu_game.dart';

// This class will handle the bottom part of the screen, including where cards should be diverted and keeps track of empty slots as cards are selected.
class Tray {

	final JitsuGame game;
	List<Offset> slots;
  	Rect bgRect;
	Sprite bgSprite;
	
	Tray(this.game) {
		slots = [
			Offset(
				deck.screenCenter.dx - (game.tileSize * 6.75), 
				deck.screenCenter.dy + (game.tileSize * 2.35)
			)
		];
		bgSprite = Sprite('background/dojo-no-tray.png');
		bgRect = Rect.fromLTWH(
			game.screenSize.width / 2 - (game.tileSize * 11.5), // Left: center the image on screen
			0, // Top: starts on top edge
			game.tileSize * 23, // width: full width
			game.screenSize.height // Height: full height
		);
	}
}
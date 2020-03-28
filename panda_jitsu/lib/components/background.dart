import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:panda_jitsu/jitsu_game.dart';

/// This is the background class which defines state of the background.
/// 
/// ### Screen Size: 
/// Most mobile devices have a screen ratio somewhere between 12:9 and 18.5:9 so our bg has a 23:9 ratio and is horizontally centered with the left and right edges cropped off.
class Background {

	/// The image ratio (measured in tiles).
	static const Size bgRatio = Size(23, 9); 

	/// A reference to the JitsuGame object.
	final JitsuGame game;

	/// The shape of the entire background.
	/// 
	/// Part of this rectangle will be off the screen, and that is okay. Currently this is set for a 9:23 background image (2760:1080px).
  	Rect bgRect;

	/// The background Sprite asset.
	Sprite bgSprite = Sprite('background/dojo-no-tray.png');

	/// Constructs a new Background obejct.
	Background(this.game) {
		bgRect = Rect.fromCenter(
			center: game.screenSize.center(Offset.zero), // center of screen
			width: game.tileSize * bgRatio.width, // width of image
			height: game.screenSize.height // height of screen
		);
	}

	/// Draws the background to the screen.
	void render(Canvas c) {
		bgSprite.renderRect(c, bgRect);
	}
}
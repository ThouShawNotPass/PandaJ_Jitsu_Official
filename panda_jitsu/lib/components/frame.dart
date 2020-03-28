import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:panda_jitsu/jitsu_game.dart';

/// Outlines the screen.
/// 
/// This is the frame the outlines the background, including the card tray.
/// 
/// ### Screen Size: 
/// Most mobile devices have a screen ratio somewhere between 12:9 and 18.5:9 so our frame has a ratio of 9:15 which is half way between those two values. This means the asset will be distorted slightly, but that distortion will not be noticable on most devices.
class Frame {
	/// A reference to the JitsuGame object.
	final JitsuGame game;
  	
	/// The rectangular area of the frame.
	Rect frameRect;

	/// The Sprite asset of the frame.
	Sprite frameSprite;

	/// Constructs a new Frame object.
	Frame(this.game) {
		frameSprite = Sprite('background/frame.png');
		frameRect = Offset.zero & game.screenSize;
		// same as Rect(0, 0, game.screenSize.width, game.screenSize.height)
	}

	/// Draws the frame to the screen.
	void render(Canvas c) {
		frameSprite.renderRect(c, frameRect);
	}
}
import 'package:flame/flame.dart';
import 'package:flame/util.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:panda_jitsu/jitsu_game.dart';

/// The initial method to run the app.
void main() async {
	// This is 'the glue that binds the framework to the Flutter engine'.
	WidgetsFlutterBinding.ensureInitialized();

	// Make full screen and portrait mode (lock)
	Util flameUtil = Util();
	await flameUtil.fullScreen();
	await flameUtil.setOrientation(DeviceOrientation.landscapeRight);

	// Load all assets (cached in a static variable in Flame to reuse later)
	Flame.images.loadAll(<String>[
		// BACKGROUNDS
		'background/dojo.png',
		'background/frame.png',
		'background/tray.png',
		'background/help.png',

		// BELTS
		'belts/white-belt.png',
		'belts/yellow-belt.png',
		'belts/orange-belt.png',
		'belts/green-belt.png',
		'belts/blue-belt.png',
		'belts/red-belt.png',
		'belts/purple-belt.png',
		'belts/brown-belt.png',
		'belts/black-belt.png',

		// BRANDING
		'branding/logo-beige.png',
		'branding/logo-orange.png',
		'branding/logo-white.png',

		// MODALS
		'modals/instructions.png',
		'modals/legend.png',

		// CARDS
		'cards/base/back-side.png',
		'cards/base/fire-card.png',
		'cards/base/sensei-back.png',
		'cards/base/snow-card.png',
		'cards/base/water-card.png',
		'cards/elements/fire.png',
		'cards/elements/snow.png',
		'cards/elements/water.png',
		'cards/levels/1.png',
		'cards/levels/2.png',
		'cards/levels/3.png',
		'cards/levels/4.png',
		'cards/levels/5.png',
		'cards/levels/6.png',
		'cards/levels/7.png',
		'cards/levels/8.png',
		'cards/levels/9.png',
		'cards/levels/10.png',
		'cards/levels/11.png',
		'cards/levels/12.png',
		'cards/overlay/blue-card.png',
		'cards/overlay/green-card.png',
		'cards/overlay/orange-card.png',
		'cards/overlay/purple-card.png',
		'cards/overlay/red-card.png',
		'cards/overlay/yellow-card.png',
		
		// TOKENS
		'tokens/blue-token.png',
		'tokens/green-token.png',
		'tokens/orange-token.png',
		'tokens/purple-token.png',
		'tokens/red-token.png',
		'tokens/yellow-token.png',
	]);

	// Create a new instance of the game object
	JitsuGame game = JitsuGame();
	runApp(game.widget);

	// Create a gesture recogniser and pass it to game object
	TapGestureRecognizer tapper = TapGestureRecognizer();
	tapper.onTapDown = game.onTapDown;
	flameUtil.addGestureRecognizer(tapper);
}
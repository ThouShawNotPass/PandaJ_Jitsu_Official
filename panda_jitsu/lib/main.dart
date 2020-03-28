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
		'background/dojo.png',
		'background/dojo-no-tray.png',
		'background/frame.png',
		'background/frame-with-tray.png',
		'background/tray.png',
		'background/help.png',
		'belts/white-belt.png',
		'belts/yellow-belt.png',
		'belts/orange-belt.png',
		'belts/green-belt.png',
		'belts/blue-belt.png',
		'belts/red-belt.png',
		'belts/purple-belt.png',
		'belts/brown-belt.png',
		'belts/black-belt.png',
		'branding/logo-beige.png',
		'branding/logo-orange.png',
		'branding/logo-white.png',
		'modals/instructions.png',
		'modals/legend.png'
	]);

	// Create a new instance of the game object
	JitsuGame game = JitsuGame();
	runApp(game.widget);

	// Create a gesture recogniser and pass it to game object
	TapGestureRecognizer tapper = TapGestureRecognizer();
	tapper.onTapDown = game.onTapDown;
	flameUtil.addGestureRecognizer(tapper);
}
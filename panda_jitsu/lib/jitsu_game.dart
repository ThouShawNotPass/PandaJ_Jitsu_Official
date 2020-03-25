import 'dart:ui'; // access to Canvas and Size
import 'dart:math'; // for random integer generation

import 'package:flame/flame.dart'; // access Flame Util's initialDimensions
import 'package:flame/game.dart'; // access Flame Game-Loop scaffolding
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart'; // individual card
import 'package:panda_jitsu/cards/deck.dart'; // the deck object
import 'package:panda_jitsu/components/dojo.dart'; // background
import 'package:panda_jitsu/components/frame.dart'; // frame

// This is a JitsuGame class that has gameloop logic to control a jitsu game. 
// It overrides the basic (empty) Game methods 'render' && 'update'.
class JitsuGame extends Game {

	Size screenSize; // the size of the current device's screen
	double tileSize; // the tile size for current screen resolution (we are currently basing this off of one-ninth of the screen's height)
	Dojo background;
	Frame frame;
	Deck deck;
	Random rand; // generates new random integers

	JitsuGame() {
		initialize(); // constructors cannot be async but this function can be
	}

	// Initialize the game. Should be called exactly once, using async to wait for screenSize via initialDimensions() method call
	void initialize() async {
		resize(await Flame.util.initialDimensions()); // get dimensions of the current screen (returns a Future<Size> object)
		
		// Create instances of our objects
		deck = Deck(this);
		deck.add(Card.basic(this, deck));
		background = Dojo(this);
		frame = Frame(this);
		
	}

	// Calculates the size of the current screen and updates instance variable. This method is typically only called when the screen size changes, such as when the device is rotated by the user.
	void resize(Size size) {
		screenSize = size;
		tileSize = size.height / 9; // the screen will be 9 'tiles' high
	}

	// Paints the components to the next canvas
	void render(Canvas canvas) {
		background.render(canvas); // draw background
		frame.render(canvas); // draw the frame
		deck.render(canvas); // draw the deck
	}

	// update the position of the components before next render
	void update(double t) {}

	// this is called when we are passed a tap event
	void onTapDown(TapDownDetails d) {}
}
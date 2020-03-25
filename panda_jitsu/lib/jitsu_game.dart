import 'dart:ui'; // access to Canvas and Size
import 'dart:math'; // for random integer generation
import 'package:flame/flame.dart'; // access Flame Util's initialDimensions
import 'package:flame/game.dart'; // access Flame Game-Loop scaffolding
import 'package:flutter/gestures.dart';
import 'package:panda_jitsu/components/dojo.dart'; // import the background
import 'package:panda_jitsu/components/frame.dart'; // import the frame
import 'package:panda_jitsu/components/card.dart'; // import the cards

// This is a JitsuGame class that has gameloop logic in it to control a jitsu game. 
// It overrides the basic (empty) Game methods 'render' && 'update'.
class JitsuGame extends Game {
	Size screenSize; // the size of the current device's screen
	double tileSize; // the tile size for current screen resolution (1/9th screen height)
	Dojo background;
  Frame frame;
	Card card;
	Random rand; // generates new random integers

	JitsuGame() {
		initialize(); // constructors cannot be async but this function can be
	}

  // Initialize the game. Should be called exactly once, using async to wait for screenSize
	void initialize() async {
		resize(await Flame.util.initialDimensions()); // get dimensions (returns Future<Size>)
		
		background = Dojo(this);
    frame = Frame(this);
		card = Card(this);
	}

  // Calculates the size of the current screen and updates instance variable
	void resize(Size size) {
		screenSize = size;
		tileSize = size.height / 9; // the screen will be 9 'tiles' high
	}

	// Paints the new canvas
	void render(Canvas canvas) {
		background.render(canvas); // draw background
    frame.render(canvas); // draw the frame
		card.render(canvas); // draw a card
	}

	void update(double t) {}

	void onTapDown(TapDownDetails d) {}
}
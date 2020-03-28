import 'dart:ui'; // access to Canvas and Size
import 'dart:math'; // for random integer generation

import 'package:flame/flame.dart'; // access Flame Util's initialDimensions
import 'package:flame/game.dart'; // access Flame Game-Loop scaffolding
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart'; // individual card
import 'package:panda_jitsu/cards/deck.dart'; // the deck object
import 'package:panda_jitsu/components/dojo.dart'; // background
import 'package:panda_jitsu/components/frame.dart'; // frame
import 'package:panda_jitsu/components/tray.dart'; // card tray
import 'package:panda_jitsu/element.dart'; // the element

/// A basic JitsuGame controller.
/// 
/// This is a JitsuGame class that has gameloop logic to control a jitsu game. It overrides the basic (empty) Game methods 'render' && 'update'.
class JitsuGame extends Game {

	/// Which side the player should go on.
	static const playerOnLeft = false;

	/// The number of vertical sections the screen is split into.
	static const double verticalSections = 9;

	/// The number of cards in each player's hand.
	static const int numCardsInHand = 5;

	/// The number of cards to generate for each deck.
	static const int numCardsInDeck = 10;


	/// A reference to the player's deck.
	Deck myDeck;

	/// A reference to the opponent's deck.
	Deck theirDeck;

	/// The number of pixels per tile.
	double tileSize;

	/// The background dojo Sprite.
	Dojo background;

	/// The border Sprite that lines the edge of the screen.
	Frame frame;

	/// A random number generator.
	/// 
	/// Note: This should be the only [Random()] object that is generated througout the entire game as each subclass should be passed access to this instance variable, rather than creating their own copy each time.
	Random rand;

	/// The size of the current device's screen
	Size screenSize;

	/// The bottom Sprite that holds the cards.
	/// 
	/// The tray section handles the majority of card positioning logic and animations. Limit one per game.
	Tray tray;


	/// Constructs a new JitsuGame object.
	JitsuGame() {
		rand = Random();
		_initialize(); 
	}

	/// Initialize the game. Should be called exactly once, using async to wait for screenSize via initialDimensions() method call.
	void _initialize() async {
		resize(await Flame.util.initialDimensions());

		// Create instances of our objects
		background = Dojo(this); // bg
		frame = Frame(this); // frame

		myDeck = Deck(this); // deck
		_loadDeckFromUser(myDeck);
		myDeck.shuffle(); // shuffle the deck

		theirDeck = Deck.opponent(this); // deck
		_loadDeckFromUser(theirDeck);
		theirDeck.shuffle(); // shuffle the deck

		tray = Tray(this, myDeck, numCardsInHand, theirDeck, numCardsInHand);
	}

	/// Returns a random Element type.
	Element _getRandomElement() {
		Element result;
		switch (rand.nextInt(3)) { // the three elements of nature
			case 0:
				result = Element.fire;
				break;
			case 1:
				result = Element.water;
				break;
			case 2:
				result = Element.snow;
				break;
		}
		return result;
	}

	/// Loads the given user's deck of cards.
	void _loadDeckFromUser(Deck deck) {
		for (int i = 0; i < numCardsInHand; i++) {
			deck.add(Card(
				this, 
				deck, 
				_getRandomElement(), 
				rand.nextInt(numCardsInDeck), 
				deck.isMyCard()
			));
		}
	}

	/// Returns whether the player should be on the left.
	bool isPlayerOnLeft() => playerOnLeft;

	/// Calculates the size of the current screen and updates instance variable. 
	/// 
	/// This method is typically only called when the screen size changes, such as when the device is rotated by the user.
	void resize(Size size) {
		screenSize = size;
		tileSize = size.height / verticalSections; // the screen will be 9 'tiles' high
	}

	/// Paints the components to the next canvas.
	void render(Canvas canvas) {
		background.render(canvas); // draw background
		frame.render(canvas); // draw the frame
		tray.render(canvas);
	}

	/// Updates the state of the components.
	void update(double t) {
		tray.update(t);
	}

	/// Handles an onTapDown event.
	void onTapDown(TapDownDetails d) {
		tray.handleTouchAt(d.globalPosition);
	}
}
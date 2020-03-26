import 'dart:ui'; // for basic dart objects (Rect, Paint, Canvas)

import 'package:flame/position.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/jitsu_game.dart';


// The Deck class handles a list of cards but abstracts away many of the list components, exposing only the queue-like structures. It is implemented as a list because the list class has a built-in shuffle() function. 
// ? Can this be implemented as a Queue<Card> rather than List<Card>?

class Deck {

	static const alignLeft = true; // which side the player should go on

	final JitsuGame game; // reference to the game logic

	bool isPrimary; // true if player owns the deck, false if opponent
	List<Card> cards; // private queue-like data structure
	Position screenCenter;
	Size cardSize;

	// Constructor - initialize a reference to the game
	Deck(this.game) {
		cards = List<Card>();
		screenCenter = Position(
			game.screenSize.width / 2, 
			game.screenSize.height / 2
		);
		double width = game.tileSize * 1.4;
		cardSize = Size(width, width * 1.2);
		isPrimary = alignLeft;
	}

	// Constructor - initialize a reference to the game
	Deck.opponent(this.game) {
		cards = List<Card>();
		screenCenter = Position(
			game.screenSize.width / 2, 
			game.screenSize.height / 2
		);
		double width = game.tileSize * 0.70;
		cardSize = Size(width, width * 1.2);
		isPrimary = !alignLeft;
	}

	// Randomizes the order of the deck (shuffling the cards)
	void shuffle() {		
		cards.shuffle();
	}

	// Return true if the deck contains no cards.
	bool isEmpty() {
		return cards.isEmpty;
	}

	// Removes and returns the first Card in the deck. This method will return null if the deck is empty.
	Card draw() {
		Card result;
		if (cards.isNotEmpty) {
			result = cards.removeAt(0);
		}
		return result;
	}

	// Adds the given card to the bottom of the deck structure.
	void add(Card newCard) {
		cards.add(newCard);
	}

	// The cards in the deck are not rendered (off screen)
	void render(Canvas c) {}

	// The cards in the deck are not updated (off screen)
	void update(Canvas c) {}
}
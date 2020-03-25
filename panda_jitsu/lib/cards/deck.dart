import 'dart:ui'; // for basic dart objects (Rect, Paint, Canvas)

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/jitsu_game.dart';


// The Deck class handles a list of cards but abstracts away many of the list components, exposing only the queue-like structures. It is implemented as a list because the list class has a built-in shuffle() function. 
// ? Can this be implemented as a Queue<Card> rather than List<Card>?

class Deck {

	final JitsuGame game; // reference to the game logic
	Offset screenCenter;
	List<Card> cards; // private queue-like data structure

	// Constructor - initialize a reference to the game
	Deck(this.game) {
		cards = List<Card>();
		screenCenter = Offset(
			game.screenSize.width / 2, 
			game.screenSize.height / 2
		);
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
	Card remove() {
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

	// Paints each card in the deck to the center of the screen
	void render(Canvas c) {
		if (cards == null) {
			print('null');
		} else if (cards.isEmpty) {
			print('isEmpty');	
		} else {
			cards.forEach((Card card) => card.render(c));
		}
	}
}
import 'dart:ui';

import 'package:flame/position.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/jitsu_game.dart';


/// A deck of cards.
/// 
/// Abstracts away many of the list components, exposing only the queue-like structures. It is implemented as a list because the list class has a built-in shuffle() function.
class Deck {

	/// A reference to the game logic.
	final JitsuGame game;


	/// True if the deck is on the left side, false otherwise.
	bool alignLeft;

	/// True is card is owned by the player, false otherwise.
	bool isMine;

	/// Queue-like deck structure to keep track of the cards.
	List<Card> cards;

	/// The center of the device's screen.
	Position screenCenter;

	/// The size of a basic card.
	/// 
	/// Note: This size might end up changing based on the deck.
	Size cardSize;

	/// Constructs a new deck object for the player.
	Deck(this.game) {
		cards = List<Card>();
		screenCenter = Position(
			game.screenSize.width / 2, 
			game.screenSize.height / 2
		);
		double width = game.tileSize * 1.4;
		cardSize = Size(width, width * 1.2);
		alignLeft = game.isPlayerOnLeft();
		isMine = true; // my deck
	}

	/// Constructs a new deck object for the opponent.
	Deck.opponent(this.game) {
		cards = List<Card>();
		screenCenter = Position(
			game.screenSize.width / 2, 
			game.screenSize.height / 2
		);
		double width = game.tileSize * 0.70;
		cardSize = Size(width, width * 1.2);
		alignLeft = !game.isPlayerOnLeft();
		isMine = false; // their deck
	}

	/// Randomizes the order of the deck.
	void shuffle() => cards.shuffle();

	/// Returns true if the deck contains no cards.
	bool isEmpty() => cards.isEmpty;

	/// Returns true if the deck is owned by the player.
	bool isMyCard() => isMine;

	/// Returns the number of cards in the deck.
	int size() => cards.length;

	/// Removes and returns the first Card in the deck. 
	/// 
	/// Note: This method will throw a FormatException if the deck is empty.
	Card draw() {
		Card result;
		if (cards.isEmpty) {
			throw new FormatException('The deck was empty!');
		} else {
			result = cards.removeAt(0);
		}
		return result;
	}

	// Adds the given card to the bottom of the deck structure.
	void add(Card newCard) {
		cards.add(newCard);
	}

	// The cards in the deck are not rendered (off screen)
	//void render(Canvas c) {}

	// The cards in the deck are not updated (off screen)
	//void update(Canvas c) {}
}
import 'dart:ui';

import 'package:flame/position.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/card_status.dart';
import 'package:panda_jitsu/jitsu_game.dart';


/// A deck of cards.
/// 
/// Abstracts away many of the list components, exposing only the queue-like structures. It is implemented as a list because the list class has a built-in shuffle() function.
class Deck {

	/// The width of a card in tiles.
	static const double widthFactor = 1.4;

	/// The ratio of width to height of a card.
	/// 
	/// Example: If a card had a width of 10, it would have a height of 12 because 10 * 1.2 = 12.
	static const double cardRatio = 1.2;
	
	
	/// A reference to the game logic.
	final JitsuGame game;


	/// True if the deck is on the left side, false otherwise.
	bool alignLeft;

	/// True is card is owned by the player, false otherwise.
	bool isMine;

	/// Queue-like deck structure to keep track of the cards.
	List<Card> cards = List<Card>();

	/// The center of the device's screen.
	Position screenCenter;

	/// The size of a basic card.
	/// 
	/// Note: This size might end up changing based on the deck.
	Size cardSize;

	/// Constructs a new deck object for the player.
	Deck(this.game) {
		_setScreenCenter();
		_setCardSizeFromWidth(game.tileSize * widthFactor);
		alignLeft = game.isPlayerOnLeft();
		isMine = true; // my deck
	}

	/// Constructs a new deck object for the opponent.
	Deck.opponent(this.game) {
		_setScreenCenter();
		_setCardSizeFromWidth(game.tileSize * widthFactor / 2); // half size
		alignLeft = !game.isPlayerOnLeft();
		isMine = false; // opponent's deck
	}

	/// Sets the center of the screen.
	void _setScreenCenter() {
		screenCenter = Position.fromOffset(game.screenSize.center(Offset.zero));
	}

	/// Sets the card size from the given width.
	void _setCardSizeFromWidth(double width) {
		cardSize = Size(width, width * cardRatio);
	}

	/// Randomizes the order of the deck.
	void shuffle() => cards.shuffle();

	/// Returns true if the deck contains no cards.
	bool isEmpty() => cards.isEmpty;

	/// Returns true if the deck is owned by the player.
	bool isMyCard() => isMine;

	/// Returns the number of cards in the deck.
	int size() => cards.length;

	/// Returns the card ratio.
	double getCardRatio() => cardRatio;

	/// Returns the inverse of the card ratio.
	double getInverseCardRatio() => 1 / cardRatio;

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

	/// Adds card to deck.
	/// 
	/// This will also set the CardStatus to CardStatus.inDeck and reset the size of the card.
	void add(Card c) {
		c.setTargetLocation(Position( 
			(screenCenter.x) - (cardSize.width / 2), // centered
			(game.screenSize.height) // off the bottom of the screen
		));
		c.setTargetSize(cardSize);
		c.setShape(c.targetLocation, c.targetSize);
		c.setCardStatus(CardStatus.inDeck);
		cards.add(c);
	}
}
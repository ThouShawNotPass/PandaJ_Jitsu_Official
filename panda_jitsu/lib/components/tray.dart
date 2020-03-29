import 'dart:ui';
import 'dart:io';

import 'package:flame/anchor.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/card_status.dart';
import 'package:panda_jitsu/jitsu_game.dart';

/// The card container on bottom of screen.
/// 
/// This class will handle the bottom part of the screen, including where cards should be diverted and keeps track of empty mySlots as cards are selected.
class Tray {

	/// The padding factor between cards in the tray.
	/// 
	/// This padding has a default value of 1.2.
	static const double cardPadding = 1.2;

	/// The padding between the tray and ths card slot (measured in tiles).
	static const Offset slotPadding = Offset(0.70, 0.43);

	/// The size of the text.
	/// 
	/// Default: 20.0
	static const double textSize = 20.0;

	/// The padding between the edges of the screen and the tray position (measured in tiles).
	/// 
	/// The trayPadding has a default value of 1 tile from the left edge and 6.25 tiles from the top.
	static const Offset trayPadding = Offset(1, 6.25);

	/// The padding between the tray and textArea (measured in tiles).
	static const Offset textPadding = Offset(0.70, 0.35);

	/// The configuration of the text on screen.
	static const TextConfig config = TextConfig(
		color: Color(0xFF000000),
		fontSize: textSize, 
		fontFamily: 'Julee'
	);

	/// The player's deck of cards.
	final Deck myDeck;

	/// The opponent's deck of cards.
	final Deck comDeck;

	/// The players number of card slots available.
	final int mySize;

	/// The opponent's number of card slots available.
	final int comSize;

	/// A reference to the JitsuGame object.
	final JitsuGame game;

	// The opponent's middle 'pot' card.
	Card comPot;

	/// The player's middle 'pot' card.
	Card myPot;

	/// Whether the opponent's pot card has been flipped.
	/// 
	/// This boolean defaults to a value of false.
	bool hasBeenFlipped = false; 

	/// A list of cards in the opponent's hand.
	List<Card> comSlots;

	/// A list of cards in the player's hand.
	List<Card> mySlots;

	/// The top left position of the tray.
	Position trayPos;

	/// The rectangular area of the tray.
  	Rect trayArea;

	/// The opponent's username.
	String comName;

	/// The player's username.
	String myName;

	/// The sprite image used as the tray background.
	/// 
	/// This asset is currently located at background/tray.png
	Sprite traySprite = Sprite('background/tray.png');
	
	/// Constructs a new Tray object.
	Tray(this.game, this.myDeck, this.mySize, this.comDeck, this.comSize) {
		comSlots = List<Card>(comSize);
		mySlots = List<Card>(mySize);
		trayPos = Position(
			game.tileSize * trayPadding.dx, // padding from left edge
			game.tileSize * trayPadding.dy // padding from top edge
		);
		trayArea = Rect.fromLTWH(
			trayPos.x,
			trayPos.y,
			game.screenSize.width - trayPos.x * 2, // equal padding left/right
			game.screenSize.height - trayPos.y // extend to bottom of screen
		);
		comName = "GRASSHOPPER";
		myName = "SENSEI";
	}

	/// Returns whether the pot is empty or not.
	bool _potIsEmpty() {
		return myPot == null && comPot == null;
	}

	/// Returns whether the cards have loaded.
	bool _slotHasLoaded(List<Card> slot) {
		return slot != null && slot.isNotEmpty;
	}

	/// Returns whether both player's cards are in the middle 'pot'.
	bool bothCardsReady() {
		bool myCardReady = myPot != null && myPot.isDoneMoving();
		bool comCardReady = comPot != null && comPot.isDoneMoving();
		return myCardReady && comCardReady;
	}

	/// Returns true if the flip animation has finished.
	/// 
	/// Note: This method assumes comPot is not null.
	bool flipHasFinished() {
		return comPot.isDoneResizing();
	}flutter

	/// Compares the cards in the pot.
	void compareCards() {
		if (bothCardsReady() && flipHasFinished()) {
			sleep(const Duration(seconds: 1));
			int result = myPot.compareTo(comPot);
			int myCardPause = 0;
			int comCardPause = 0;
			if (result > 0) {
				// player won
				print('player won');
				myCardPause = 1;
			} else if (result < 0) {
				// player lost
				print('player lost');
				comCardPause = 1;
			} else {
				// tie
				print('player tied');
			}
			sleep(Duration(seconds: myCardPause));
			myDeck.add(myPot);
			myPot = null;
			sleep(Duration(seconds: comCardPause));
			comDeck.add(comPot);
			comPot = null;
			hasBeenFlipped = false;
		}
	}

	/// Renders the right name to each side
	void _renderNames(Canvas c, Position right, Position left,
					  String leftName, String rightName) {
		config.render(c, leftName, left, anchor: Anchor.topLeft);
		config.render(c, rightName, right, anchor: Anchor.topRight);
	}

	/// Renders the players names based on which side their deck is on.
	void renderNames(Deck deck, Canvas c) {
		Position left = Position(
			trayPos.x + game.tileSize * textPadding.dx, 
			trayPos.y + game.tileSize * textPadding.dy
		);
		Position right = Position(
			game.screenSize.width - left.x, 
			left.y
		);
		
		if (deck.alignLeft) {
			_renderNames(c, right, left, myName, comName);
		} else {
			_renderNames(c, right, left, comName, myName);
		}
	}

	/// Renders the given list of cards and given pot card to the canvas.
	void renderCards(List<Card> slot, Card pot, Canvas c) {
		if (_slotHasLoaded(slot)) {
			slot.forEach((Card card) => card.render(c)); // draw each card 
		}
		if (pot != null) {
			pot.render(c);
		}
	}

	/// Finds and returns the coordinate of the deck at the given position.
	Position getSlotPositionFromIndex(int i, Deck deck) {
		double fromLeftEdge = trayPos.x + (game.tileSize * slotPadding.dx) + (cardPadding * deck.cardSize.width * i);
		double fromTopEdge = textSize + trayPos.y + (game.tileSize * slotPadding.dy);
		if (!deck.alignLeft) {
			fromLeftEdge += deck.cardSize.width;
			fromLeftEdge = game.screenSize.width - fromLeftEdge;
		}
		return Position(fromLeftEdge, fromTopEdge);
	}

	/// Updates the given list of cards and given pot card to the canvas.
	void updateCards(List<Card> slot, int size, Deck deck, Card pot, double t) {
		if (_slotHasLoaded(slot)) { // check the the slot
			for (int i = 0; i < size; i++) { // loop through each slots
				// check all slots are filled
				if (slot.elementAt(i) == null || slot.elementAt(i).status != CardStatus.inHand) { 
					Card nextCard =	deck.draw(); // if not, draw a new card
					Position openSlot = getSlotPositionFromIndex(i, deck);
					nextCard.setTargetLocation(openSlot); // update target
					nextCard.status = CardStatus.inHand;
					slot[i] = nextCard; // fill the slot with reference to card
				}
				Card currentCard = slot.elementAt(i);
				currentCard.update(t);
			}
		}
		if (pot != null) {
			pot.update(t);
		}
	}

	/// Renders the tray (and its components) to the canvas
	void render(Canvas c) {
		traySprite.renderRect(c, trayArea); // render tray background
		renderCards(comSlots, comPot, c); // render opponents cards
		renderCards(mySlots, myPot, c); // render my cards
		renderNames(myDeck, c);
	}

	/// Updates the tray.
	/// 
	/// Loops through the five mySlots and makes sure they are all full. If not, it will draw the next card from the deck to fill the open slot.
	void update(double t) {
		updateCards(mySlots, mySize, myDeck, myPot, t);
		updateCards(comSlots, comSize, comDeck, comPot, t);
		if (bothCardsReady() && !hasBeenFlipped) {
			hasBeenFlipped = true;
			comPot.flip();
		}
	}

	/// Handles user taps.
	void handleTouchAt(Offset touchPoint) {
		if (_potIsEmpty()) {
			if (_slotHasLoaded(mySlots)) {
				mySlots.forEach((Card card) {
					if (card.contains(touchPoint)) {
						int i = game.rand.nextInt(comSize);
						Card comCard = comSlots.elementAt(i);
						comPot = comCard;
						comCard.sendToPot();
						myPot = card;
						card.sendToPot();
					}
				});
			}
		}
	}
}
import 'dart:ui';

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
	static const double paddingFactor = 1.2;

	/// The configuration of the text on screen.
	static const TextConfig config = TextConfig(
		color: Color(0xFF000000),
		fontSize: 20.0, 
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
	Offset trayPos; // REVIEW: Consider making this a Position class.

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
		trayPos = Offset(game.tileSize * 1, game.tileSize * 6.25);
		trayArea = Rect.fromLTWH(
			trayPos.dx,
			trayPos.dy,
			game.screenSize.width - trayPos.dx * 2,
			game.screenSize.height - trayPos.dy
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

	// Returns whether both player's cards are in the middle 'pot'
	bool bothCardsReady() {
		bool myCardReady = myPot != null && myPot.isDoneMoving();
		bool comCardReady = comPot != null && comPot.isDoneMoving();
		return myCardReady && comCardReady;
	}

	// Renders the players names based on which side their deck is on
	void renderNames(Deck deck, Canvas c) {
		Position left = Position(trayPos.dx + 25, trayPos.dy + 15);
		Position right = Position(game.screenSize.width - trayPos.dx - 25, trayPos.dy + 15);
		
		if (deck.alignLeft) {
			right.x -= 11 * comName.length;
			config.render(c, myName, left);
			config.render(c, comName, right);
		} else {
			right.x -= 11 * myName.length;
			config.render(c, comName, left);
			config.render(c, myName, right);
		}
		
	}

	// Renders the given list of cards and given pot card to the canvas.
	void renderCards(List<Card> slot, Card pot, Canvas c) {
		if (_slotHasLoaded(slot)) {
			slot.forEach((Card card) => card.render(c)); // draw each card 
		}
		if (pot != null) {
			pot.render(c);
		}
	}

	// Finds and returns the coordinate of the deck at the given position.
	Position getSlotPositionFromIndex(int i, Deck deck) {
		double fromLeftEdge = 30 + trayPos.dx + (paddingFactor * deck.cardSize.width * i);
		double fromTopEdge = 25 + trayPos.dy + 15;
		if (deck.alignLeft) {
			return Position(fromLeftEdge, fromTopEdge);
		} else {
			fromLeftEdge += deck.cardSize.width;
			return Position(game.screenSize.width - fromLeftEdge, fromTopEdge);
		}
	}

	// Updates the given list of cards and given pot card to the canvas.
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

	// Renders the tray (and its components) to the canvas
	void render(Canvas c) {
		traySprite.renderRect(c, trayArea); // render tray background
		renderCards(comSlots, comPot, c); // render opponents cards
		renderCards(mySlots, myPot, c); // render my cards
		renderNames(myDeck, c);
	}

	// Loops through the five mySlots and makes sure they are all full. If not, it will draw the next card from the deck to fill the open slot.
	void update(double t) {
		updateCards(mySlots, mySize, myDeck, myPot, t);
		updateCards(comSlots, comSize, comDeck, comPot, t);
		if (bothCardsReady() && !hasBeenFlipped) {
			hasBeenFlipped = true;
			comPot.flip();
		}
	}

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
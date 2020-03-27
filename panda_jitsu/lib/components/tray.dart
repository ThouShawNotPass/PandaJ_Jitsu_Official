import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/card_status.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This class will handle the bottom part of the screen, including where cards should be diverted and keeps track of empty mySlots as cards are selected.
class Tray {

	static const double paddingFactor = 1.2; // padding between cards
	static const TextConfig config = TextConfig(
		color: Color(0xFF000000),
		fontSize: 20.0, 
		fontFamily: 'Julee'
	); // configures a text feature

	final Deck myDeck;
	final Deck comDeck;
	final int mySize;
	final int comSize;
	final JitsuGame game;

	Card comPot; // their card in the middle
	Card myPot; // my card in the middle
	List<Card> comSlots;
	List<Card> mySlots;
	Offset trayPos; // top left of the tray
  	Rect trayArea; // rectangular area of the tray
	String comName;
	String myName;
	Sprite traySprite; // tray image (png)
	
	Tray(this.game, this.myDeck, this.mySize, this.comDeck, this.comSize) {
		comSlots = List<Card>(comSize);
		mySlots = List<Card>(mySize);
		traySprite = Sprite('background/tray.png');
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

	// Returns whether both player's cards are in the middle 'pot'
	bool bothCardsReady() {
		bool myCardReady = myPot != null && myPot.isDoneMoving();
		bool comCardReady = comPot != null && comPot.isDoneMoving();
		return myCardReady && comCardReady;
	}

	// Renders the players names based on which side their deck is on
	void renderNames(Deck myDeck, Canvas c) {
		Position left = Position(trayPos.dx + 25, trayPos.dy + 15);
		Position right = Position(game.screenSize.width - trayPos.dx - 25, trayPos.dy + 15);
		
		if (myDeck.alignLeft) {
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
		if (slot != null && slot.isNotEmpty) {
			slot.forEach((Card card) => card.render(c)); // draw each card 
		}
		if (pot != null) {
			pot.render(c);
		}
	}

	// Finds and returns the coordinate of the deck at the given position.
	Position getSlotFromIndex(int i, Deck deck) {
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
		if (slot != null && slot.isNotEmpty) { // check the the slot
			for (int i = 0; i < size; i++) { // loop through each mySlots
				// check all mySlots are filled
				if (slot.elementAt(i) == null || slot.elementAt(i).status != CardStatus.inHand) { 
					Card nextCard =	deck.draw(); // if not, draw a new card
					Position openSlot = getSlotFromIndex(i, deck);
					nextCard.setTargetLocation(openSlot); // update target
					nextCard.status = CardStatus.inHand;
					slot[i] = nextCard; // fill the slot with reference to card
				}
			}
			// update all the cards in the mySlots (now they should all be full)
			slot.forEach((Card card) {
				card.update(t);
			});
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
		if (bothCardsReady()) {
			print('Flipped!');
			comPot.flip();
		}
	}

	void handleTouchAt(Offset pt) {
		if (myPot == null) {
			if (mySlots != null && mySlots.isNotEmpty) {
				mySlots.forEach((Card card) {
					if (card.containsPoint(pt)) {
						int i = Random().nextInt(comSize);
						Card comCard = comSlots.elementAt(i);
						comCard.sendToPot();
						comPot = card;
						card.sendToPot();
						myPot = card;
					}
				});
			}
		}
	}
}
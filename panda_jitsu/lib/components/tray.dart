import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/card_status.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This class will handle the bottom part of the screen, including where cards should be diverted and keeps track of empty slots as cards are selected.
class Tray {

	final Deck deck;
	final int size;
	final JitsuGame game;

	Card pot; // the card in the middle
	List<Card> slots;
	Offset trayPos; // top left of the tray
  	Rect trayArea; // rectangular area of the tray
	Sprite traySprite; // tray image (png)
	
	Tray(this.game, this.deck, this.size) {
		trayPos = Offset(game.tileSize * 1, game.tileSize * 6.25);
		slots = List<Card>(size);
		traySprite = Sprite('background/tray.png');
		trayArea = Rect.fromLTWH(
			trayPos.dx,
			trayPos.dy,
			game.screenSize.width - trayPos.dx * 2,
			game.screenSize.height - trayPos.dy
		);
	}

	void render(Canvas c) {
		// step 1 - draw the tray itself
		traySprite.renderRect(c, trayArea);

		// step 2 - render each card in the tray
		if (slots != null && slots.isNotEmpty) {
			slots.forEach((Card card) => card.render(c)); // draw each card 
		}

		// step 3 - render the card in the pot
		if (pot != null) {
			pot.render(c);
		}
	}

	// Loops through the five slots and makes sure they are all full. If not, it will draw the next card from the deck to fill the open slot.
	void update(double t) {
		if (slots != null && slots.isNotEmpty) { // check the the slot
			for (int i = 0; i < size; i++) { // loop through each slots
				// check all slots are filled
				if (slots.elementAt(i) == null || slots.elementAt(i).status != CardStatus.inHand) { 
					Card nextCard =	deck.draw(); // if not, draw a new card
					Offset openSlot = Offset(
						30 + trayPos.dx + game.tileSize * 1.75 * i, 
						25 + trayPos.dy + 15
					);
					nextCard.setTargetLocation(openSlot); // update target
					nextCard.status = CardStatus.inHand;
					slots[i] = nextCard; // fill the slot with reference to card
				}
			}
			// update all the cards in the slots (now they should all be full)
			slots.forEach((Card card) {
				print('card');
				// card.update(t);
			});
		}
		if (pot != null) {
			print('pot');
			// pot.update(t);
		}
	}

	void handleTouchAt(Offset pt) {
		if (pot == null) {
			if (slots != null && slots.isNotEmpty) {
				slots.forEach((Card card) {
					if (card.containsPoint(pt)) {
						pot = card;
						card.onTap();
					}
				});
			}
		}
	}
}
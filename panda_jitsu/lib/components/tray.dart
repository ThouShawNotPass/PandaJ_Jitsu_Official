import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This class will handle the bottom part of the screen, including where cards should be diverted and keeps track of empty slots as cards are selected.
class Tray {

	final JitsuGame game;
	final Deck deck;
	List<Card> slots;
	Offset trayPos;
  	Rect trayArea;
	Sprite traySprite;
	
	Tray(this.game, this.deck) {
		trayPos = Offset(game.tileSize * 1, game.tileSize * 6.25);
		slots = List<Card>(5);
		traySprite = Sprite('background/tray.png');
		trayArea = Rect.fromLTWH(
			trayPos.dx,
			trayPos.dy,
			game.screenSize.width - trayPos.dx * 2,
			game.screenSize.height - trayPos.dy
		);
	}

	void render(Canvas c) {
		traySprite.renderRect(c, trayArea); // draw the single tray
		if (slots != null && slots.isNotEmpty) {
			slots.forEach((Card card) => card.render(c)); // draw each card 
		}
	}

	// Loops through the five slots and makes sure they are all full. If not, it will draw the next card from the deck to fill the open slot.
	void update(double t) {
		for (int i = 0; i < 5; i++) {
			if (slots != null && slots.elementAt(i) == null) {
				Card nextCard =	deck.remove();
				Offset openSlot = Offset(
					30 + trayPos.dx + game.tileSize * 1.75 * i, 
					25 + trayPos.dy
				);
				nextCard.targetLocation = openSlot;
				slots[i] = nextCard;
			}
		}
		if (slots != null && slots.isNotEmpty) {
			slots.forEach((Card card) => card.update(t));
		}
	}

	void handleTouchAt(Offset pt) {
		if (slots != null && slots.isNotEmpty) {
			slots.forEach((Card card) {
				if (card.containsPoint(pt)) {
					card.onTap();
				}
			});
		}
	}
}
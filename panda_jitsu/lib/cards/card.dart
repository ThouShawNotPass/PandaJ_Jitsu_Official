import 'dart:ui'; // for basic dart objects (Rect, Paint, Canvas)

import 'package:flutter/gestures.dart'; // handles taps

import 'package:panda_jitsu/cards/deck.dart'; // deck of cards
import 'package:panda_jitsu/card_status.dart'; // status enum to describe the current status of the card (inDeck, inHand, inPot)
import 'package:panda_jitsu/element.dart'; // element enum (fire, water, snow)
import 'package:panda_jitsu/jitsu_game.dart';

// The card class is a super class to child element cards and will be a parent to the individual power cards (level ten and up). Each card object can keep track of its own element type (fire, water, snow), its level (currently only one through nine) and whether or not the card should be displayed as "face-up".
class Card {

	static const int speed = 12;

	final JitsuGame game;
	final Deck deck;

	Rect shape; // the rectangular shape of the card (3:4 ratio)
	Paint style; // color (for now)
	Offset targetLocation; // where the card is trying to go

	Element type; // fire, water, snow
	int level; // numbert between 1 and 9 (for now)
    bool isFaceUp; // which side of the card should we show
    bool isUsers; // if the card is owned by the user or their opponent
    CardStatus status; // which side of the card should we show

	// Main Constructor - main one that builds everything
	Card(this.game, this.deck, Element el, int lvl, bool faceUp) {
		targetLocation = Offset(
			(game.screenSize.width / 2) - (game.tileSize * 0.75), // center (x)
			(game.screenSize.height) // bottom of the screen (y)
		);
		shape = Rect.fromLTWH(
			targetLocation.dx, 
			targetLocation.dy, 
			game.tileSize * 1.5, 
			game.tileSize * 2
		);
		style = Paint();
		type = el;
		setColorFromElement(el);
		level = lvl;
        isFaceUp = faceUp;
		isUsers = faceUp;
		status = CardStatus.inDeck;
	}

	// makes the card bigger by a factor of n, while preserving the left and top positioning of the card.
	void inflate(int n) {
		shape = Rect.fromLTWH(
			shape.left, 
			shape.right, 
			game.tileSize * 1.5 * n, 
			game.tileSize * 2 * n
		);
	}

	// Determines the color of the card based on the element type
	void setColorFromElement(Element type) {
		switch (type) {
			case Element.fire:
				style.color = Color(0xFFBF3030);
				break;
			case Element.water:
				style.color = Color(0xFF3048BF);
				break;
			default: // case Element.snow (or type is null)
				style.color = Color(0xFFFFFFFF);
				break;
		}
	}

	// Whether the card shape contains the given point
	bool containsPoint(Offset pt) {
		return shape.contains(pt);
	}

	// Sets the target location of the current card
	void setTargetLocation(Offset pt) {
		targetLocation = pt;
	}

	// Draws the current shape to the given canvas
	void render(Canvas c) {
		c.drawRect(shape, style);	
	}

	void update(double t) {
		Offset toTarget = targetLocation - Offset(shape.left, shape.top);
		if (toTarget.distance > 0) {
			double step = game.tileSize * speed * t; // dist card moves next frame
			if (step < toTarget.distance) { // more than one step to go
				Offset smStep = Offset.fromDirection(toTarget.direction, step);
				shape = shape.shift(smStep);
			} else { // less than a step to go
				shape = shape.shift(toTarget); // we are there!
			}
		}
	}

	// Called when the card has been selected
	void onTap() {
		if (status == CardStatus.inHand) {
			inflate(2);
			Offset pot = Offset(0, 0);
			setTargetLocation(pot);
			status = CardStatus.inPot;
		}
	}
}
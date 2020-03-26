import 'dart:ui'; // for basic dart objects (Rect, Paint, Canvas)

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart'; // handles taps

import 'package:panda_jitsu/cards/deck.dart'; // deck of cards
import 'package:panda_jitsu/card_status.dart'; // status enum to describe the current status of the card (inDeck, inHand, inPot)
import 'package:panda_jitsu/element.dart'; // element enum (fire, water, snow)
import 'package:panda_jitsu/jitsu_game.dart';

// The card class is a super class to child element cards and will be a parent to the individual power cards (level ten and up). Each card object can keep track of its own element type (fire, water, snow), its level (currently only one through nine) and whether or not the card should be displayed as "face-up".
class Card {

	static const int speed = 5;

	final JitsuGame game;
	final Deck deck;

	Rect shape; // the rectangular shape of the card (3:4 ratio)
	Sprite style; // image and styling of the card
	Position targetLocation; // where the card is trying to go
	Size targetSize; // the shape the card is trying to be in

	Element type; // fire, water, snow
	int level; // numbert between 1 and 9 (for now)
    bool isFaceUp; // which side of the card should we show
    CardStatus status; // which side of the card should we show

	// Main Constructor - main one that builds everything
	Card(this.game, this.deck, Element el, int lvl, bool faceUp) {
		// centered horizontally and vertically offscreen below the screen
		targetLocation = Position( 
			(deck.screenCenter.x) - (deck.cardSize.width / 2),
			(deck.screenCenter.y * 2)
		);
		targetSize = Size(
			deck.cardSize.width, 
			deck.cardSize.height
		);
		shape = Rect.fromLTWH(
			targetLocation.x, 
			targetLocation.y, 
			targetSize.width, 
			targetSize.height
		);
		isFaceUp = faceUp; // this must come before setColorFromElement()
		type = el;
		level = lvl;
		status = CardStatus.inDeck;
		_setSpriteFromElement(el);
	}

	// Determines the color of the card based on the element type. This method relys on the isFaceUp boolean instance variable being defined (not null)
	void _setSpriteFromElement(Element type) {
		if (isFaceUp) {
			switch (type) {
				case Element.fire:
					style = Sprite('cards/fire-card.png');
					break;
				case Element.water:
					style = Sprite('cards/water-card.png');
					break;
				default: // case Element.snow (or type is null)
					style = Sprite('cards/snow-card.png');
					break;
			}
		} else {
			style = Sprite('cards/back-side.png');
		}
	}

	// Returns a new Rect object that has been expanded by the given factor
	Rect inflateByFactor(double n) {
		return Rect.fromLTWH(shape.left, shape.top, n * shape.width, n * shape.height);
	}

	// Returns whether the card shape contains the given point
	bool containsPoint(Offset pt) {
		return shape.contains(pt);
	}

	// Returns whether the card is done translating
	bool isDoneMoving() {
		return targetLocation.equals(Position(shape.left, shape.right));
	}

	// Sets the target location of the current card
	void setTargetLocation(Position pt) {
		targetLocation = pt;
	}

	// Draws the current shape to the given canvas
	void render(Canvas c) {
		style.renderRect(c, shape);
	}

	// Animates a card-flip action
	void flip() {
		targetSize = Size(0, deck.cardSize.height);
	}

	// Updates the position of the card by shifting the top, left coordinate by a small step if the translation is large or shifting it directly to the target point if the translation is small
	void _updatePosition(double t) {
		Offset toTarget = Offset(targetLocation.x, targetLocation.y) - Offset(shape.left, shape.top);
		if (toTarget.distance > 0) {
			double step = game.tileSize * speed * t; // dist card moves
			if (step < toTarget.distance) { // more than one step to go
				Offset smStep = Offset.fromDirection(toTarget.direction, step);
				shape = shape.shift(smStep);
			} else { // less than a step to go
				shape = shape.shift(toTarget); // we are there!
			}
		}
	}

	// Updates the shape of the card while preserving center allignment. This method will preserve the center position of the card while updating.
	void _updateSize(double t) {

	}

	// Tries to take a small step toward the targetLocation if it needs to
	void update(double t) {
		// update the position of the card
		_updatePosition(t);
		
		// updates the shape of the card
		_updateSize(t);

		// update the style of the card
		_setSpriteFromElement(type);
	}

	// This method is only called when the card has been selected
	void onTap() {
		if (status == CardStatus.inHand) { // only cards in hand are tappable
			double n; // inflation factor
			if (deck.isSmall) {
				n = 3.0; // for the tiny opponent's cards => make same size
			} else {
				n = 1.5; // for regular sized cars
			}
			shape = inflateByFactor(n);
			Position thePot = Position( // default left target
				(deck.screenCenter.x) - (2 * shape.width),
				(deck.screenCenter.y) - (shape.height / 2)
			);
			if (!deck.alignLeft) { // set right target instead
				thePot = thePot.add(Position(3 * shape.width, 0));
			}
			setTargetLocation(thePot);
			status = CardStatus.inPot;
		}
	}
}
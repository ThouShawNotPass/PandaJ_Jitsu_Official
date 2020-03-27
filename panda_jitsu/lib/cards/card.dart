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
		setTargetLocation(Position( 
			(deck.screenCenter.x) - (deck.cardSize.width / 2),
			(deck.screenCenter.y * 2)
		));
		setTargetSize(Size(
			deck.cardSize.width, 
			deck.cardSize.height
		));
		setShape(Rect.fromLTWH(
			targetLocation.x, 
			targetLocation.y, 
			targetSize.width, 
			targetSize.height
		));
		isFaceUp = faceUp; // this must come before setColorFromElement()
		type = el;
		level = lvl;
		setCardStatus(CardStatus.inDeck);
		_updateSprite(el);
	}

	// Determines the color of the card based on the element type. This method relys on the isFaceUp boolean instance variable being defined (not null)
	void _updateSprite(Element type) {
		if (isFaceUp) {
			switch (type) {
				case Element.fire:
					setStyle(Sprite('cards/fire-card.png'));
					break;
				case Element.water:
					setStyle(Sprite('cards/water-card.png'));
					break;
				case Element.snow:
					setStyle(Sprite('cards/snow-card.png'));
					break;
				default: // called if type is null
					setStyle(Sprite('cards/back-side.png'));
					break;
			}
		} else {
			setStyle(Sprite('cards/back-side.png'));
		}
	}

	// Sets the current shape to one that has been expanded by the given factor
	void inflateByFactor(double n) {
		setShape(Rect.fromLTWH(
			shape.left, 
			shape.top, 
			n * shape.width, 
			n * shape.height
		));
		setTargetSize(Size(shape.width, shape.height));
	}

	// Returns whether the card shape contains the given point
	bool containsPoint(Offset pt) => shape.contains(pt);

	// Returns whether the card is done translating
	bool isDoneMoving() => targetLocation.equals(Position(shape.left, shape.right));

	// Toggles the value of isFaceUp
	void _toggleFaceUp() => isFaceUp = !isFaceUp;

	// Sets the current shape to the given rectangle
	void setShape(Rect r) => shape = r;

	// Sets the style to the givne sprite
	void setStyle(Sprite s) => style = s;

	// Sets the current element type
	void setCardStatus(CardStatus s) => status = s;

	// Sets the target location of the current card
	void setTargetLocation(Position p) => targetLocation = p;

	// Sets the target size of the current card
	void setTargetSize(Size s) => targetSize = s;

	// Draws the current shape to the given canvas
	void render(Canvas c) => style.renderRect(c, shape);

	// Animates a card-flip action
	void flip() => setTargetSize(Size(0, shape.height));

	// Updates the position of the card by shifting the top, left coordinate by a small step if the translation is large or shifting it directly to the target point if the translation is small
	void _updatePosition(double t) {
		Offset toTarget = Offset(targetLocation.x, targetLocation.y) - Offset(shape.left, shape.top);
		// Note: we compute the distanceSquared because its faster
		if (toTarget.distanceSquared > 0) {
			double step = game.tileSize * speed * t; // dist card moves
			if (toTarget.distance > step) { // more than one step to go
				Offset smStep = Offset.fromDirection(toTarget.direction, step);
				setShape(shape.shift(smStep));
			} else { // less than a step to go
				setShape(shape.shift(toTarget)); // we are there!
			}
		}
	}

	// Updates the shape of the card while preserving center allignment. This method will preserve the center position of the card while updating.
	void _updateSize(double t) {
		Offset toTarget = Offset( // the amount to grow/shrink shape (+/-)
			targetSize.width - shape.width, 
			targetSize.height - shape.height
		);
		// Note: we compute the 'distanceSquared' because its faster
		if (toTarget.distanceSquared > 0) { // shrink shape
			double step = game.tileSize * t / speed;
			if (toTarget.distanceSquared > step * step) {
				setShape(Rect.fromCenter(
					center: shape.center,
					width: shape.width + step * toTarget.dx,
					height: shape.height + step * toTarget.dy
				));
			} else {
				setShape(Rect.fromCenter(
					center: shape.center,
					width: targetSize.width,
					height: targetSize.height
				));
				// flip card if either width or height are zero
				if  (shape.width == 0 || shape.height == 0) {
					_toggleFaceUp();
					_updateSprite(type);
					// return card to original form factor
					if (shape.width == 0) {
						setTargetSize(Size(
							0.833333 * shape.height, 
							shape.height
						));
					} else { // shape.height == 0
						setTargetSize(Size(
							shape.width, 
							1.2 * shape.width
						));
					}
				}
			}
		}
	}

	// Tries to take a small step toward the targetLocation if it needs to
	void update(double t) {
		_updatePosition(t);
		_updateSize(t);
	}

	// This method is only called when the card has been selected
	void sendToPot() {
		if (status == CardStatus.inHand) { // only cards in hand are tappable
			double n; // inflation factor
			if (deck.isMine()) {
				n = 1.5; // for regular sized cards
			} else {
				n = 3.0; // for the tiny opponent's cards => make same size
			}
			inflateByFactor(n);
			Position newPos = Position( // default left target
				(deck.screenCenter.x) - (2 * shape.width),
				(deck.screenCenter.y) - (shape.height / 2)
			);
			if (!deck.alignLeft) { // set right target instead
				newPos = newPos.add(Position(3 * shape.width, 0));
			}
			setTargetLocation(newPos);
			setCardStatus(CardStatus.inPot);
		}
	}
}
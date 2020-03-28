import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/card_status.dart';
import 'package:panda_jitsu/element.dart';
import 'package:panda_jitsu/jitsu_game.dart';


/// A rectangular playing-card object.
/// 
/// The card class is a super class to child element cards and will be a parent to the individual power cards (level ten and up). Each card object can keep track of its own element type (fire, water, snow), its level (currently only one through nine) and whether or not the card should be displayed as "face-up".
class Card {

	/// The factor by which to inflate the card in the pot.
	/// 
	/// The inflation factor is for the player's card and should be doubled for the smaller opponents card. Typically their card is smaller than the player's by a factor of 2.
	static const double inflationFactor = 1.5;

	/// The minimum distance between two positions that counts as 'equal'.
	/// 
	/// This solves a small overflow bug where the calculated distance is actually slightly greater than zero (~10^-27) when it should be zero.
	static const double minDistSquared = 0.1;

	/// The maximum size step distance between frames.
	static const double sizeStep = 0.2;

	/// The speed cards travel between frames (tiles per second).
	static const int speed = 10;

	/// The shrinkage factor of the upper-left card Sprites.
	static const double shrinkFactor = 0.33;


	/// A reference to the Jitsu game.
	final JitsuGame game;

	/// A reference to the card's deck.
	final Deck deck;

	/// The rectangular shape of the card.
	Rect shape;

	/// The image and styling of the card.
	Sprite style = Sprite('cards/base/back-side.png');

	/// The card's overlay sprite.
	Sprite overlay = Sprite('cards/overlay/blue-card.png');

	/// The card's element level.
	Sprite lvlSprite = Sprite('cards/levels/1.png');

	/// The position of the card's target location.
	Position targetLocation;

	/// The size of the card's target shape.
	Size targetSize;

	/// The card's element.
	/// 
	/// See also: [Element]
	Element type;

	/// The power level of the card. 
	/// 
	/// The power level is used to break ties if two cards have the same Element type. This is currently a number between 1 and 9.
	int level;

	/// True if the card is 'face-up'
    bool isFaceUp;

	/// The current status of the card.
	/// 
	/// See also: [CardStatus]
    CardStatus status;

	/// Constructs a new card object.
	Card(this.game, this.deck, this.type, this.level, this.isFaceUp) {
		setTargetLocation(Position( 
			(deck.screenCenter.x) - (deck.cardSize.width / 2), // centered
			(game.screenSize.height) // off the bottom of the screen
		));
		setTargetSize(deck.cardSize);
		setShape(targetLocation, targetSize);
		setCardStatus(CardStatus.inDeck);
		_setRandomOverlay();
		_setLevelSprite();
		_updateSprite();
	}

	/// Determines the color of the card based on the element type. 
	/// 
	/// If the Element is null, it will assign the back-side Sprite as if the card has been turned face-down.
	/// This method relys on the isFaceUp boolean instance variable being defined (it should not be null).
	void _updateSprite() {
		if (isFaceUp) {
			switch (type) {
				case Element.fire:
					setStyle(Sprite('cards/base/fire-card.png'));
					break;
				case Element.water:
					setStyle(Sprite('cards/base/water-card.png'));
					break;
				case Element.snow:
					setStyle(Sprite('cards/base/snow-card.png'));
					break;
				default: // called if type is null
					setStyle(Sprite('cards/base/back-side.png'));
					break;
			}
		} else {
			setStyle(Sprite('cards/base/back-side.png'));
		}
	}

	/// Sets the overlay to a random color.
	/// 
	/// The default color is yellow.
	void _setRandomOverlay() {
		switch (game.rand.nextInt(6)) {
			case 0:
				overlay = Sprite('cards/overlay/yellow-card.png');
				break;
			case 1:
				overlay = Sprite('cards/overlay/orange-card.png');
				break;
			case 2:
				overlay = Sprite('cards/overlay/green-card.png');
				break;
			case 3:
				overlay = Sprite('cards/overlay/blue-card.png');
				break;
			case 4:
				overlay = Sprite('cards/overlay/red-card.png');
				break;
			case 5:
				overlay = Sprite('cards/overlay/purple-card.png');
				break;
			default:
				overlay = Sprite('cards/overlay/yellow-card.png');
				break;
		}
	}

	/// Sets the current card level.
	void _setLevelSprite() {
		lvlSprite = Sprite('cards/levels/' + level.toString() + '.png');
	}

	/// Inflates the current shape by the given factor.
	void inflateByFactor(double n) {
		setShapeFromRect(Rect.fromLTWH(
			shape.left, 
			shape.top, 
			n * shape.width, 
			n * shape.height
		));
		setTargetSize(Size(shape.width, shape.height)); // make new size persist
	}

	/// Returns whether the card shape contains the given point.
	bool contains(Offset point) => shape.contains(point);

	/// Returns whether the card is done translating.
	bool isDoneMoving() {
		Offset dist = Offset(targetLocation.x - shape.left, targetLocation.y - shape.top);
		return dist.distanceSquared < minDistSquared; // Solves almost-zero bug
	}

	/// Toggles the value of isFaceUp
	void _toggleFaceUp() => isFaceUp = !isFaceUp;

	/// Sets the current shape to the given rectangle.
	void setShapeFromRect(Rect newRect) => shape = newRect;

	/// Sets the current shape based on the given Offset and Size.
	void setShape(Position p, Size s) => shape = Offset(p.x, p.y) & s;

	/// Sets the style to the given Sprite.
	void setStyle(Sprite newSprite) => style = newSprite;

	/// Sets the current element type of the current card.
	void setCardStatus(CardStatus newStatus) => status = newStatus;

	/// Sets the target location of the current card.
	void setTargetLocation(Position point) => targetLocation = point;

	/// Sets the target size of the current card.
	void setTargetSize(Size newSize) => targetSize = newSize;

	/// Draws the current card to the canvas.
	/// 
	/// Each card is composed of four different assets. The 'base' layer, which is typically the background image. The 'overlay' which is a random color. 
	void render(Canvas c) {
		style.renderRect(c, shape);
		if (isFaceUp) {
			overlay.renderRect(c, shape);
			lvlSprite.renderRect(c, Rect.fromLTWH(
				shape.left, 
				shape.top, 
				shape.width * shrinkFactor, 
				shape.width * shrinkFactor
			));
			lvlSprite.renderRect(c, Rect.fromLTRB(
				shape.right - shape.width * shrinkFactor, 
				shape.bottom - shape.width * shrinkFactor, 
				shape.right, 
				shape.bottom
			));
		}
	}

	/// Animates a card-flip action.
	/// 
	/// This method sets the target size to a width of zero and the same height as before. The actual shape will be changed when render() and update() are called.
	/// Implementation:
	/// ```
	/// setTargetSize(Size(0, shape.height));
	/// ```
	void flip() => setTargetSize(Size(0, shape.height));

	/// Updates the position of the card.
	/// 
	/// Updates the position of the card by shifting the top, left coordinate by a small step if the translation is large or shifting it directly to the target point if the translation is small.
	void _updatePosition(double t) {
		Offset toTarget = Offset(targetLocation.x, targetLocation.y) - Offset(shape.left, shape.top);
		// Note: we compute the distanceSquared because its faster
		if (toTarget.distanceSquared > minDistSquared) {
			double step = game.tileSize * speed * t;
			if (toTarget.distanceSquared > step * step) {
				Offset smStep = Offset.fromDirection(toTarget.direction, step);
				setShapeFromRect(shape.shift(smStep));
			} else { // less than a step to go
				setShapeFromRect(shape.shift(toTarget)); // we are there!
			}
		}
	}

	/// Updates the size of the card.
	/// 
	/// Updates the size of the card while preserving center allignment. This method will preserve the center position of the card while updating.
	void _updateSize(double t) {
		Offset toTarget = Offset( // the amount to grow/shrink shape (+/-)
			targetSize.width - shape.width, 
			targetSize.height - shape.height
		);
		// Note: we compute the 'distanceSquared' here because its faster
		if (toTarget.distanceSquared > minDistSquared) {
			setShapeFromRect(Rect.fromCenter(
				center: shape.center,
				width: shape.width + sizeStep * toTarget.dx,
				height: shape.height + sizeStep * toTarget.dy
			));
		} else {
			setShapeFromRect(Rect.fromCenter(
				center: shape.center,
				width: targetSize.width,
				height: targetSize.height
			));
			// flip card if either width or height are zero
			if  (shape.width == 0 || shape.height == 0) {
				_toggleFaceUp();
				_updateSprite();
				// return card to original form factor
				if (shape.width == 0) {
					setTargetSize(Size(
						shape.height * deck.getInverseCardRatio(), 
						shape.height
					));
				} else { // shape.height == 0
					setTargetSize(Size(
						shape.width, 
						shape.width * deck.getCardRatio()
					));
				}
			}
		}
	}

	/// Updates the current state of the card.
	/// 
	/// See also: [_updatePosition] and [_updateSize]
	void update(double t) {
		_updatePosition(t);
		_updateSize(t);
	}

	/// Sends the current card to the middle pot.
	void sendToPot() {
		if (status == CardStatus.inHand) { // only cards in hand are tappable
			if (deck.isMyCard()) {
				inflateByFactor(inflationFactor);
			} else {
				inflateByFactor(2 * inflationFactor); // double for small cards
			}
			Position centerScreen = deck.screenCenter.clone();
			if (deck.alignLeft) {
				setTargetLocation(
					centerScreen.minus( // shift left and up from center
						Position(2 * shape.width, shape.height / 2)
					)
				);
			} else {
				setTargetLocation(
					centerScreen.add( // shift right and up from center
						Position(shape.width, -1 * shape.height / 2)
					)
				);
			}
			setCardStatus(CardStatus.inPot);
		}
	}
}
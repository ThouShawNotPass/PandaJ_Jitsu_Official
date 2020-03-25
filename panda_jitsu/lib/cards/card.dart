import 'dart:ui'; // for touch/tap user interface

import 'package:panda_jitsu/element.dart'; // element enum (fire, water, snow)
import 'package:panda_jitsu/jitsu_game.dart';

// The card class is a super class to child element cards and will be a parent to the individual power cards (level ten and up). Each card object can keep track of its own element type (fire, water, snow), its level (currently only one through nine) and whether or not the card should be displayed as "face-up".
class Card {
	final JitsuGame game;

	double screenCenterX;
	double screenCenterY;
	Rect shape; // the rectangular shape of the card (3:4 ratio)
	Paint style; // color (for now)

	Element type; // fire, water, snow
	int level; // numbert between 1 and 9 (for now)
    bool isFaceUp;

    // Default constructor for a card object
	Card(this.game, int lvl) {
		screenCenterX = game.screenSize.width / 2;
		screenCenterY = game.screenSize.height / 2;
		shape = Rect.fromLTWH(
			0,
			0,
			game.tileSize * 1.5,
			game.tileSize * 2
		);
		style = Paint();
		style.color = Color(0xffBF3030); // red card
		type = Element.fire; // fire card
		level = lvl;
        isFaceUp = true;
	}

	void render(Canvas c) {
		c.drawRect(shape, style);	
	}

	void shiftShape(Offset point) {
		shape = shape.shift(point);
		switch (type) {
			case Element.fire:
				style.color = Color(0xffBF3030);
				break;
			case Element.water:
				style.color = Color(0xff3048BF);
				break;
			case Element.snow:
				style.color = Color(0xffFFFFFF);
				break;
		}
	}

	void update(double t) {}
}
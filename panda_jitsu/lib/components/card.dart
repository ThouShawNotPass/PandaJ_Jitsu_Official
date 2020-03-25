import 'dart:ui';

import 'package:panda_jitsu/element.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This is a card class that keeps track of a set of cards
class Card {
	final JitsuGame game;
	double screenCenterX;
	double screenCenterY;
	Rect shape; // the rectangular shape of the card (3:4 ratio)
	Paint style; // color (for now)
	Element type; // fire, water, snow
	int level; // numbert between 1 and 10 (for now)

	Card(this.game) {
		screenCenterX = game.screenSize.width / 2;
		screenCenterY = game.screenSize.height / 2;
		shape = Rect.fromLTWH(
			0,
			0,
			game.tileSize * 1.5,
			game.tileSize * 2
		);
		style = Paint();
		style.color = Color(0xffBF3030);
		type = Element.fire;
		level = 1;
	}

	void render(Canvas c) {
		Offset pt = new Offset(
			screenCenterX - (game.tileSize * 6.75), 
			screenCenterY + (game.tileSize * 2.35)
		);
		renderHelper(c, pt);
		c.drawRect(shape, style);	
	}

	void renderHelper(Canvas canv, Offset point) {
		shape.shift(point);
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
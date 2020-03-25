import 'dart:ui';
import 'package:panda_jitsu/jitsu-game.dart';
import 'package:panda_jitsu/element.dart';

// This is a card class that keeps track of a set of cards
class Card {
	final JitsuGame game;
	Rect shape; // the rectangular shape of the card (3:4 ratio)
	Paint style; // color (for now)
	Element type; // fire, water, snow
	int level; // numbert between 1 and 10 (for now)

	Card(this.game);

	void render(Canvas c) {
		drawCard(c);
	}

	void drawCard(Canvas c) {
		double screenCenterX = game.screenSize.width / 2;
		double screenCenterY = game.screenSize.height / 2;
    	double height = game.tileSize * 2;
		shape = Rect.fromLTWH(
			screenCenterX - (game.tileSize * 6.75),
			screenCenterY + (game.tileSize * 2.35),
			height * 0.75,
			height
		);
		style = Paint();
		style.color = Color(0xff0000ff);
		c.drawRect(shape, style);
	}

	void update(double t) {}
}
import 'dart:ui'; // Basic Dart objects (Offset, Rect, etc)

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This is a card class that keeps track of a set of cards
class FireCard extends Card {
	JitsuGame game;
	FireCard(this.game) : super(game) {
		double dx = screenCenterX - (game.tileSize * 6.75);
		double dy = screenCenterY + (game.tileSize * 2.35);
		super.shift(Offset(dx, dy));
	}
}
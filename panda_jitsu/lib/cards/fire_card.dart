import 'dart:ui'; // Basic Dart objects (Offset, Rect, etc)

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/cards/deck.dart';
import 'package:panda_jitsu/element.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This is a card class that keeps track of a set of cards
class FireCard extends Card {
	JitsuGame game;
	Deck deck;

	FireCard(this.game, this.deck) : super(game, deck, Element.fire, 1, true) {
		super.shift(Offset(
			deck.screenCenter.dx - (game.tileSize * 6.75), 
			deck.screenCenter.dy + (game.tileSize * 2.35)
		));
	}
}
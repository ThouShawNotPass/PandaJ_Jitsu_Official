import 'dart:ui';

import 'package:panda_jitsu/cards/card.dart';
import 'package:panda_jitsu/jitsu_game.dart';

// This is a card class that keeps track of a set of cards
class FireCard extends Card {
  JitsuGame game;
	
  FireCard(this.game, int lvl) : super(game, lvl) {
    double dx = screenCenterX - (game.tileSize * 6.75);
    double dy = screenCenterY + (game.tileSize * 2.35);
    super.shiftShape(Offset(dx, dy));
  }
}
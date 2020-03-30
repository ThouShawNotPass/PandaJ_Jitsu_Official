import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:panda_jitsu/card_color.dart';
import 'package:panda_jitsu/element.dart';
import 'package:panda_jitsu/jitsu_game.dart';

/// Tracks a single token object.
class Token {

	/// The speed of translation.
	static const double speed = 10;

	/// The width and height of a token.
	static const double width = 50;

	/// A reference to the JitsuGame object.
	JitsuGame game;

	/// The shape of the token.
	Rect shape = Rect.fromLTWH(100, 100, width, width);

	/// Translation to target location.
	/// 
	/// This value should be updated each time the sprite is moved so that it has a value of (0, 0) when it is in the correct location.
	Offset _toTarget = Offset.zero;
	
	/// The background of the token. 
	Sprite _background = Sprite('tokens/blue-token.png');

	/// The element of the token.
	Sprite _elementSprite = Sprite('cards/elements/fire.png');

	/// The color of the token.
	CardColor color;

	/// The element of the token.
	Element element;


	/// A basic token constructor.
	Token(this.game, this.color, this.element) {
		_setColor(color);
		_setElement(element);
	}

	/// Sets a new target location.
	void setTargetLocation(Offset p) {
		_toTarget = Offset(p.dx - shape.left, p.dy - shape.top);
	}

	/// Sets the color of the background sprite.
	void _setColor(CardColor c) {
		_background = Sprite('tokens/' + c.name() + '-token.png');
	}

	/// Sets the element sprite of the token.
	void _setElement(Element e) {
		_elementSprite = Sprite('cards/elements/' + e.name() + '.png');
	}

	/// Sets the shape of the token.
	void _setShape(Rect r) => shape = r;

	/// Updates the position of the token.
	void _updatePosition(double t) {
		double stepSize = game.tileSize * speed * t;
		if (_toTarget.distanceSquared > stepSize * stepSize) {
			Offset step = Offset.fromDirection(_toTarget.direction, stepSize);
			_setShape(shape.shift(step));
			_toTarget = _toTarget.translate(-step.dx, -step.dy);
		} else {
			_setShape(shape.shift(_toTarget));
			_toTarget = Offset.zero;
		}
	}

	void update(double t) {
		if(_toTarget.distanceSquared > 0) {
			_updatePosition(t);
		}
	}

	void render(Canvas c) {
		_background.renderRect(c, shape);
		_elementSprite.renderRect(c, shape);
	}
}
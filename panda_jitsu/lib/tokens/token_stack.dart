import 'dart:ui';

import 'package:panda_jitsu/tokens/token.dart';
import 'package:panda_jitsu/tokens/token_stack_manager.dart';

/// Handles a stack of tokens for a single element.
class TokenStack {
	
	/// Stack of tokens.
	List<Token> stack = List<Token>();

	/// A reference to the stack manager.
	TokenStackManager manager;

	/// The position of the stack.
	Offset position;

	/// Constructs a new token stack.
	TokenStack(this.manager, this.position);

	/// Adds a token to the stack.
	void add(Token t) {
		Offset p = Offset(
			position.dx + stack.length * 20, 
			position.dy  + stack.length * 20
		);
		t.setTargetLocation(p);
		stack.add(t);
	}

	/// Updates the token stack.
	void update(double t) {
		stack?.forEach((Token token) => token.update(t));
	}

	/// Renders the token stack.
	void render(Canvas c) {
		stack?.forEach((Token t) => t.render(c));
	}
}
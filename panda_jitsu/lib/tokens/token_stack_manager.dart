import 'dart:ui';

import 'package:panda_jitsu/tokens/token.dart';
import 'package:panda_jitsu/tokens/token_stack.dart';

// Manages three token stacks, one for each element
class TokenStackManager {

	TokenStack fire;

	TokenStack water;

	TokenStack snow;

	Offset p;

	TokenStackManager(this.p) {
		fire = TokenStack(this, p);
		water = TokenStack(this, p.translate(1.2 * Token.width, 0));
		snow = TokenStack(this, p.translate(2.4 * Token.width, 0));
	}


}
/// The three basic elements of nature.
/// 
/// These include Fire, Snow, and Water. Fire melts Snow, Snow freezes Water, and Water extinguishes Fire.
enum Element {
  /// # Fire.
  /// 
  /// "Furious fire 
  /// 
  /// brings its migty, scorching heat 
  /// 
  /// and will melt the snow."
  fire, // 0

  /// # Snow.
  /// 
  /// "The white frigid snow 
  /// 
  /// brings with it the winter's chill 
  /// 
  /// and freezes water."
  snow, // 1

  /// # Water.
  /// 
  /// "The peaceful water 
  /// 
  /// brings its soothing harmony 
  /// 
  /// and defeats fire."
  water // 2
}

extension on Element {

	/// Compares self to another Element.
	/// 
	/// Returns a positive integer if this element beats the other element, a negative integer if the other element beats this element, and zero if the two elements tie.
	int compareTo(Element other) {
		int difference = other.index - this.index;
		if (difference.abs() > 1) {
			difference *= -1;
		}
		return difference;
	}
}
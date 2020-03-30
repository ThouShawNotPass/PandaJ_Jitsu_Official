/// This is the color of the card.
enum CardColor {
	blue,
	green,
	orange, 
	purple,
	red,
	yellow
}

extension Name on CardColor {
	/// Returns the name of the CardColor object.
	/// 
	/// Example:
	/// ```
	/// CardColor blue = CardColor.blue;
	/// print(blue.toString()); // prints "CardColor.blue"
	/// print(blue.name); // prints "blue"
	/// ```
	String name() {
		return this.toString().split('.').last;
	}
}
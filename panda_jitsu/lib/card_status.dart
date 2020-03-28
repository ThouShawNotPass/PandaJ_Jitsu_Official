/// The state of the card.
/// 
/// Each card is in one of three states: in a player's hand, in a player's deck, or in the central pot.
enum CardStatus {
	/// In the deck.
	inDeck,

	/// In the hand.
	inHand,

	/// In the central pot.
	inPot
}
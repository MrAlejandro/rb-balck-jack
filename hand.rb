class Hand
  ACE_MIN_AMOUNT = 1
  ACE_MAX_AMOUNT = 11
  FACE_CARD_AMOUNT = 10
  BLACKJACK_AMOUNT = 21
  CRITICAL_ACES_QUANTITY = 2

  def initialize(*cards)
    @cards = cards
  end

  def add_card(card)
    @cards << card
  end

  def cards_number
    @cards.size
  end

  def points_amount
    initial, aces_last = initial_amount_and_hand_with_aces_last
    aces_last.reduce(initial, &method(:add_card_amount_to_points_amount))
  end

  def to_s
    hand_string = ""
    @cards.each { |card| hand_string << "#{card} " }
    hand_string << " points amount: #{points_amount}"
  end

  private

  def add_card_amount_to_points_amount(amount, card)
    if card.ace?
      too_much = amount + ACE_MAX_AMOUNT > BLACKJACK_AMOUNT
      return too_much ? amount + ACE_MIN_AMOUNT : amount + ACE_MAX_AMOUNT
    end

    card.face? ? amount + FACE_CARD_AMOUNT : amount + card.nominal
  end

  def initial_amount_and_hand_with_aces_last
    return [ACE_MIN_AMOUNT, not_aces << aces.first] if aces.count == CRITICAL_ACES_QUANTITY

    [0, not_aces + aces]
  end

  def aces
    @cards.select(&:ace?)
  end

  def not_aces
    @cards.reject(&:ace?)
  end
end


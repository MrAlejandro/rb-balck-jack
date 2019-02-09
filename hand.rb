class Hand
  def initialize(*cards)
    @cards = cards
  end

  def add_card(card)
    @cards << card
  end

  def cards_number
    @cards.size
  end

  def points
    initial, aces_last = initial_points_and_hand_with_aces_last
    aces_last.reduce(initial, &method(:add_card_points_to_points_sum))
  end

  def to_s
    @cards.map(&:to_s).join(' ')
  end

  private

  def add_card_points_to_points_sum(amount, card)
    new_amount = amount + card.points
    too_much = new_amount > BlackJackGame::BLACKJACK_AMOUNT
    too_much ? amount + card.ace_points : new_amount
  end

  def initial_points_and_hand_with_aces_last
    if aces.count > 1
      [aces.first.ace_points * (aces.count - 1), not_aces << aces.first]
    else
      [0, not_aces + aces]
    end
  end

  def aces
    @cards.select(&:ace?)
  end

  def not_aces
    @cards.reject(&:ace?)
  end
end

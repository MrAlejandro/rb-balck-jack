class Deck
  attr_reader :deck

  def initialize(card_class)
    @card_class = card_class
    @deck = {
      spades: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      diamonds: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      hearts: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      clubs: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A]
    }
  end

  def random_card
    nominal = nil
    nominal = @deck[suite].sample until nominal
    @card_class.new(suite, nominal)
  end

  def random_card!
    card = random_card
    @deck[card.suite].delete(card.nominal)
    card
  end

  protected

  def suite
    %i[spades diamonds hearts clubs].sample
  end
end

class Deck
  def initialize
    @cards = build_deck
    shuffle_deck!
  end

  def shuffle_deck!
    @cards.shuffle!
  end

  def card!
    @cards.pop
  end

  protected

  def build_deck
    Card::SUITES.flat_map do |suite|
      Card::NOMINALS.map { |nominal| Card.new(suite, nominal) }
    end
  end
end

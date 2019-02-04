class Deck
  attr_reader :deck

  def initialize(card_class)
    @card_class = card_class
    @deck = {
      spades: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      diamonds: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      hearts: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
      clubs: [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A],
    }
  end

  def random_card
    face = nil
    face = @deck[suite].sample until face
    @card_class.new(suite, face)
  end

  def random_card!
    card = random_card
    @deck[card.suite].delete(card.face)
    card
  end

  protected

  def suite
    [:spades, :diamonds, :hearts, :clubs].sample
  end
end

class Card
  SUITE_SYMBOLS = { spades: "\u2660", diamonds: "\u2666", hearts: "\u2665", clubs: "\u2663" }.freeze

  attr_reader :suite, :face

  def initialize(suite, face)
    @suite = suite
    @face = face
  end

  def value

  end

  def to_s
    print "#{@face}#{SUITE_SYMBOLS[@suite].encode("utf-8")}"
  end
end

deck = Deck.new(Card)
card = deck.random_card!
puts card.to_s
card = deck.random_card!
puts card.to_s

puts deck.deck

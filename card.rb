class Card
  SUITE_SYMBOLS = { spades: "\u2660", diamonds: "\u2666", hearts: "\u2665", clubs: "\u2663" }.freeze

  attr_reader :suite, :nominal

  def initialize(suite, nominal)
    @suite = suite
    @nominal = nominal
  end

  def ace?
    @nominal == :A
  end

  def face?
    %i[J Q K].include?(@nominal)
  end

  def to_s
    "#{@nominal}#{SUITE_SYMBOLS[@suite].encode('utf-8')}"
  end
end

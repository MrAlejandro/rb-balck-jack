class Card
  ACE_MIN_POINTS = 1
  ACE_MAX_POINTS = 11
  FACE_CARD_AMOUNT = 10

  SUITES = ["\u2660", "\u2666", "\u2665", "\u2663"].freeze
  NOMINALS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :J, :Q, :K, :A].freeze

  attr_reader :suite, :nominal

  def initialize(suite, nominal)
    @suite = suite
    @nominal = nominal
  end

  def points
    return ACE_MAX_POINTS if ace?

    face? ? FACE_CARD_AMOUNT : @nominal
  end

  def ace_points
    ace? ? ACE_MIN_POINTS : points
  end

  def ace?
    @nominal == :A
  end

  def face?
    %i[J Q K].include?(@nominal)
  end

  def to_s
    "#{@nominal}#{@suite.encode('utf-8')}"
  end
end

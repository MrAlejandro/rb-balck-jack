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
    [:spades, :diamonds, :hearts, :clubs].sample
  end
end

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
    [:J, :Q, :K].include?(@nominal)
  end

  def to_s
    "#{@nominal}#{SUITE_SYMBOLS[@suite].encode("utf-8")}"
  end
end

class Hand
  ACE_MIN_AMOUNT = 1
  ACE_MAX_AMOUNT = 11
  FACE_CARD_AMOUNT = 10
  BLACKJACK_AMOUNT = 21

  def initialize(*cards)
    @cards = cards
  end

  def add_card(card)
    @cards << card
  end

  def points_amount
    initial, aces_last = initial_amount_and_hand_with_aces_last
    aces_last.reduce(initial, &method(:add_card_amount_to_points_amount))
  end

  def to_s
    hand_string = ""
    @cards.each { |card| hand_string << "#{card.to_s} " }
    hand_string << " points amount: #{points_amount.to_s}"
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
    if aces.count == 2
      return [ACE_MIN_AMOUNT, not_aces << aces.first]
    end

    [0, not_aces + aces]
  end

  def aces
    @cards.select { |card| card.ace? }
  end

  def not_aces
    @cards.select { |card| !card.ace? }
  end
end

card1 = Card.new(:spades, :A)
card2 = Card.new(:spades, :A)
card3 = Card.new(:spades, 10)

puts card1.to_s, card2.to_s, card3.to_s
hand = Hand.new(card1, card2, card3)
print hand.points_amount

class Player
  attr_accessor :hand

  def initialize(interaction_strategy)
    @interaction_strategy = interaction_strategy
  end

  def name
    unless @name
      @name = @interaction_strategy.prompt_name
    end
    @name
  end

  def add_card(cards)
    @hand.add_card(cards)
  end
end

class UserInputInteractionStrategy
  def prompt_name
    puts "Enter your name: "
    gets.chomp
  end
end

class BotInteractionStrategy
  def prompt_name
    "Black Joe"
  end
end

class BlackJackGame
  def start
    init_players
    greet_player(@player)
    init_players_hands
    print_player_hand
    play
  end

  protected

  def init_players
    @player = Player.new(UserInputInteractionStrategy.new)
    @dealer = Player.new(BotInteractionStrategy.new)
  end

  def greet_player(player)
    puts "Hello #{player.name}"
  end

  def init_players_hands
    @deck = Deck.new(Card)
    @player.hand = Hand.new(@deck.random_card!, @deck.random_card!)
    @dealer.hand = Hand.new(@deck.random_card!, @deck.random_card!)
  end

  def print_player_hand
    puts @player.hand.to_s
  end

  def play
  end
end

game = BlackJackGame.new
game.start

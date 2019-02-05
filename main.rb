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

  def initialize(balance, action_strategy)
    @balance = balance
    @action_strategy = action_strategy
  end

  def name
    return "ALEX FOR NOW"
    @name ||= @action_strategy.name
  end

  def choose_action(actions)
    @action_strategy.choose_action(actions, self)
  end

  def player_hand
    "Player's #{name} hand: " << @action_strategy.player_hand(self)
  end

  def add_card(cards)
    @hand.add_card(cards)
  end

  def withdraw(amount)
    @balance -= amount
  end

  def deposit(amount)
    @balance += amount
  end
end

class PromptActionStrategy
  def name
    puts "Enter your name: "
    gets.chomp
  end

  def choose_action(actions, player)
    puts "Select action: "
    prompt_select_action(actions)
  end

  def player_hand(player)
    player.hand.to_s
  end

  protected

  def prompt_select_action(actions)
    acts = []
    index = 0
    actions.each do |code, action|
      puts "#{index}: #{action}"
      acts[index] = code
      index += 1
    end
    action_index = gets.to_i
    acts[action_index]
  end
end

class BotActionStrategy
  THRESHOLD_POINTS_AMOUNT = 17

  def name
    "Black Joe"
  end

  def choose_action(actions, player)
    puts player.hand.to_s
    if player.hand.points_amount >= THRESHOLD_POINTS_AMOUNT
      :skip
    else
      :add_card
    end
  end

  def player_hand
    "* * points amount: *"
  end
end

class RoundFinish < RuntimeError; end

class BlackJackGame
  INITIAL_BALANCE = 100
  STATE_HANDS_INIT = "hi"
  STATE_WITHDRAW_BETS = 'wb'
  STATE_ROUND_START = "rs"
  STATE_ROUND_FINISH = "rf"
  STATE_PLAYER_MOVE = "pm"
  STATE_DEALER_MOVE = "dm"

  attr_reader :player, :dealer, :deck
  attr_writer :state
  attr_accessor :active_player, :bank

  def initialize
    @state = HandsInitState.new
    @player = Player.new(INITIAL_BALANCE, PromptActionStrategy.new)
    @dealer = Player.new(INITIAL_BALANCE, BotActionStrategy.new)

    @active_player = @player
  end

  def play
    puts "Hello #{@player.name}. Welcome the the Black Jack game. Your opponent is #{@dealer.name}."
    start
  end

  def greet_player(player)
    puts "Hello #{player.name}"
  end

  def init_players_hands
    @deck = Deck.new(Card)
    @player.hand = Hand.new(@deck.random_card!, @deck.random_card!)
    @dealer.hand = Hand.new(@deck.random_card!, @deck.random_card!)
  end

  def withdraw_bets
    @bank = @player.withdraw(10) + @dealer.withdraw(10)
    @state = STATE_DEALER_MOVE
  end

  def switch_player
    @active_player = @active_player == @player ? @dealer : @player
  end

  protected

  def start
    start_round
  end

  def start_round
    loop do
      begin
        @state.act(self)
      rescue RoundFinish
        puts "Hey dude"
      end
    end
  end
end

class HandsInitState
  def act(game)
    game.init_players_hands
    puts "Your hand is: "
    puts game.player.hand.to_s
    game.state = PlayerMoveState.new
  end
end

class WithdrawBetsState
  DEFAULT_BET = 10

  def act(game)
    game.bank = game.player.withdraw(DEFAULT_BET) + game.dealer.withdraw(DEFAULT_BET)
    game.state = PlayerMoveState.new
  end
end

class PlayerMoveState
  def act(game)
    action = game.active_player.choose_action(skip: "Skip move", add_card: "Add card", open_cards: "Open cards")
    self.send action.to_sym, game
  end

  protected

  def skip(game)
    game.switch_player
  end

  def add_card(game)
    card = game.deck.random_card!
    game.active_player.add_card(card)
    puts game.active_player.player_hand
    game.switch_player
  end

  def open_cards(game)
  end
end

game = BlackJackGame.new
game.play

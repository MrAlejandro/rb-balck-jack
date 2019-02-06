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

  def cards_number
    @cards.size
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
  attr_reader :balance
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

  def add_card(cards)
    @hand.add_card(cards)
  end

  def points
    @hand.points_amount
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
end

class RoundFinish < RuntimeError; end

class BlackJackGame
  INITIAL_BALANCE = 100.0

  attr_reader :player, :dealer, :deck
  attr_writer :state
  attr_accessor :active_player, :bank

  def initialize
    @state = PrepareRoundState.new
    @player = Player.new(INITIAL_BALANCE, PromptActionStrategy.new)
    @dealer = Player.new(INITIAL_BALANCE, BotActionStrategy.new)
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

  def switch_player
    @active_player = @active_player == @player ? @dealer : @player
  end

  def dealers_move?
    @active_player == @dealer
  end

  protected

  def start
    start_round
  end

  def start_round
    loop do
      begin
        @state.act(self)
      rescue RoundFinish => e
        puts e.message
        break
      end
    end
  end
end

class PrepareRoundState
  DEFAULT_BET = 10.0

  def act(game)
    @game = game
    init_hands
    withdraw_bets
    @game.active_player = @game.player
    game.state = PlayerMoveState.new
  end

  protected

  def init_hands
    @game.init_players_hands
    puts "Your hand is: "
    puts @game.player.hand.to_s
  end

  def withdraw_bets
    @game.bank = DEFAULT_BET * 2
    @game.player.withdraw(DEFAULT_BET)
    @game.dealer.withdraw(DEFAULT_BET)
  end
end

class PlayerMoveState
  def act(game)
    action = game.active_player.choose_action(skip: "Skip move", add_card: "Add card", open_cards: "Open cards")
    self.send action.to_sym, game
  end

  protected

  def skip(game)
    puts game.dealers_move? ? "Your opponent skipped his move." : "You skipped the move."
    game.switch_player
    game.state = CheckRoundState.new
  end

  def add_card(game)
    card = game.deck.random_card!
    game.active_player.add_card(card)
    puts game.dealers_move? ? "Your opponent has taken another card." : "Your hand is: #{game.active_player.hand.to_s}."
    game.switch_player
    game.state = CheckRoundState.new
  end

  def open_cards(game)
    game.state = CalculateResultsState.new
  end
end

class CheckRoundState
  def act(game)
    if open_cards?(game)
      game.state = CalculateResultsState.new
    else
      game.state = PlayerMoveState.new
    end
  end

  protected

  def open_cards?(game)
    game.player.hand.cards_number == 3 && game.dealer.hand.cards_number == 3
  end
end

class CalculateResultsState
  BLACKJACK_AMOUNT = 21

  def act(game)
    @game = game
    summarize
    game.bank = 0
    puts "#{@game.player.name}'s balance is: #{@game.player.balance}"
    puts "#{@game.dealer.name}'s balance is: #{@game.dealer.balance}"
    raise RoundFinish, "The round is over"
  end

  protected

  def summarize
    if draw?
      handle_draw
    else
      player_won? ? reward_winner(@game.player, @game.dealer) : reward_winner(@game.dealer, @game.player)
    end
  end

  def draw?
    player_points == dealer_points || player_points > BLACKJACK_AMOUNT && dealer_points > BLACKJACK_AMOUNT
  end

  def handle_draw
    puts "It's draw (each player has #{@game.player.points} points). The bank will be split between players."
    payout = @game.bank / 2.0
    @game.player.deposit(payout)
    @game.dealer.deposit(payout)
  end

  def player_won?
    player_points > dealer_points && player_points <= BLACKJACK_AMOUNT
  end

  def reward_winner(winner, loser)
    puts "#{winner.name} with #{winner.points} points grabs the bank! Congratulations!"
    winner.deposit(@game.bank)
    puts "#{loser.name} (#{loser.points} points) may be next time."
  end

  def player_points
    @player_points ||= @game.player.points
  end

  def dealer_points
    @dealer_points ||= @game.dealer.points
  end
end

class StartNewRoundState
  def act
    puts "AAAAAAAAAAA"
    exit
  end
end

game = BlackJackGame.new
game.play

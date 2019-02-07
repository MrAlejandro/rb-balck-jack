class BlackJackGame
  BET = 10.0
  INITIAL_BALANCE = 100.0
  BLACKJACK_AMOUNT = 21
  MAX_CARDS_IN_HAND = 3

  attr_reader :player, :dealer, :deck
  attr_writer :state
  attr_accessor :active_player, :bank

  def initialize
    @state = PrepareRoundState.new
    puts "Enter your name: "
    name = gets.chomp
    @player = Player.new(name, INITIAL_BALANCE)
    @dealer = Player.new("Jack Black", INITIAL_BALANCE)
  end

  def play
    puts ''
    puts "Hello #{@player.name}. Welcome the the Black Jack game. Your opponent is #{@dealer.name}."
    start_game
  end

  def init_players_hands
    @deck = Deck.new
    @player.hand = Hand.new(@deck.card!, @deck.card!)
    @dealer.hand = Hand.new(@deck.card!, @deck.card!)
  end

  def switch_player
    @active_player = @active_player == @player ? @dealer : @player
  end

  def dealers_move?
    @active_player == @dealer
  end

  protected

  def start_game
  end
end

class Round
  def initialize(player, dealer)
    @player = player
    @dealer = dealer
  end

  def start
    init_cards
    player_turn
    dealer_turn
    calculate_result
  end

  protected

  def init_cards
    @deck = Deck.new
    @player.hand = Hand.new(@deck.card!, @deck.card!)
    puts ""
    puts "Your hand is: "
    puts @player.hand_summary
    @dealer.hand = Hand.new(@deck.card!, @deck.card!)
  end
end

class GameFinished < RuntimeError; end

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
    @player = Player.new(INITIAL_BALANCE, PromptActionStrategy.new)
    @dealer = Player.new(INITIAL_BALANCE, BotActionStrategy.new)
  end

  def play
    puts ""
    puts "Hello #{@player.name}. Welcome the the Black Jack game. Your opponent is #{@dealer.name}."
    start_game
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

  def start_game
    loop do
      begin
        @state.act(self)
      rescue GameFinished => e
        puts e.message
        break
      end
    end
  end
end

class GameFinished < RuntimeError; end

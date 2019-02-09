class BlackJackGame
  INITIAL_BALANCE = 100.0
  MAX_CARDS_IN_HAND = 3
  BLACKJACK_AMOUNT = 21
  BET = 10.0

  attr_reader :interactor

  def initialize(interactor)
    @interactor = interactor
    name = @interactor.ask_players_name
    name = 'Incognito' if name.empty?
    @player = Player.new(name, INITIAL_BALANCE)
    @dealer = Player.new('Jack Black', INITIAL_BALANCE)
  end

  def play
    @interactor.greet_player(@player.name, @dealer.name)
    start_game
  end

  protected

  def start_game
    start_round
    @interactor.show_game_over_notification
  end

  def start_round
    round = Round.new(@player, @dealer, self)
    round.start
    start_round if continue?
  end

  def continue?
    return false unless players_have_money?

    action = @interactor.ask_player_to_continue(%i[yes no])
    action == :yes
  end

  def players_have_money?
    @player.balance >= BET && @dealer.balance >= BET
  end
end

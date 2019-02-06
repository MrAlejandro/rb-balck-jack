class PrepareRoundState
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
    puts @game.player.hand_summary
    puts ""
  end

  def withdraw_bets
    bet = @game.class::BET
    @game.bank = bet * 2
    @game.player.withdraw(bet)
    @game.dealer.withdraw(bet)
  end
end

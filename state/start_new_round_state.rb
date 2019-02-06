class StartNewRoundState
  def act(game)
    @game = game
    raise GameFinished, "You do not have ehoutg money to continue" if player_out_of_money?
    raise GameFinished, "Your oppnent does not have ehoutg money to continue" if dealer_out_of_money?
    raise GameFinished, "Good bue!" unless continue_game?

    game.state = PrepareRoundState.new
  end

  protected

  def player_out_of_money?
    @game.player.balance < @game.class::BET
  end

  def dealer_out_of_money?
    @game.dealer.balance < @game.class::BET
  end

  def continue_game?
    @game.player.continue?
  end
end

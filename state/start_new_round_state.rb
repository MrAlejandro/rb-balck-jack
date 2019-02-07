class StartNewRoundState
  def act(game)
    @game = game
    raise GameFinished, "You do not have ehoutg money to continue" if player_out_of_money?
    raise GameFinished, "Your opponent does not have ehoutg money to continue" if dealer_out_of_money?
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
    actions = { yes: "Continue game.", no: "Exit game." }
    player_action = @game.player.choose_continue_action?(actions)
    dealer_action = @game.dealer.choose_continue_action?(actions)
    dealer_action == :yes && player_action == :yes
  end
end

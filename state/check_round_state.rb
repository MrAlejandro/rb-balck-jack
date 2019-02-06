class CheckRoundState
  def act(game)
    @game = game
    game.state = open_cards? ? CalculateResultsState.new : PlayerMoveState.new
  end

  protected

  def open_cards?
    max_cards = @game.class::MAX_CARDS_IN_HAND
    @game.player.cards_number == max_cards && @game.dealer.cards_number == max_cards
  end
end

class PlayerMoveState
  def act(game)
    @game = game
    actions = { skip: "Skip move", add_card: "Add card", open_cards: "Open cards" }
    actions.delete(:add_card) if active_players_hand_full?
    action = game.active_player.choose_move_action(actions)
    send action.to_sym
  end

  protected

  def active_players_hand_full?
    @game.active_player.cards_number >= @game.class::MAX_CARDS_IN_HAND
  end

  def skip
    puts @game.dealers_move? ? "Your opponent skipped his move." : "You skipped your move."
    puts ""
    @game.switch_player
    @game.state = CheckRoundState.new
  end

  def add_card
    card = @game.deck.random_card!
    @game.active_player.add_card(card)
    puts @game.dealers_move? ? "Your opponent has taken another card." : "Your hand is: #{@game.active_player.hand.to_s}."
    puts ""
    @game.switch_player
    @game.state = CheckRoundState.new
  end

  def open_cards
    @game.state = CalculateResultsState.new
  end
end

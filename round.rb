class Round
  SAFE_POINTS = 17

  def initialize(player, dealer, game)
    @player = player
    @dealer = dealer
    @game = game
  end

  def start
    init_cards
    make_bets
    until finished?
      player_turn
      dealer_turn
    end
    calculate_result
    print_summary
  end

  protected

  def finished?
    @finished || false
  end

  def init_cards
    @deck = Deck.new
    @player.hand = Hand.new(@deck.card!, @deck.card!)
    print_player_hand
    @dealer.hand = Hand.new(@deck.card!, @deck.card!)
  end

  def make_bets
    bet = @game.class::BET
    @bank = bet * 2
    @player.withdraw(bet)
    @dealer.withdraw(bet)
  end

  def print_player_hand
    @game.interactor.show_hand_info(@player.hand_summary, @player.points)
  end

  def player_turn
    action = @game.interactor.select_action(player_actions)
    send action.to_s
  end

  def player_actions
    actions = %i[skip_turn add_card open_cards]
    actions.delete(:add_card) if player_hand_full?(@player)
    actions
  end

  def player_hand_full?(player)
    player.cards_number >= @game.class::MAX_CARDS_IN_HAND
  end

  def skip_turn
    @game.interactor.show_skip_turn_notification(@player.name)
  end

  def add_card
    @player.add_card(@deck.card!)
    print_player_hand
  end

  def open_cards
    @finished = true
  end

  def dealer_turn
    return if finished?

    dealer_need_card? ? add_dealer_card : skip_dealer_turn
  end

  def dealer_need_card?
    @dealer.points < SAFE_POINTS && !player_hand_full?(@dealer)
  end

  def add_dealer_card
    @dealer.add_card(@deck.card!)
    @game.interactor.show_player_took_card_notification(@dealer.name)
  end

  def skip_dealer_turn
    @game.interactor.show_skip_turn_notification(@dealer.name)
  end

  def calculate_result
    if draw?
      handle_draw
    else
      player_won? ? reward_winner(@player, @dealer) : reward_winner(@dealer, @player)
    end
  end

  def draw?
    bj_amount = @game.class::BLACKJACK_AMOUNT
    player_points == dealer_points || player_points > bj_amount && dealer_points > bj_amount
  end

  def handle_draw
    @game.interactor.show_draw_notification(player_points)
    payout = @bank / 2.0
    @player.deposit(payout)
    @dealer.deposit(payout)
  end

  def player_won?
    bj_amount = @game.class::BLACKJACK_AMOUNT
    dealer_points > bj_amount || (player_points > dealer_points && player_points <= bj_amount)
  end

  def reward_winner(winner, loser)
    winner.deposit(@bank)
    @game.interactor.congratulate_winner(winner.name, winner.points)
    @game.interactor.cheer_up_looser(loser.name, loser.points)
  end

  def player_points
    @player_points ||= @player.points
  end

  def dealer_points
    @dealer_points ||= @dealer.points
  end

  def print_summary
    @game.interactor.show_player_round_summary(@player.name, @player.hand_summary, player_points, @player.balance)
    @game.interactor.show_player_round_summary(@dealer.name, @dealer.hand_summary, dealer_points, @dealer.balance)
  end
end

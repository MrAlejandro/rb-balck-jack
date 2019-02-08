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
      dealer_turn unless finished?
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
    @game.interactor.notify('', 'Your hand is: ', @player.hand_summary)
  end

  def player_turn
    action = @game.interactor.select_action(player_actions)
    send action.to_s
  end

  def player_actions
    actions = { skip_turn: 'Skip turn', add_card: 'Add card', open_cards: 'Open cards' }
    actions.delete(:add_card) if player_hand_full?(@player)
    actions
  end

  def player_hand_full?(player)
    player.cards_number >= @game.class::MAX_CARDS_IN_HAND
  end

  def skip_turn
    @game.interactor.notify('You skipped your turn')
  end

  def add_card
    @player.add_card(@deck.card!)
    print_player_hand
  end

  def open_cards
    @finished = true
  end

  def dealer_turn
    if skip_dealer_turn?
      @game.interactor.notify("#{@dealer.name} has skipped his turn.")
    else
      add_dealer_card
    end
  end

  def skip_dealer_turn?
    @dealer.points >= SAFE_POINTS || player_hand_full?(@dealer)
  end

  def add_dealer_card
    @dealer.add_card(@deck.card!)
    @game.interactor.notify("#{@dealer.name} has taken another card.")
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
    message = "It's draw (each player has #{player_points} points). The bank will be split between players."
    @game.interactor.notify(message)
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
    @game.interactor.notify("#{winner.name} with #{winner.points} points grabs the bank! Congratulations!")
    @game.interactor.notify("#{loser.name} (#{loser.points} points) may be next time.")
  end

  def player_points
    @player_points ||= @player.points
  end

  def dealer_points
    @dealer_points ||= @dealer.points
  end

  def print_summary
    @game.interactor.notify(
      "#{@player.name} - hand: #{@player.hand_summary}; balance: #{@player.balance}.",
      "#{@dealer.name} - hand: #{@dealer.hand_summary}; balance: #{@dealer.balance}.",
      ''
    )
  end
end

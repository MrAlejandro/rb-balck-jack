class CalculateResultsState
  def act(game)
    @game = game
    calculate_results
    print_summary
    game.state = StartNewRoundState.new
  end

  protected

  def calculate_results
    if draw?
      handle_draw
    else
      player_won? ? reward_winner(@game.player, @game.dealer) : reward_winner(@game.dealer, @game.player)
    end
  end

  def draw?
    bj_amount = @game.class::BLACKJACK_AMOUNT
    player_points == dealer_points || player_points > bj_amount && dealer_points > bj_amount
  end

  def handle_draw
    puts "It's draw (each player has #{@game.player.points} points). The bank will be split between players."
    payout = @game.bank / 2.0
    @game.player.deposit(payout)
    @game.dealer.deposit(payout)
    @game.bank = 0
  end

  def player_won?
    player_points > dealer_points && player_points <= @game.class::BLACKJACK_AMOUNT
  end

  def reward_winner(winner, loser)
    puts "#{winner.name} with #{winner.points} points grabs the bank! Congratulations!"
    winner.deposit(@game.bank)
    @game.bank = 0
    puts "#{loser.name} (#{loser.points} points) may be next time."
  end

  def player_points
    @player_points ||= @game.player.points
  end

  def dealer_points
    @dealer_points ||= @game.dealer.points
  end

  def print_summary
    puts "#{@game.player.name} - hand: #{@game.player.hand_summary}; balance: #{@game.player.balance}."
    puts "#{@game.dealer.name} - hand: #{@game.dealer.hand_summary}; balance: #{@game.dealer.balance}."
    puts ""
  end
end

class Interactor
  TRANSLATIONS = {
    yes: 'Yes',
    no: 'No',
    skip_turn: 'Skip turn',
    add_card: 'Add card',
    open_cards: 'Open cards'
  }.freeze

  def select_action(actions)
    puts 'Select action: '
    prompt_select_action(actions)
  end

  def ask_players_name
    puts 'Enter your name: '
    gets.chomp
  end

  def greet_player(player, opponent)
    puts "Hello #{player}. Welcome the the Black Jack game. Your opponent is #{opponent}."
  end

  def show_hand_info(hand, points)
    puts "Your hand is: #{hand} (#{points} points)"
  end

  def show_skip_turn_notification(name)
    puts "#{name} has skipped his turn"
  end

  def show_player_took_card_notification(name)
    puts "#{name} has taken another card"
  end

  def ask_player_to_continue(actions)
    puts 'Would you like to continue?'
    prompt_select_action(actions)
  end

  def show_game_over_notification
    puts 'The game is over. Good bye!'
  end

  def show_draw_notification(points)
    puts "It's draw (each player has #{points} points). The bank will be split between players."
  end

  def congratulate_winner(name, points)
    puts "#{name} with #{points} points grabs the bank! Congratulations!"
  end

  def cheer_up_looser(name, points)
    puts "#{name} (#{points} points) may be next time."
  end

  def show_player_round_summary(name, hand, points, balance)
    puts "#{name} - hand: #{hand} (#{points} points); balance: #{balance}."
  end

  protected

  def prompt_select_action(actions)
    actions.each_with_index do |action, index|
      message = TRANSLATIONS[action] || action
      puts "#{index}: #{message}"
    end
    action = actions[gets.to_i]
    return prompt_select_action(actions) unless action

    action
  end
end

class BotActionStrategy
  SAFE_points = 17

  def name
    'Jack Black'
  end

  def choose_move_action(actions, player)
    if player.hand.points >= SAFE_points || actions[:add_card].nil?
      :skip
    else
      :add_card
    end
  end

  def choose_continue_action(_actions, _player)
    :yes
  end
end

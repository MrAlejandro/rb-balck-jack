class BotActionStrategy
  SAFE_POINTS_AMOUNT = 17

  def name
    "Jack Black"
  end

  def choose_action(actions, player)
    if player.hand.points_amount >= SAFE_POINTS_AMOUNT || actions[:add_card].nil?
      :skip
    else
      :add_card
    end
  end
end

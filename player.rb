class Player
  attr_reader :balance
  attr_accessor :hand

  def initialize(balance, action_strategy)
    @balance = balance
    @action_strategy = action_strategy
  end

  def add_card(cards)
    @hand.add_card(cards)
  end

  def cards_number
    @hand.cards_number
  end

  def points
    @hand.points_amount
  end

  def withdraw(amount)
    @balance -= amount
  end

  def deposit(amount)
    @balance += amount
  end

  def hand_summary
    @hand.to_s
  end

  def name
    @name ||= @action_strategy.name
  end

  def method_missing(m, *args)
    if @action_strategy.respond_to?(m)
      @action_strategy.send(m, *args, self)
    else
      raise "Trying to call undefined method #{m}"
    end
  end
end

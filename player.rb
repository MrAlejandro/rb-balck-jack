class Player
  attr_reader :balance, :name
  attr_accessor :hand

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def add_card(cards)
    @hand.add_card(cards)
  end

  def cards_number
    @hand.cards_number
  end

  def points
    @hand.points
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
end

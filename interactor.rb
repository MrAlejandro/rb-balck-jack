class Interactor
  def ask(message)
    puts message
    gets.chomp
  end

  def notify(*messages)
    messages.each { |msg| puts msg }
  end

  def select_action(actions, message = 'Select action: ')
    puts message
    prompt_select_action(actions)
  end

  protected

  def prompt_select_action(actions)
    codes = actions.keys
    messages = actions.values
    messages.each_with_index { |message, index| puts "#{index}: #{message}" }
    action = codes[gets.to_i]
    return prompt_select_action(actions) unless action

    action
  end
end

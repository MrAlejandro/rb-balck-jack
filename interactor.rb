class Interactor
  def ask_uer_name
    puts 'Enter your name: '
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
    action_index = gets.to_i
    prompt_select_action(actions) unless codes[action_index]
    codes[action_index]
  end
end

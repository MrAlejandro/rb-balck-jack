class PromptActionStrategy
  def name
    return "Alex" # TODO: remove this
    puts "Enter your name: "
    gets.chomp
  end

  def choose_action(actions, player)
    puts "Select action: "
    prompt_select_action(actions)
  end

  protected

  def prompt_select_action(actions)
    acts = []
    index = 0
    actions.each do |code, action|
      puts "#{index}: #{action}"
      acts[index] = code
      index += 1
    end
    action_index = gets.to_i
    acts[action_index]
  end
end

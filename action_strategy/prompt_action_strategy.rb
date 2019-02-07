class PromptActionStrategy
  def name
    puts "Enter your name: "
    gets.chomp
  end

  def choose_move_action(actions, player)
    puts "Select action: "
    prompt_select_action(actions)
  end

  def choose_continue_action?(actions, player)
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

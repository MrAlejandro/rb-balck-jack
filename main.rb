require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'player'

require_relative 'action_strategy/bot_action_strategy'
require_relative 'action_strategy/prompt_action_strategy'

require_relative 'state/prepare_round_state'
require_relative 'state/check_round_state'
require_relative 'state/player_move_state'
require_relative 'state/calculate_result_state'
require_relative 'state/start_new_round_state'

require_relative 'black_jack_game'

black_jack_game = BlackJackGame.new
black_jack_game.play


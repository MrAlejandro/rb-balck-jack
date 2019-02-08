require_relative 'card'
require_relative 'deck'
require_relative 'hand'
require_relative 'round'
require_relative 'player'
require_relative 'interactor'
require_relative 'black_jack_game'

black_jack_game = BlackJackGame.new(Interactor.new)
black_jack_game.play

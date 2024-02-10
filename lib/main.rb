# frozen_string_literal: true

require_relative 'board'
require_relative 'displayable'
#require_relative 'game'
#require_relative 'game_prompts'
#require_relative 'notation_translator'
require_relative 'move_validator'
#require_relative 'serializer'
require_relative 'pieces/piece'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'movement/movement_factory'
require_relative 'movement/basic_movement'
require_relative 'movement/en_passant_movement'
require_relative 'movement/pawn_promotion_movement'
require_relative 'movement/castling_movement'

test = Board.new
test.initial_placement
test.to_s
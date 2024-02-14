# forzen_string_literal: true

require_relative 'serializer'
require_relative 'game_prompts'

# Logic for chess game player rounds
class Game
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters an opponent's piece
  class LocationError < StandardError
    def message
      'Invalid coordinates! Enter column & row of the correct color.'
    end
  end

  # Declares error message when user enters a piece without moves
  class PieceError < StandardError
    def message
      'Invalid piece! This piece does not have any legal moves.'
    end
  end

  # Declares error message when user enters invalid move location
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column and row to move.'
    end
  end

  include GamePrompts
  include Serializer

  def initialize(number = 2, board = Board.new, current_turn = :white)
    @board = board
    @current_turn = current_turn
    @player_count = number
  end

  def setup_board
    @board.initial_placement
  end

  def play
    @board.to_s
    play_round until @board.game_over? || @player_count.zero?
    final_message
  end

  def play_round
    player_turn

    # Print updated chess board
    @board.to_s

    # Switch colors for next turn
    switch_color
  end

  # Logic for a single player turn
  def player_turn
    puts "It's your turn #{@current_turn}."
    # Player selects piece
    select_piece_location
    return unless @player_count.positive?

    # Highlight selected piece
    @board.to_s

    # Player selects piece movement
    pos = select_movement_location
    return unless @player_count.positive?

    # Update the game board
    @board.update(pos)
  end

  def select_piece_location
    input = user_select_piece
    return unless @player_count.positive?

    location = translate_coordinates(input)
    validate_piece_location(location)
    @board.update_active_piece(location)
    validate_active_piece
  rescue StandardError => e
    puts e.message
    retry
  end

  def select_movement_location
    input = user_select_move
    return unless @player_count.positive?

    location = translate_coordinates(input)
    validate_move_location(location)
    location
  rescue StandardError => e
    puts e.message
    retry
  end

  def user_select_piece
    puts king_check_warning if @board.king_in_check?(@current_turn)
    input = user_input(user_piece_selection)
    validate_piece_input(input)
    resign_game if input.upcase == 'Q'
    save_game if input.upcase == 'S'
    input
  end

  def user_select_move
    puts en_passant_warning if @board.possible_en_passant?
    puts castling_warning if @board.possible_castling?
    input = user_input(user_move_selection)
    validate_move_input(input)
    resign_game if input.upcase == 'Q'
    input
  end

  def validate_piece_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$|^[q]$|^[s]$/i)
  end

  def validate_move_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$|^[q]$/i)
  end

  def validate_piece_location(location)
    raise LocationError unless @board.valid_piece?(location, @current_turn)
  end

  def validate_move_location(location)
    raise MoveError unless @board.valid_piece_movement?(location)
  end

  def validate_active_piece
    raise PieceError unless @board.active_piece_moveable?
  end

  # creates a translator to change chess notation into hash of coordinates
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_position(input)
  end

  def switch_color
    @current_turn = @current_turn == :white ? :black : :white
  end

  private

  def user_input(prompt)
    puts prompt
    gets.chomp
  end
end

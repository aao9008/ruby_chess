# frozen_string_literal: true
require_relative 'basic_movement'

# Logic for en passant moves
class EnPassantMovement < BasicMovement
  def initialize(board = nil, pos = nil)
    super
  end

  def update_moves
    update_en_passant_moves
  end

  def update_en_passant_moves
    # Remove captured en_passant pawn form the board
    remove_capture_piece_observer
    remove_en_passant_pawn

    # Update the location of the en_passant attacker
    new_pos = find_en_passant_capture_position
    update_new_position(new_pos)
    remove_original_piece
    update_active_piece_location(new_pos)
  end

  def remove_en_passant_pawn
    @board.data[pos.first][pos.last] = nil
  end

  def find_en_passant_capture_position
    rank_direction = board.active_piece.rank_direction
    [pos.first + rank_direction, pos.last]
  end

  def update_new_position(pos, piece = @board.active_piece)
    @board.data[pos.first][pos.last] = piece
  end

  def update_active_piece_location(location)
    @board.active_piece.update_location(location)
  end
end

# frozen_string_literal: true
require_relative 'basic_movement'

# Logic for castle moves
class CastlingMovement < BasicMovement
  def initialize(board = nil, pos = nil)
    super
  end

  def update_castling_moves
    update_new_position
    remove_original_piece
    update_active_piece_location
  end

  def find_castling_rook
    row = board.active_piece.location.first
    column = old_rook_column
    @board.data[row][column]
  end

  def update_rook_position(rook)
    @board.data[pos.first][new_rook_column] = rook
  end

  private

  # Determines the rooks orginal location based on the column of the king's move
  def old_rook_column
    king_side = 7
    queen_side = 0
    pos.last == 6 ? king_side : queen_side
  end

  # Determines the rooks new location based on the column of the king's move
  def new_rook_column
    king_side = 5
    queen_side = 3
    pos.last == 6 ? king_side : queen_side
  end
end

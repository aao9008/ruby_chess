# frozen_string_literal: true

# Contains logic for basic moves of all pieces
class BasicMovement
  attr_reader :board, :pos

  def initialize(board = nil, position = nil)
    @board = board
    @pos = position
  end

  def update_pieces(board, position)
    @board = board
    @pos = position
    update_moves
  end

  def update_moves
    update_basic_moves
  end

  def update_basic_moves
    remove_capture_piece_observer if board.data[pos.first][pos.last]
    update_new_position
    remove_original_piece
    update_active_piece_location
  end

  def remove_capture_piece_observer
    @board.delete_observer(@board.data[pos.first][pos.last])
  end

  def update_new_position(piece = @board.active_piece)
    @board.data[pos.first][pos.last] = piece
  end

  def remove_original_piece
    old_location = @board.active_piece.location
    @board.data[old_location.first][old_location.last] = nil
  end

  def update_active_piece_location
    @board.active_piece.update_location(pos)
  end
end

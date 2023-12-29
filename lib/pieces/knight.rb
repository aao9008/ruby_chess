# frozen.string.literal: true

require_relative 'piece'

# logic for rook chess piece
class Knight < Piece
  def initialize(board, args)
    super(board, args)
    @symbol = " \u265E "
  end

  # Return array of possible moves (legality not considered)
  def find_possible_moves(board)
    single_move_set(board)
  end

  def find_possible_captures(board)
    single_capture_set(board)
  end

  private

  def move_set
    [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  end
end

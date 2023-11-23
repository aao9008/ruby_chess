# frozen.string.literal: true

require_relative 'piece'

# logic for rook chess piece
class Rook < Piece
  def initialize(board, args)
    super(board, args)
    @symbol = " \u265C "
  end

  private

  def move_set
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

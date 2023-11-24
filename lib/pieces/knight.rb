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
    # Iterate over move set and create list of moves
    moves = move_set.inject([]) do |list, move|
      list << create_moves(board.data, move)
    end

    # Return array of possible moves
    moves.compact
  end

  def find_possible_captures(board)
    captures = move_set.inject([]) do |list, move|
      list << create_captures(board.data, move)
    end

    captures.compact
  end

  private

  def move_set
    [[-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1]]
  end

  def create_moves(data, transformation)
    pos = move_piece(transformation, location)

    pos if valid_move?(pos, data) && data[pos.first][pos.last].nil?
  end

  def create_captures(data, transformation)
    pos = move_piece(transformation, location)

    pos if valid_move?(pos, data) && opposing_piece?(pos, data)
  end
end

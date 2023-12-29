# frozen_string_literal: true

require_relative 'piece'

# Logic for the king chess piece
class King < Piece
  def initialize(board, args)
    super(board, args)
    @symbol = " \u265A "
  end

  def find_possible_moves(board)
    moves = single_move_set(board)
    moves += castling_moves(board)
    moves.compact
  end

  def find_possible_captures(board)
    single_capture_set(board)
  end

  private

  def castling_moves(board)
    rank = location[0]
    castling_moves = []
    castling_moves << [rank, 6] if king_side_castling?(board)
    castling_moves << [rank, 2] if queen_side_castling?(board)
    castling_moves
  end

  def king_side_castling?(board)
    # King side pass
    king_side_pass = 5
    empty_files = [6]
    king_side_rook = 7

    # Check that all conditions of a castle are met
    # King and rook have not been moved
    unmoved_king_rook?(board, king_side_rook) &&
      empty_files?(board, empty_files) &&
      !board.king_in_check?(@color) &&
      king_pass_through_safe?(board, king_side_pass)
  end

  def queen_side_castling?(board)
    queen_side_pass = 3
    empty_files = [1, 2]
    queen_side_rook = 0

    unmoved_king_rook?(board, queen_side_rook) &&
      empty_files?(board, empty_files) &&
      !board.king_in_check?(@color) &&
      king_pass_through_safe?(board, queen_side_pass)
  end

  # Returns true only if both the king and king side rook have not moved
  def unmoved_king_rook?(board, file)
    # Look at location of king side rook
    piece = board.data[location.first][file]

    # Return false if there is no piece at the rook's expected locaton
    return false unless piece

    # Check if both the king and the rook have not been moved
    moved == false && piece.symbol == " \u265C " && piece.moved == false
  end

  def empty_files?(board, files)
    rank = location[0]

    files.all? do |file|
      board.data[rank][file].nil?
    end
  end

  def king_pass_through_safe?(board, file)
    rank = location[0]
    board.data[rank][file].nil? && safe_passage?(board, [rank, file])
  end

  # Checks that king does not pass over a square that is attacked by an enemy piece
  def safe_passage?(board, location)
    # Get 1-dimensional list of all chess peices
    pieces = board.data.flatten(1).compact

    # Check that location is not included in any enemy piece's possible moves list.
    pieces.none? do |piece|
      next unless piece.color != color && piece.symbol != symbol

      moves = piece.find_possible_moves(board)
      moves.include?(location)
    end
  end

  def move_set
    [[0, 1], [0, -1], [-1, 0], [1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

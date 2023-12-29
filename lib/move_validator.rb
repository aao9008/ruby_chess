# frozen_string_literal: true

# removes any moves or captures that would put king in check
class MoveValidator

  def initialize(location, board, moves, piece = board.data[location.first][location.last])
    @current_location = location
    @board = board
    @moves_list = moves
    @current_piece = piece
    @king_location = nil
  end

  # Remove moves that leave king in check
  def verify_possible_moves
    # Find location of current player's king
    @king_location = find_king_location

    # Remove current piece from it's current location
    @board.data[@current_location.first][@current_location.last] = nil

    # Check legality of each possible move
    @moves_list.select do |move|
      legal_move?(move)
    end
  end

  private

  def legal_move?(move)
    # Store value at given location on the board
    captured_piece = @board.data[move.first][move.last]

    # Move currenct piece to the listed possible move
    move_current_piece(move)

    # Get the location of the players king
    king = @king_location || move

    # Check if the player's king is safe and not in check
    check = safe_king?(king)

    # Reset board to original state
    @board.data[move.first][move.last] = captured_piece

    # Return result of safe_king
    check
  end

  def move_current_piece(move)
    @board.data[move[0]][move[1]] = @current_piece
    @current_piece.update_location(move[0], move[1])
  end

  def safe_king?(king_location)
    # Create 1-demiensional array listing all chess pieces on the board
    pieces = @board.data.flatten(1).compact

    pieces.none? do |piece|
      next unless piece.color != @current_piece.color

      captures = piece.find_possible_captures(@board)
      captures.include?(king_location)
    end
  end

  def find_king_location
    return if @current_piece.symbol == " \u265A "

    if @current_piece.color == :black
      @board.black_king.location
    else
      @board.white_king.location
    end
  end
end

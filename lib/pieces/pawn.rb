# frozen.string.literal: true

require_relative 'piece'

# logic for rook chess piece
class Pawn < Piece
  attr_reader :en_passant

  def initialize(board, args)
    super(board, args)
    @symbol = " \u265F "
    @en_passant = false
  end

  def update_location(position)
    update_en_passant(position.first)
    super(position)
  end

  # determines the mathematical direction - white moves up & black moves down
  def rank_direction
    color == :white ? -1 : 1
  end

  def en_passant_rank?
    rank = location[0]
    (rank == 4 && color == :black) || (rank == 3 && color == :white)
  end

  def find_possible_moves(board)
    possible_moves = single_move_set(board)

    # If this is the pawns first turn
    if moved == false
      # It can move up/down 2 spaces
      possible_moves << bonus_move(board.data, possible_moves)
    end

    possible_moves.compact
  end

  def find_possible_captures(board)
    [
      basic_capture(board, 1),
      basic_capture(board, -1),
      en_passant_capture(board)
    ].compact
  end

  private

  def move_set
    [[rank_direction, 0]]
  end

  # Logic for pawn moving 2 spaces on opening turn
  def bonus_move(data, possible_moves)
    # Pawn can only have 1 possible move in their list
    # Pawn can onlh move 2 spaces if path is clear
    pos = possible_moves[0]

    # If the pawns move list is empty
    # This means he cannot move forward b/c pawn is possibly blocked, so path is not clear.
    return if pos.nil?

    # Move pawn up/down one additional space
    pos = move_piece(move_set[0], pos)

    # Return bonus move if move is valid and space is empty
    pos if valid_move?(pos, data) && data[pos.first][pos.last].nil?
  end

  def basic_capture(board, file_change)
    capture = [@location.first + rank_direction, @location.last + file_change]

    return capture if opposing_piece?(capture, board.data)
  end

  def en_passant_capture(board)
    capture = board.previous_piece&.location
    return unless capture

    column_difference = (@location[1] - capture[1]).abs
    return unless column_difference == 1

    # Check if all en_passant conditons have been met
    capture if valid_en_passant?(board)
  end

  # This functions checks if conditions for en_passant have been met.
  def valid_en_passant?(board)
    en_passant_rank? &&
      symbol == board.previous_piece.symbol &&
      board.previous_piece.en_passant &&
      legal_en_passant_move?(board)
  end

  def update_en_passant(row)
    @en_passant = (row - location[0]).abs == 2
  end

  # checks if the en passant move & capture will not leave the King in check
  def legal_en_passant_move?(board)
    pawn_location = board.previous_piece.location
    en_passant_move = [pawn_location[0] + rank_direction, pawn_location[1]]
    temp_board = remove_captured_en_passant_pawn(board, pawn_location)
    legal_capture = remove_illegal_moves(temp_board, en_passant_move)
    legal_capture.size.positive?
  end

  def remove_captured_en_passant_pawn(board, pawn_location)
    temp_board = Marshal.load(Marshal.dump(board))
    temp_board.data[pawn_location[0]][pawn_location[1]] = nil
    temp_board
  end
end

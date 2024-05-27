# frozen_string_literal: true

require 'observer'
require_relative 'displayable'

# contains logic for chess board
class Board
  include Observable
  include Displayable
  attr_reader :black_king, :white_king, :mode
  attr_accessor :data, :active_piece, :previous_piece

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data
    @active_piece = params[:active_piece]
    @previous_piece = params[:previous_piece]
    @black_king = params[:black_king]
    @white_king = params[:white_king]
  end

  def initial_placement
    initial_row(:black, 0)
    initial_pawn(:black, 1)
    initial_pawn(:white, 6)
    initial_row(:white, 7)
    @white_king = data[7][4]
    @black_king = data[0][4]
    update_all_moves_captures
  end

  def update_active_piece(pos)
    @active_piece = data[pos.first][pos.last]
  end

  def active_piece_moveable?
    @active_piece.moves.size >= 1 || @active_piece.captures.size >= 1
  end

  def valid_piece_movement?(pos)
    @active_piece.moves.include?(pos) ||
      @active_piece.captures.include?(pos)
  end

  def valid_piece?(pos, color)
    piece = @data[pos.first][pos.last]
    piece&.color == color
  end

  def update(position)
    type = movement_type(position)
    movement = MovementFactory.new(type).build
    movement.update_pieces(self, position)
    reset_board_values
  end

  # This function determines the type of move being made
  # In order to idnetify which movement logic will be used to update the board
  def movement_type(position)
    if en_passant_capture?(position)
      'EnPassant'
    elsif pawn_promotion?(position)
      'PawnPromotion'
    elsif castling?(position)
      'Castling'
    else
      'Basic'
    end
  end

  # This method handles logic for setting up class variables for next player turn/round
  def reset_board_values
    @previous_piece = @active_piece
    @active_piece = nil

    # Notifies all chess pieces of a the boards change and exectues the pieces #update method.
    changed
    notify_observers(self)
  end

  # Logic for checking if a player's king is in check
  def king_in_check?(color)
    # Get king game piece of current color
    king = color == :white ? @white_king : @black_king

    # Create 1-D list of all game pieces on the board
    pieces = @data.flatten(1).compact

    # Iterate over the pieces list
    pieces.any? do |piece|
      # Move on to next piece if it is a friendly piece
      next unless piece.color != king.color

      # Return true if player's king location is in a given enemey piece's capture list
      piece.captures.include?(king.location)
    end
  end

  def possible_en_passant?
    @active_piece&.captures&.include?(@previous_piece&.location) &&
      en_passant_pawn?
  end

  def possible_castling?
    @active_piece.symbol == " \u265A " && castling_moves?
  end

  def game_over?
    return false unless @previous_piece

    player_color = @previous_piece.color == :white ? :black : :white
    no_legal_moves_captures?(player_color)
  end

  # prints chess board using the displayable module
  def to_s
    print_chess_board
  end

  private

  def initial_row(color, rank)
    @data[rank] = [
      Rook.new(self, { color: color, location: [rank, 0] }),
      Knight.new(self, { color: color, location: [rank, 1] }),
      Bishop.new(self, { color: color, location: [rank, 2] }),
      Queen.new(self, { color: color, location: [rank, 3] }),
      King.new(self, { color: color, location: [rank, 4] }),
      Bishop.new(self, { color: color, location: [rank, 5] }),
      Knight.new(self, { color: color, location: [rank, 6] }),
      Rook.new(self, { color: color, location: [rank, 7] })
    ]
  end

  def initial_pawn(color, rank)
    @data[rank].map!.with_index do |_piece, file|
      Pawn.new(self, { color: color, location: [rank, file] })
    end
  end

  def en_passant_capture?(position)
    @previous_piece&.location == position && en_passant_pawn?
  end

  # Check that all conditions for en_passant are met
  def en_passant_pawn?
    two_pawns? && @active_piece.en_passant_rank? && @previous_piece.en_passant
  end

  def two_pawns?
    @previous_piece.symbol == " \u265F " && @active_piece.symbol == " \u265F "
  end

  def castling_moves?
    location = @active_piece.location
    rank = location[0]
    file = location[1]
    king_side = [rank, file + 2]
    queen_side = [rank, file - 2]
    @active_piece&.moves&.include?(king_side) ||
      @active_piece&.moves&.include?(queen_side)
  end

  def pawn_promotion?(position)
    @active_piece.symbol == " \u265F " && pawn_promotion_rank?(position)
  end

  def pawn_promotion_rank?(position)
    promotion_rank = @active_piece.color == :white ? 0 : 7
    position.first == promotion_rank
  end

  def castling?(position)
    file_difference = (@active_piece.location.last - position.last).abs

    @active_piece.symbol == " \u265A " && file_difference == 2
  end

  # Generate all possible moves and captures for all pieces on game board
  def update_all_moves_captures
    pieces = @data.flatten(1).compact
    pieces.each { |piece| piece.update(self) }
  end

  def no_legal_moves_captures?(color)
    pieces = @data.flatten(1).compact
    pieces.none? do |piece|
      next unless piece.color == color

      piece.moves.size.positive? || piece.captures.size.positive?
    end
  end
end

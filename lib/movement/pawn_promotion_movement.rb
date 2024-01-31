# frozen_string_literal: true
require_relative 'basic_movement'

# This contains the movement logic for a pawn promotion
class PawnPromotionMovement < BasicMovement
  def initialize(board = nil, position = nil)
    super
  end

  def update_basic_moves
    update_pawn_promotion_moves
  end

  def update_pawn_promotion_moves
    remove_capture_piece_observer if @board.data[pos.first][pos.last]
    remove_pawn_observer
    remove_original_piece
    new_piece = new_promotion_piece
    update_new_position(new_piece)
    update_board_active_piece(new_piece)
  end

  def remove_pawn_observer
    @board.delete_observer(@board.active_piece)
  end

  def new_promotion_piece
    puts pawn_promotion_choices
    choice = select_promotion_piece
    create_promotion_piece(choice)
  end

  def pawn_promotion_choices
    <<~HEREDOC
      Pawn Promotion! Please select a promotion peice!
      \e[36m[1]\e[0m for a Queen
      \e[36m[2]\e[0m for a Bishop
      \e[36m[3]\e[0m for a Knight
      \e[36m[4]\e[0m for a Rook
    HEREDOC
  end

  def select_promotion_piece
    choice = gets.chomp
    until choice.match(/^[1-4]$/)
      puts 'Input error! Only enter 1-digit (1-4).'
      choice = gets.chomp
    end
    choice
  end

  def create_promotion_piece(choice)
    color = @board.active_piece.color
    case choice
    when '1'
      Queen.new(@board, { location: pos, color: color })
    when '2'
      Bishop.new(@board, { location: pos, color: color })
    when '3'
      Knight.new(@board, { location: pos, color: color })
    when '4'
      Rook.new(@board, { location: pos, color: color })
    end
  end

  def update_board_active_piece(piece)
    @board.active_piece = piece
  end
end

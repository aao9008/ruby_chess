#frozen_string_literal: true

require_relative '../lib/move_validator'
require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'

RSpec.describe MoveValidator do
  describe '#verify_possible_moves' do
    # [-----, -----, -----, wrook, bking, bpawn, -----, -----],
    # [-----, -----, -----, -----, bpawn, bpawn, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----]

    context 'when king is in check and has valid moves' do
      board = Board.new
      board.data[0][3] = Rook.new(board, { color: :white, location: [0, 3] })
      board.data[0][4] = King.new(board, { color: :black, location: [0, 4] })
      board.data[0][5] = Pawn.new(board, { color: :black, location: [0, 5] })
      board.data[1][4] = Pawn.new(board, { color: :black, location: [1, 4] })
      board.data[1][5] = Pawn.new(board, { color: :black, location: [1, 5] })
      subject(:validator) { described_class.new([0, 4], board, [[0, 3], [1, 3]]) }

      it 'it returns moves for king to capture rook' do
        board.instance_variable_set(:@black_king, board.data[0][4])
        result = validator.verify_possible_moves
        expect(result).to contain_exactly([0, 3])
      end
    end

    # [-----, -----, -----, -----, bking, -----, -----, -----],
    # [-----, -----, -----, bpawn, -----, bpawn, -----, -----],
    # [-----, -----, bpawn, -----, bquen, -----, bpawn, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, bpawn, -----, -----, -----, bpawn, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, wquen, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----]

    context 'when moving queen can put the king in check' do
      board = Board.new
      board.data[0][4] = King.new(board, { color: :black, location: [0, 4] })
      board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
      board.data[6][4] = Queen.new(board, { color: :white, location: [6, 4] })
      board.data[1][3] = Pawn.new(board, { color: :black, location: [1, 3] })
      board.data[1][5] = Pawn.new(board, { color: :black, location: [1, 5] })
      board.data[2][2] = Pawn.new(board, { color: :black, location: [2, 2] })
      board.data[2][6] = Pawn.new(board, { color: :black, location: [2, 6] })
      board.data[4][2] = Pawn.new(board, { color: :black, location: [4, 2] })
      board.data[4][6] = Pawn.new(board, { color: :black, location: [4, 6] })
      subject(:validator) { described_class.new([2, 4], board, [[1, 4], [3, 4], [4, 4], [5, 4], [2, 3], [2, 5], [3, 3], [3, 5]]) }

      it 'returns moves that will not put the king in check' do
        board.instance_variable_set(:@black_king, board.data[0][4])
        result = validator.verify_possible_moves
        expect(result).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end

    # [-----, -----, -----, -----, -----, brook, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, -----, -----, -----, -----],
    # [-----, -----, -----, -----, wking, -----, -----, wrook]

    context 'when king cannot castle' do
      board = Board.new
      board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
      board.data[7][7] = Rook.new(board, { color: :white, location: [7, 7] })
      board.data[0][5] = Rook.new(board, { color: :black, location: [0, 5] })
      subject(:validator) { described_class.new([7, 4], board, [[7, 3], [6, 3], [6, 4], [6, 5], [7, 5]]) }

      it 'returns moves that will not put king in check' do
        board.instance_variable_set(:@white_king, board.data[7][4])
        result = validator.verify_possible_moves
        expect(result).to contain_exactly([7, 3], [6, 3], [6, 4])
      end
    end

    context 'when king is in check and 4 out of 5 pieces have valid moves' do
      # [-----, -----, -----, -----, wquen, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, wpawn, bquen, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, wrook, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [wbshp, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, wking, -----, -----, -----]

      context 'when white queen can capture black queen' do
        board = Board.new
        board.data[0][4] = Queen.new(board, { color: :white, location: [0, 4] })
        board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
        board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
        subject(:validator) { described_class.new([0, 4], board, [[2, 4], [1, 4], [0, 3], [0, 5],[1, 3], [1, 5]]) }

        it 'returns move to capture queen' do
          board.instance_variable_set(:@white_king, board.data[7][4])
          result = validator.verify_possible_moves
          expect(result).to contain_exactly([2, 4])
        end
      end

      context 'when rook can block black queen' do
        board = Board.new
        board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
        board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
        board.data[4][3] = Rook.new(board, { color: :white, location: [4, 3] })
        subject(:validator) { described_class.new([4, 3], board, [[4, 4], [4, 2], [4, 1], [4, 0]]) }

        it 'returns move to block black queen' do
          board.instance_variable_set(:@white_king, board.data[7][4])
          result = validator.verify_possible_moves
          expect(result).to contain_exactly([4, 4])
        end
      end

      context 'when pawn cannot block or capture the black queen' do
        board = Board.new
        board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
        board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
        board.data[2][3] = Pawn.new(board, { color: :white, location: [2, 3] })
        subject(:validator) { described_class.new([2, 3], board, [[1, 3]]) }

        it 'has no valid moves' do
          board.instance_variable_set(:@white_king, board.data[7][4])
          result = validator.verify_possible_moves
          expect(result).to be_empty
        end
      end

      context 'when the white bishop can capture the black queen' do
        board = Board.new
        board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
        board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
        board.data[6][0] = Bishop.new(board, { color: :white, location: [6, 0] })
        subject(:validator) { described_class.new([6, 0], board, [[2, 4], [5, 1], [4, 2], [3, 3]]) }

        it 'returns move to capture the queen' do
          board.instance_variable_set(:@white_king, board.data[7][4])
          result = validator.verify_possible_moves
          expect(result).to contain_exactly([2, 4])
        end
      end

      context 'when white king can move out of check' do 
        board = Board.new
        board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
        board.data[7][4] = King.new(board, { color: :white, location: [7, 4] })
        subject(:validator) { described_class.new([7, 4], board, [[6, 4], [7, 5], [7, 3], [6, 3], [6, 5]]) }

        it '4 legal moves' do
          board.instance_variable_set(:@white_king, board.data[7][4])
          result = validator.verify_possible_moves
          expect(result).to contain_exactly([7, 3], [7, 5], [6, 3], [6, 5])
        end
      end
    end
  end
end

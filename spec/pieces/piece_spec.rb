require_relative "../../lib/pieces/piece"
require_relative "../../lib/board"

class ChildPiece < Piece
  def transformations
    # Define the transformations for testing
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end


RSpec.describe Piece do
  subject(:piece) { described_class.new(board, { color: :white, location: [2, 2] }) }
  let(:board) { double(Board, data: Array.new(5) { Array.new(5) }) }

  describe '#update_location' do
    before do
      piece.update_location(3,3)
    end

    it 'updates @location to new coordinates' do
      expect(piece.location).to eq([3,3])
    end

    it 'changes value of @moved to true' do
      result = piece.moved
      expect(result).to be true
    end
  end

  describe '#current_moves' do
    before do
      board = Array.new(5){ Array.new(5) }
      child_piece = ChildPiece.new(board, { color: :white, location: [2, 2] })
      @moves = child_piece.current_moves(board)
    end

    context 'when chess piece is in middle of the board' do
      it 'returns a list of valid moves' do
        expect(@moves).to include([2, 3])
        expect(@moves).to include([2, 1])
        expect(@moves).to include([1, 2])
        expect(@moves).to include([3, 2])
      end
    end
  end
end

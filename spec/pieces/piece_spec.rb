# frozen_string_literal: true

require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'
require_relative '../../lib/move_validator'

# This class if for testing the current_moves and #current_captures methods.
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

  describe '#remove_illegal_moves' do
    let(:validator) { instance_double(MoveValidator) }

    before do
      allow(MoveValidator).to receive(:new).and_return(validator)
      allow(validator).to receive(:verify_possible_moves)
    end

    it 'creates a MoveValidator' do
      expect(MoveValidator).to receive(:new).and_return(validator)
      moves = [[1, 1], [2, 2], [3, 3]]
      piece.remove_illegal_moves(board, moves)
    end

    it 'sends verify_possible_moves to MoveValidator' do
      expect(validator).to receive(:verify_possible_moves)
      moves = [[1, 1], [2, 2], [3, 3]]
      piece.remove_illegal_moves(board, moves)
    end
  end
end

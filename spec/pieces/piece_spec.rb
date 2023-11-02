require_relative "../../lib/pieces/piece"

RSpec.describe Piece do
  subject(:piece) { described_class.new(board, { color: :white, location: [1, 2] }) }
  let(:board) { instance_double(Board) }

  describe '#update_location' do
    before do
      piece.update_location(3,3)
    end

    it 'updates @location to new coordinates' do
      expect(piece.locaton).to eq([3,3])
    end

    it 'changes value of @moved to true' do
      result = piece.moved
      expect(result).to be true
    end
  end 
end
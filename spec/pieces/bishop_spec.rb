# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Bishop do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:pic) { instance_double(Piece) }

    context 'when there are no spaces to move' do
      subject(:wbp) { described_class.new(board, { color: :white, location: [4, 0] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, pic, nil, nil, nil, nil, nil, nil],
          [wbp, nil, nil, nil, nil, nil, nil, nil],
          [nil, pic, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when there are 3 empt diagonal spaces increasing rank' do
      subject(:wbp) { described_class.new(board, { color: :white, location: [0,2] }) }
      let(:data) do
        [
          [nil, nil, wbp, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, pic, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'return 3 possible moves' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_moves(board)
        expect(result).to contain_exactly([1,1], [2,0], [1,3])
      end
    end

    context 'when there are 4 empty diagonal space in decreasing rank' do
      subject(:wbp) { described_class.new(board, { color: :white, location: [7, 5] }) }
      let(:data) do 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, pic, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, wbp, nil, nil]
        ]
      end

      it 'returns 4 possible moves' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_moves(board)

        expect(result).to contain_exactly([6, 6], [5, 7], [6, 4], [5, 3])
      end
    end

    context 'when the board is completely empty' do
      subject(:wbp) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wbp, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has thirteen moves' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_moves(board)
        expect(result).to contain_exactly([0, 0], [0, 6], [1, 1], [1, 5], [2, 2], [2, 4], [4, 2], [4, 4], [5, 1], [5, 5], [6, 0], [6, 6], [7, 7])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:wpc) { instance_double(Piece, color: :white) }
    let(:bpc) { instance_double(Piece, color: :black) }

    context 'when there are no opposing pieces to capture' do
      subject(:wbp) { described_class.new(color: :white, location: [3, 3]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wbp, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, wpc, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when there are 2 peices to capture increasing rank' do
      subject(:wbp) { described_class.new(color: :white, location: [4, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, nil, wbp, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, bpc, nil],
          [nil, bpc, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns 2 possible captures' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_captures(board)

        expect(result).to contain_exactly([7, 1], [6, 6])
      end
    end

    context 'when there is 1 peice to capture decreasing rank' do
      subject(:wbp) { described_class.new(color: :white, location: [4, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, bpc, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, nil, wbp, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns 2 possible captures' do
        allow(board).to receive(:data).and_return(data)
        result = wbp.find_possible_captures(board)

        expect(result).to contain_exactly([1, 1])
      end
    end
  end
end

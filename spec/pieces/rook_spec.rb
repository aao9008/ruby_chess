# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Rook do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possilbe_moves' do
    let(:pic) { instance_double(Piece) }

    context 'when ther are no spaces to move' do
      subject(:brk) { described_class.new(board, { color: :black, location: [0, 1] }) }
      let(:data) do
        [
          [pic, brk, pic, nil, nil, nil, nil, nil],
          [nil, pic, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result= brk.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when there are 3 empty spaces increasing in rank & 2 empty spaces increasing in file' do
      subject(:wrk) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, pic, nil, nil, nil, nil],
          [nil, nil, pic, wrk, nil, nil, pic, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, pic, nil, nil, nil, nil]
        ]
      end

      it 'returns 5 possible moves' do
        allow(board).to receive(:data).and_return(data)
        result = wrk.find_possible_moves(board)
        expect(result).to contain_exactly([4, 3], [5, 3], [6, 3], [3, 4], [3, 5])
      end
    end

    context 'when 3 decreasing ranks & 3 increasing files are empty' do
      subject(:wrk) { described_class.new(board, { color: :white, location: [3, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, pic, wrk, nil, nil, nil],
          [nil, nil, nil, nil, pic, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has six moves' do
        allow(board).to receive(:data).and_return(data)
        result = wrk.find_possible_moves(board)
        expect(result).to contain_exactly([3, 5], [3, 6], [3, 7], [2, 4], [1, 4], [0, 4])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:wpc) { instance_double(Piece, color: :white) }
    let(:bpc) { instance_double(Piece, color: :black) }

    context 'when there are no opposing pieces to catpure' do
      subject(:brk) { described_class.new(board, { color: :black, location: [3,3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil],
          [nil, nil, nil, brk, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, bpc, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = brk.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when there are 2 opposing pieces down rank and file' do
      subject(:brk) { described_class.new(board, { color: :black, location: [4, 4] }) }
      let(:data) do 
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, wpc, nil, nil, brk, nil, nil, nil],
          [nil, nil, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, bpc, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns 2 possible captures' do 
        allow(board).to receive(:data).and_return(data)
        result = brk.find_possible_captures(board)

        expect(result).to contain_exactly([2, 4], [4, 1])
      end
    end

    context 'when there are 2 opposing pieces up rank and file' do
      subject(:brk) { described_class.new(board, { color: :black, location: [5, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, wpc, nil, nil, bpc, nil, nil, nil],
          [nil, nil, nil, brk, nil, wpc, nil, nil],
          [nil, nil, nil, wpc, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns 2 possible captures' do
        allow(board).to receive(:data).and_return(data)
        result = brk.find_possible_captures(board)

        expect(result).to contain_exactly([6, 3], [5, 5])
      end
    end
  end
end

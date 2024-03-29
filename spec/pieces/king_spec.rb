# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe King do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:pic) { instance_double(Piece) }
    subject(:wkg) { described_class.new(board, { color: :white, location: [0, 3] }) }

    context 'when there are no spaces to move' do
      let(:data) do
        [
          [nil, nil, pic, wkg, pic, nil, nil, nil],
          [nil, nil, pic, pic, pic, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_moves(board)

        expect(result).to be_empty
      end
    end

    context 'when the king has 3 open square' do
      let(:data) do
        [
          [nil, nil, nil, wkg, pic, nil, nil, nil],
          [nil, nil, pic, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
        ]
      end

      it 'has three moves' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_moves(board)

        expect(result).to contain_exactly([1, 3], [0, 2], [1, 4])
      end
    end

    context 'when king can castle king-side' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, wpc, wpc, nil, nil],
          [nil, nil, nil, wpc, wkg, nil, nil, wrk],
        ]
      end

      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:wpc) { instance_double(Piece, color: :white, moved: false, location: [0, 4], captures: [[1, 4]]) }

      it 'has 2 moves' do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:king_in_check?).with(:white).and_return(false)
        result = wkg.find_possible_moves(board)
        expect(result).to contain_exactly([7, 5], [7, 6])
      end
    end

    context 'when king has moved' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 3] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'has five moves' do
        wkg.update_location([7, 4])
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_moves(board)
        expect(result).to contain_exactly([7, 3], [7, 5], [6, 3], [6, 4], [6, 5])
      end
    end

    context 'when king can castle queen-side' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:wpc) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [brk, nil, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil]
        ]
      end

      it 'has six moves' do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:king_in_check?).with(:black).and_return(false)
        allow(wpc).to receive(:find_possible_moves).and_return([7, 5])
        result = bkg.find_possible_moves(board)
        expect(result).to contain_exactly([0, 2], [0, 3], [0, 5], [1, 3], [1, 4], [1, 5])
      end
    end

    context 'when piece is between king and rook' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 1]) }
      let(:bpc) { instance_double(Piece, color: :black, moved: false, location: [0, 2]) }
      let(:wpc) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [brk, nil, bpc, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil]
        ]
      end

      it 'has five moves' do
        allow(board).to receive(:data).and_return(data)
        allow(wpc).to receive(:find_possible_moves).and_return([7, 5])
        result = bkg.find_possible_moves(board)
        expect(result).to contain_exactly([0, 3], [0, 5], [1, 3], [1, 4], [1, 5])
      end
    end

    context 'when king neighbor square can attacked' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:brk) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, brk, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'will not include castling move' do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:king_in_check?).with(:white).and_return(false)
        allow(brk).to receive(:find_possible_moves).and_return([[7, 5]])
        result = wkg.find_possible_moves(board)
        expect(result).not_to include([7, 6])
      end
    end

    context 'when king is in check and can not castle' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:brk) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, brk, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'will not include castling move' do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:king_in_check?).with(:white).and_return(true)
        allow(brk).to receive(:find_possible_moves).and_return([[7, 3]])
        result = wkg.find_possible_moves(board)
        expect(result).not_to include([7, 6])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:wpc) { instance_double(Piece, color: :white, symbol: nil) }
    let(:bpc) { instance_double(Piece, color: :black, symbol: nil) }

    context 'when there are no opposing pieces to capture' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, wpc, wpc, nil, nil],
          [nil, nil, nil, wpc, wkg, wpc, nil, nil]
        ]

      end
      it 'has no captures' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_captures(board)

        expect(result).to be_empty
      end
    end

    context 'when the king is adjacent to 1 opposing piece' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, bpc, wpc, nil, nil],
          [nil, nil, nil, wpc, wkg, wpc, nil, nil]
        ]
      end

      it 'has one capture' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_captures(board)

        expect(result).to contain_exactly([6, 4])
      end
    end

    context 'when the king is adjacent to 2 opposing pieces' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [4, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, bpc, bkg, bpc, nil, nil],
          [nil, nil, nil, wpc, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two captures' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.find_possible_captures(board)

        expect(result).to contain_exactly([5, 3], [3, 5])
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/piece'
#require_relative '../lib/movement/movement_factory'
#require_relative '../lib/movement/basic_movement'
#require_relative '../lib/movement/en_passant_movement'
#require_relative '../lib/movement/pawn_promotion_movement'
#require_relative '../lib/movement/castling_movement'

RSpec.describe Board do
  subject(:board) { described_class.new }

  describe '#initial_placement' do
    before do
      board.initial_placement
    end

    it 'has top row of black game pieces' do
      expect(board.data[0].all? { |piece| piece.color == :black }).to be true
    end

    it 'has second row of black game pieces' do
      expect(board.data[1].all? { |piece| piece.color == :black }).to be true
    end

    it 'has sixth row of white game pieces' do
      expect(board.data[6].all? { |piece| piece.color == :white }).to be true
    end

    it 'has bottom row of white game pieces' do
      expect(board.data[7].all? { |piece| piece.color == :white }).to be true
    end

    it 'has top row first Rook' do
      expect(board.data[0][0].instance_of?(Rook)).to be true
    end

    it 'has top row first Knight' do
      expect(board.data[0][1].instance_of?(Knight)).to be true
    end

    it 'has top row first Bishop' do
      expect(board.data[0][2].instance_of?(Bishop)).to be true
    end

    it 'has top row Queen' do
      expect(board.data[0][3].instance_of?(Queen)).to be true
    end

    it 'has top row King' do
      expect(board.data[0][4].instance_of?(King)).to be true
    end

    it 'has top row second Bishop' do
      expect(board.data[0][5].instance_of?(Bishop)).to be true
    end

    it 'has top rowsecond Knight' do
      expect(board.data[0][6].instance_of?(Knight)).to be true
    end

    it 'has top row second Rook' do
      expect(board.data[0][7].instance_of?(Rook)).to be true
    end

    it 'has second row of pawns' do
      expect(board.data[1].all? { |piece| piece.instance_of?(Pawn) }).to be true
    end

    it 'has sixth row of pawns' do
      expect(board.data[6].all? { |piece| piece.instance_of?(Pawn) }).to be true
    end

    it 'has bottom row first Rook' do
      expect(board.data[7][0].instance_of?(Rook)).to be true
    end

    it 'has bottom row first Knight' do
      expect(board.data[7][1].instance_of?(Knight)).to be true
    end

    it 'has bottom row first Bishop' do
      expect(board.data[7][2].instance_of?(Bishop)).to be true
    end

    it 'has bottom row Queen' do
      expect(board.data[7][3].instance_of?(Queen)).to be true
    end

    it 'has bottom row King' do
      expect(board.data[7][4].instance_of?(King)).to be true
    end

    it 'has bottom row second Bishop' do
      expect(board.data[7][5].instance_of?(Bishop)).to be true
    end

    it 'has bottom row second Knight' do
      expect(board.data[7][6].instance_of?(Knight)).to be true
    end

    it 'has bottom row second Rook' do
      expect(board.data[7][7].instance_of?(Rook)).to be true
    end
  end

  describe '#update_active_piece' do
    subject(:board) { described_class.new(data_update) }
    let(:data_update) { [ [piece, nil], [nil, nil]] }
    let(:piece) { instance_double(Piece, location: [0, 0]) }

    it 'updates active piece with position' do
      position = [0, 0]
      board.update_active_piece(position)
      expect(board.active_piece).to eql(piece)
    end
  end

  describe '#active_piece_moveable?' do
    subject(:board) { described_class.new(data_update) }
    let(:data_update) { [[piece, nil], [nil, nil]] }
    let(:piece) { instance_double(Piece, location: [0, 0]) }

    context 'when there is at least one current move' do
      it 'returns true' do
        allow(piece).to receive(:moves).and_return([0, 1])
        allow(piece).to receive(:captures)
        board.instance_variable_set(:@active_piece, piece)
        result = board.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there is at least one current capture' do
      it 'returns true' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([1, 1])
        board.instance_variable_set(:@active_piece, piece)
        result = board.active_piece_moveable?
        expect(result).to be true
      end
    end

    context 'when there are no moves or captures' do
      it 'returns false' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([])
        board.instance_variable_set(:@active_piece, piece)
        result = board.active_piece_moveable?
        expect(result).to be false
      end
    end
  end

  describe '#valid_piece_movement?' do
    context 'when position matches a valid move' do
      let(:piece) { double(Piece, location: [0, 0]) }
      let(:data) { [[piece, nil], [nil, nil]] }
      subject(:board) { described_class.new(data, { active_piece: data[0][0] }) }

      it 'returns true' do
        allow(piece).to receive(:moves).and_return([[1, 1]])
        pos = [1, 1]
        result = board.valid_piece_movement?(pos)
        expect(result).to be true
      end
    end

    context 'when position matches a valid capture' do
      let(:piece) { double(Piece, location: [0, 0]) }
      let(:data) { [[piece, nil], [nil, nil]] }
      subject(:board) { described_class.new(data, { active_piece: data[0][0] }) }

      it 'returns true' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([[1, 1]])
        pos = [1, 1]
        result = board.valid_piece_movement?(pos)
        expect(result).to be true
      end
    end

    context 'whe a position does not match a valid move or capture' do
      let(:piece) { double(Piece, location: [0, 0]) }
      let(:data) { [[piece, nil], [nil, nil]] }
      subject(:board) { described_class.new(data, { active_piece: data[0][0] }) }

      it 'returns false' do
        allow(piece).to receive(:moves).and_return([])
        allow(piece).to receive(:captures).and_return([])
        pos = [1, 1]
        result = board.valid_piece_movement?(pos)
        expect(result).to be false
      end
    end
  end

  describe '#valid_piece?' do
    let(:piece) { instance_double(Piece, color: :white) }
    let(:data) { [[piece, nil], [nil, nil]] }
    subject(:board) { described_class.new(data, { active_piece: data[0][0] }) }

    context 'when position is a piece of the right color' do
      it 'returns true' do
        position = [0, 0]
        results = board.valid_piece?(position, :white)
        expect(results).to be true
      end
    end

    context 'when position is not a piece' do
      it 'returns false' do
        position = [1, 0]
        results = board.valid_piece?(position, :white)
        expect(results).to be false
      end
    end

    context 'when position is a piece of the wrong color' do
      it 'returns false' do
        position = [0, 0]
        results = board.valid_piece?(position, :black)
        expect(results).to be false
      end
    end
  end

  describe '#movement_type' do
    before do
      @pos = [0, 0]
    end

    context 'when movement is an en_passant capture' do
      it "returns 'EnPassant' " do
        allow(board).to receive(:en_passant_capture?).and_return(true)
        expect(board.movement_type(@pos)).to eq('EnPassant')
      end
    end

    context 'when movement is a pawn promotion' do
      it "returns 'PawnPromotion' " do
        allow(board).to receive(:en_passant_capture?).and_return(false)
        allow(board).to receive(:pawn_promotion?).and_return(true)
        expect(board.movement_type(@pos)).to eq('PawnPromotion')
      end
    end

    context 'when movement is a castling move' do
      it "reutrns 'Castling' " do
        allow(board).to receive(:en_passant_capture?).and_return(false)
        allow(board).to receive(:pawn_promotion?).and_return(false)
        allow(board).to receive(:castling?).and_return(true)
        expect(board.movement_type(@pos)).to eq('Castling')
      end
    end

    context 'when movment does not meet any of the condition listed above' do
      it "returns 'Basic' " do
        allow(board).to receive(:en_passant_capture?).and_return(false)
        allow(board).to receive(:pawn_promotion?).and_return(false)
        allow(board).to receive(:castling?).and_return(false)
        expect(board.movement_type(@pos)).to eq('Basic')
      end
    end
  end

  describe '#reset_board_values' do
    subject(:board) { described_class.new(data, { active_piece: data[0][0] }) }
    let(:data) { [[piece, nil], [nil, nil]] }
    let(:piece) { double(Piece, location: [0, 0]) }

    before do
      allow(board).to receive(:notify_observers)
    end

    it 'sets previous_piece to active_piece' do
      board.reset_board_values
      expect(board.previous_piece).to eq(piece)
    end

    it 'sets active_piece to nil' do
      board.reset_board_values
      expect(board.active_piece).to be_nil
    end

    it 'notifies the observers' do
      expect(board).to receive(:notify_observers)
      board.reset_board_values
    end
  end

  describe '#king_in_check?' do
    context 'when king is in check' do
      subject(:board) { described_class.new(data, { white_king: data[7][4] }) }
      let(:bqn) { instance_double(Queen, color: :black, location: [0, 4], captures: [[7, 4]]) }
      let(:wkg) { instance_double(King, color: :white, location: [7, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [bqn, nil, nil, nil, wkg, nil, nil, nil]
        ]
      end

      it 'returns true' do
        result = board.king_in_check?(:white)
        expect(result).to be true
      end
    end

    context 'when king is not in check' do
      subject(:board) { described_class.new(data, { white_king: data[7][4] }) }
      let(:brk) { instance_double(Rook, color: :black, location: [0, 0], captures: [[1, 0], [0, 1]]) }
      let(:wkg) { instance_double(King, color: :white, location: [7, 4]) }
      let(:data) do
        [
          [brk, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, nil]
        ]
      end

      it 'returns false' do
        result = board.king_in_check?(:white)
        expect(result).to be false
      end
    end
  end
end

#frozen_string_literal: true
require_relative '../../lib/movement/basic_movement'
require_relative 'shared_examples'
require_relative '../../lib/movement/castling_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/rook'

RSpec.describe CastlingMovement do
  describe '#update_pieces' do
    subject(:movement) { described_class.new }
    before do
      allow(movement).to receive(:update_castling_moves)
    end

    include_examples 'movement behavior', :update_castling_moves
  end

  subject(:movement) { described_class.new(board, [7, 6]) }
  let(:board) { instance_double(Board) }
  let(:wkg) { instance_double(King, location: [7, 4], color: :white) }
  let(:wrk1) { instance_double(Rook, location: [7, 0], color: :white) }
  let(:wrk2) { instance_double(Rook, location: [7, 7], color: :white) }
  let(:data) do
    [
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [wrk1, nil, nil, nil, wkg, nil, nil, wrk2]
    ]
  end

  before do
    allow(board).to receive(:data).and_return(data)
    allow(board).to receive(:active_piece).and_return(wkg)
  end

  describe '#find_castling_rook' do
    it 'returns the rook that can castle' do
      result = movement.find_castling_rook
      expect(result).to eq(wrk2)
    end
  end

  describe '#update_rook_position' do
    it 'moves the rook to new position' do
      movement.update_rook_position(wrk2)
      new_rook_postion = movement.board.data[7][5]

      expect(new_rook_postion).to eq(wrk2)
    end
  end

  describe '#remove_original_rook_piece' do
    it 'updates the previous location of the castling rook to nil' do
      movement.remove_original_rook_piece
      old_rook_location = movement.board.data[7][7]
      expect(old_rook_location).to be nil
    end
  end

  describe '#update_castling_rook_location' do
    it 'updates location of the new rook piece' do
      expect(wrk2).to receive(:update_location).with([7, 5])
      movement.update_castling_rook_location(wrk2)
    end
  end

  describe '#update_new_position' do
    new_location = [7, 6]
    include_examples 'piece placement behavior', new_location
  end

  describe '#remove_original_piece' do
    old_location = [7, 4]
    include_examples 'piece removal behavior', old_location
  end
end
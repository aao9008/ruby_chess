#frozen_string_literal: true
require_relative '../../lib/movement/basic_movement'
require_relative 'shared_examples'
require_relative '../../lib/movement/en_passant_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'

RSpec.describe EnPassantMovement do
  describe '#update_pieces' do
    subject(:movement) { described_class.new }
    before do
      allow(movement).to receive(:update_en_passant_moves)
    end

    include_examples 'movement behavior', :update_en_passant_moves
  end

  subject(:movement) { described_class.new(board, [4, 3]) }
  let(:board) { instance_double(Board) }
  let(:wpn) { instance_double(Pawn, { location: [4, 3], color: :white }) }
  let(:bpn) { instance_double(Pawn, { location: [4, 2], color: :black }) }
  let(:data) do
    [
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, bpn, wpn, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]
    ]
  end

  before do
    allow(board).to receive(:data).and_return(data)
    allow(board).to receive(:active_piece).and_return(bpn)
  end

  describe '#remove_capture_piece_observer' do
    include_examples 'observer management'
  end

  describe '#remove_en_passant_pawn' do
    it 'removes en passant pawn from the board' do
      movement.remove_en_passant_pawn
      en_passant_position = movement.board.data[movement.pos.first][movement.pos.last]
      expect(en_passant_position).to be nil
    end
  end

  describe '#find_en_passant_capture_position' do
    before do
      allow(bpn).to receive(:rank_direction).and_return(1)
    end

    it 'returns the final position of the capturing pawn' do
      result = movement.find_en_passant_capture_position
      expect(result).to eq([5, 3])
    end
  end

  describe 'update_new_position' do
    it 'updates the value of a given board position to active piece' do
      new_location = [5, 3]
      movement.update_new_position(new_location)
      result = board.data[new_location.first][new_location.last]
      expect(result).to eq(board.active_piece)
    end
  end

  describe '#remove_original_piece' do
    old_location = [4, 2]
    include_examples 'piece removal behavior', old_location
  end

  describe '#update_active_piece_location' do

    it 'updates the location property of the active piece to the given value' do
      new_location = [5, 3] 
      expect(board.active_piece).to receive(:update_location).with(new_location)
      movement.update_active_piece_location(new_location)
    end
  end
end

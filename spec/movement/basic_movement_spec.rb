# frozen_string_literal: true
require_relative '../../lib/board'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/movement/basic_movement'
require_relative 'shared_examples'

RSpec.describe BasicMovement do
  describe '#update_pieces' do
    subject(:movement) { described_class.new }
    include_examples 'movement behavior', :update_basic_moves
  end

  subject(:movement) { described_class.new(board, [5, 5]) }
  let(:board) { instance_double(Board) }
  let(:wpn) { instance_double(Piece, location: [6, 4]) }
  let(:bpn) { instance_double(Piece, location: [5, 5]) }
  let(:data) do
    [
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, bpn, nil, nil],
      [nil, nil, nil, nil, wpn, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]
    ]
  end

  before do
    allow(board).to receive(:data).and_return(data)
    allow(board).to receive(:active_piece).and_return(wpn)
  end

  describe '#remove_capture_piece_observer' do
    include_examples 'observer management'
  end

  describe '#update_new_position' do
    new_location = [5, 5]
    include_examples 'piece placement behavior', new_location
  end

  describe '#remove_original_piece' do
    old_location = [6, 4]
    include_examples 'piece removal behavior', old_location
  end

  describe '#update_active_piece_location' do
    new_location = [5, 5]
    include_examples 'update location behavior', new_location
  end
end

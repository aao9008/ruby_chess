# frozen_string_literal: true
require_relative '../../lib/movement/basic_movement'
require_relative 'shared_examples'
require_relative '../../lib/movement/pawn_promotion_movement'
require_relative '../../lib/board'
require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/queen'

RSpec.describe PawnPromotionMovement do
  describe '#update_pieces' do
    subject(:movement) { described_class.new }
    before do
      allow(movement).to receive(:update_pawn_promotion_moves)
    end

    include_examples 'movement behavior', :update_pawn_promotion_moves
  end

  subject(:movement) { described_class.new(board, [0, 4]) }
  let(:board) { instance_double(Board) }
  let(:wpn) { instance_double(Piece, location: [1, 4], color: :white) }
  let(:data) do
    [
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, wpn, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]
    ]
  end

  before do
    allow(board).to receive(:data).and_return(data)
    allow(board).to receive(:active_piece).and_return(wpn)
    allow(board).to receive(:delete_observer).with(wpn)
  end

  describe '#remove_pawn_observer' do
    it 'removes the active pawn piece from the observer list' do
      expect(board).to receive(:delete_observer).with(wpn)
      movement.remove_pawn_observer
    end
  end

  describe '#new_promotion_piece' do
    before do
      allow(movement).to receive(:puts)
      allow(movement).to receive(:pawn_promotion_choices)
      user_input = '2'
      allow(movement).to receive(:select_promotion_piece).and_return(user_input)
      allow(movement).to receive(:create_promotion_piece).with(user_input)
    end

    after do
      movement.new_promotion_piece
    end

    it 'sends the promotion choices' do
      expect(movement).to receive(:pawn_promotion_choices)
    end

    it 'gets the player choice' do
      expect(movement).to receive(:select_promotion_piece).and_return('2')
    end

    it 'creates the chosen piece' do
      expect(movement).to receive(:create_promotion_piece).with('2')
    end
  end

  describe '#select_promotion_piece' do
    context 'when user input is valid' do
      it 'returns valid user input' do
        user_input = '1'
        allow(movement).to receive(:gets).and_return(user_input)
        result = movement.select_promotion_piece
        expect(result).to eq('1')
      end
    end

    context 'when user input is not valid' do
      it 'outputs warning message' do
        letter_input = 'a'
        invalid_number = '6'
        valid_input = '1'
        warning = 'Input error! Only enter 1-digit (1-4).'
        allow(movement).to receive(:gets).and_return(letter_input,invalid_number, valid_input)
        expect(movement).to receive(:puts).with(warning).twice
        movement.select_promotion_piece
      end

      it 'returns second valid user input' do
        letter_input = 'j'
        number_input = '2'
        warning = 'Input error! Only enter 1-digit (1-4).'
        allow(movement).to receive(:gets).and_return(letter_input, number_input)
        allow(movement).to receive(:puts).with(warning).once
        result = movement.select_promotion_piece
        expect(result).to eq('2')
      end
    end
  end

  describe '#create_promotion_piece' do
    it 'creates new piece' do
      pawn_info = { location: [0, 4], color: :white }
      user_input = '1'

      expect(Queen).to receive(:new).with(board, pawn_info)
      movement.create_promotion_piece(user_input)
    end
  end

  describe '#update_new_position' do
    new_location = [0, 4]
    include_examples 'piece placement behavior', new_location
  end

  describe '#remove_original_piece' do
    old_location = [1, 4]
    include_examples 'piece removal behavior', old_location
  end

  describe '#update_board_active_piece' do
    let(:wqn) { instance_double(Piece, color: :white) }

    it 'updates the active piece to the promoted piece' do
      allow(board).to receive(:active_piece=).and_return(wqn)
      allow(board).to receive(:active_piece).and_return(wqn)

      movement.update_board_active_piece(wqn)
      expect(movement.board.active_piece).to be(wqn)
    end
  end
end

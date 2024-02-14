# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/notation_translator'

RSpec.describe Game do
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters an opponent's piece
  class LocationError < StandardError
    def message
      'Invalid coordinates! Enter column & row of the correct color.'
    end
  end

  # Declares error message when user enters a piece without moves
  class PieceError < StandardError
    def message
      'Invalid piece! This piece does not have any legal moves.'
    end
  end

  # Declares error message when user enters invalid move location
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column and row to move.'
    end
  end

  player_count = 2
  subject(:game) { described_class.new(player_count, board) }
  let(:board) { instance_double(Board) }

  describe '#setup_board' do
    it 'sends #initial_placement to board' do
      expect(board).to receive(:initial_placement)
      game.setup_board
    end
  end

  describe '#play' do
    context 'when #game_over? is false 3 times' do
      it 'calls #player_turn 3 times' do
        allow(board).to receive(:to_s)
        allow(board).to receive(:game_over?).and_return(false, false, false, true)
        allow(game).to receive(:final_message)

        expect(game).to receive(:play_round).exactly(3).times
        game.play
      end
    end
  end

  describe '#play_round' do
    before do
      allow(game).to receive(:player_turn)
      allow(game).to receive(:switch_color)
      allow(board).to receive(:to_s)
    end

    it 'calls #player_turn' do
      expect(game).to receive(:player_turn)
      game.play_round
    end

    it 'calls #switch_color' do
      expect(game).to receive(:switch_color)
      game.play_round
    end
  end

  describe '#select_piece_location' do
    it 'sends #update_active piece to board' do
      allow(game).to receive(:user_select_piece)
      location = [0, 0]
      allow(game).to receive(:translate_coordinates).and_return(location)
      allow(game).to receive(:validate_piece_location).with(location)
      allow(game).to receive(:validate_active_piece)
      expect(board).to receive(:update_active_piece).with(location)
      game.select_piece_location
    end
  end

  describe '#translate_coordinates' do
    it 'sends command message to NotationTranslator' do
      user_input = 'd2'
      expect_any_instance_of(NotationTranslator).to receive(:translate_position).with(user_input)
      game.translate_coordinates(user_input)
    end
  end

  describe '#validate_move_input' do
    context 'when input is valid' do
      it 'does not raise an error' do
        expect { game.validate_move_input('c6') }.not_to raise_error
      end
    end

    context 'when input is invalid' do
      it 'raises an error' do
        expect { game.validate_move_input('6c') }.to raise_error(Game::InputError)
      end
    end

    context 'when input is invalid' do
      it 'raises an error' do
        expect { game.validate_move_input('66') }.to raise_error(Game::InputError)
      end
    end

    context 'when input is invalid' do
      it 'raises an error' do
        expect { game.validate_move_input('cc') }.to raise_error(Game::InputError)
      end
    end
  end

  describe '#validate_piece_location' do
    context 'when locations contains a piece' do
      it 'does not raise an error' do
        allow(board).to receive(:valid_piece?).and_return(true)
        location = [0, 0]
        expect { game.validate_piece_location(location) }.not_to raise_error
      end
    end

    context 'when locations does not contain a piece' do
      it 'raises an error' do
        allow(board).to receive(:valid_piece?).and_return(false)
        location = [5, 5]
        expect { game.validate_piece_location(location) }.to raise_error(Game::LocationError)
      end
    end
  end

  describe '#validate_move_location' do
    context 'when locations is valid piece movement' do
      it 'does not raise an error' do
        allow(board).to receive(:valid_piece_movement?).and_return(true)
        location = [0, 0]
        expect { game.validate_move_location(location) }.not_to raise_error
      end
    end

    context 'when locations is not a valid piece movement' do
      it 'raises an error' do
        allow(board).to receive(:valid_piece_movement?).and_return(false)
        location = [5, 5]
        expect { game.validate_move_location(location) }.to raise_error(Game::MoveError)
      end
    end
  end

  describe '#validate_active_piece' do
    context 'when active piece is moveable' do
      it 'does not raise an error' do
        allow(board).to receive(:active_piece_moveable?).and_return(true)
        expect { game.validate_active_piece }.not_to raise_error
      end
    end

    context 'when active piece is not moveable' do
      it 'does not raise an error' do
        allow(board).to receive(:active_piece_moveable?).and_return(false)
        expect { game.validate_active_piece }.to raise_error(Game::PieceError)
      end
    end
  end

  describe '#final_message' do
    context 'when game has a king in check' do
      it 'outputs checkmate message' do
        allow(board).to receive(:king_in_check?).and_return(true)
        checkmate = "\e[36mBlack\e[0m wins! The white king is in checkmate.\n"
        expect { game.final_message }.to output(checkmate).to_stdout
      end
    end
  end

  context 'when game does not have a king in check' do
    it 'outputs stalemate message' do
      allow(board).to receive(:king_in_check?).and_return(false)
      checkmate = "\e[36mBlack\e[0m wins in a stalemate!\n"
      expect { game.final_message }.to output(checkmate).to_stdout
    end
  end

  describe '#switch_color' do
    context 'when current_turn is :white' do
      it 'changes to :black' do
        game.switch_color
        result = game.instance_variable_get(:@current_turn)
        expect(result).to eq(:black)
      end
    end

    context 'when current_turn is :black' do
      player_count = 2
      subject(:game) { described_class.new(player_count, board, :black) }

      it 'changes to :white' do
        game.switch_color
        result = game.instance_variable_get(:@current_turn)
        expect(result).to eq(:white)
      end
    end
  end
end


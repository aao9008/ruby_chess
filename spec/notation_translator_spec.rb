# frozen_string_literal: true

require_relative '../lib/notation_translator'

RSpec.describe NotationTranslator do
  subject(:translator) { described_class.new }

  describe '#translate_position' do 
    context 'when user input is a8' do
      it 'returns [0, 0]' do
        user_input = 'a8'
        result = translator.translate_position(user_input)
        expect(result).to eq([0, 0])
      end
    end

    context 'when user input is b7' do
      it 'returns [1, 1]' do
        user_input = 'b7'
        result = translator.translate_position(user_input)
        expect(result).to eq([1, 1])
      end
    end

    context 'when user input is c6' do
      it 'returns [2, 2]' do
        user_input = 'c6'
        result = translator.translate_position(user_input)
        expect(result).to eq([2, 2])
      end
    end

    context 'when user input is d5' do
      it 'returns [3, 3]' do
        user_input = 'd5'
        result = translator.translate_position(user_input)
        expect(result).to eq([3, 3])
      end
    end

    context 'when user input is e4' do
      it 'returns [4, 4]' do
        user_input = 'e4'
        result = translator.translate_position(user_input)
        expect(result).to eq([4, 4])
      end
    end

    context 'when user input is f3' do
      it 'returns [5, 5]' do
        user_input = 'f3'
        result = translator.translate_position(user_input)
        expect(result).to eq([5, 5])
      end
    end

    context 'when user input is g2' do
      it 'returns [6, 6]' do
        user_input = 'g2'
        result = translator.translate_position(user_input)
        expect(result).to eq([6, 6])
      end
    end

    context 'when user input is h1' do
      it 'returns [7, 7]' do
        user_input = 'h1'
        result = translator.translate_position(user_input)
        expect(result).to eq([7, 7])
      end
    end
  end
end

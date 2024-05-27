# frozen_string_literal: true

require_relative '../lib/serializer'

RSpec.describe Serializer do
  let(:dummy_class) { Class.new { extend Serializer } }

  describe '#save_game' do
    before do
      allow(dummy_class).to receive(:puts)
      allow(Marshal).to receive(:dump)
      allow(File).to receive(:open).and_yield(StringIO.new)
    end

    it 'opens a file' do
      expect(File).to receive(:open)
      dummy_class.save_game
    end

    it 'dumps to the file' do
      expect(Marshal).to receive(:dump)
      dummy_class.save_game
    end

    it 'raises no errors' do
      expect { dummy_class.save_game }.not_to raise_error
    end
  end

  describe '#select_saved_game' do
    context 'when input is invalid' do
      it 'outputs error message' do
        warning = 'Input error! Enter a valid file number.'
        expect(dummy_class).to receive(:puts).with(warning).once

        valid_input = '1'
        invalid_input = 'a'
        allow(dummy_class).to receive(:gets).and_return(invalid_input, valid_input)
        dummy_class.select_saved_game(3)
      end

      it 'returns second (valid) user input' do
        warning = 'Input error! Enter a valid file number.'
        allow(dummy_class).to receive(:puts).with(warning).once
        valid_input = '1'
        invalid_input = 'a'
        allow(dummy_class).to receive(:gets).and_return(invalid_input, valid_input)
        result = dummy_class.select_saved_game(3)

        expect(result).to eq('1')
      end
    end
  end

  describe '#load_game' do
    before do
      allow(dummy_class).to receive(:find_saved_game).and_return('test')
      allow(Marshal).to receive(:load)
      allow(File).to receive(:open).and_yield(StringIO.new)
    end

    it 'opens a file' do
      expect(File).to receive(:open)
      dummy_class.load_game
    end

    it 'loads the file' do
      expect(Marshal).to receive(:load)
      dummy_class.load_game
    end
  end
end

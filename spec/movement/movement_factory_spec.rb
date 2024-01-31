# frozen_string_literal: true

require_relative '../../lib/movement/movement_factory'
require_relative '../../lib/movement/castling_movement'
require_relative '../../lib/movement/basic_movement'
require_relative '../../lib/movement/pawn_promotion_movement'
require_relative '../../lib/movement/en_passant_movement'

RSpec.describe MovementFactory do
  describe '#build' do
    context "when given the 'Basic' movement string" do
      subject(:factory) { described_class.new('Basic') }

      it 'creates a new instance of the BasicMovement class' do
        result = factory.build
        expect(result).to be_an_instance_of(BasicMovement)
      end
    end

    context "when given the 'PawnPromotion' movement string" do
      subject(:factory) { described_class.new('PawnPromotion') }

      it 'creates a new instance of the PawnPromotionMovement class' do
        result = factory.build
        expect(result).to be_an_instance_of(PawnPromotionMovement)
      end
    end

    context "when given the 'Castling' movement string" do
      subject(:factory) { described_class.new('Castling') }

      it 'creates a new instance of the CastlingMovement class' do
        result = factory.build
        expect(result).to be_an_instance_of(CastlingMovement)
      end
    end

    context "when given the 'EnPassant' movement string" do
      subject(:factory) { described_class.new('EnPassant') }

      it 'creates a new instance of the BasicMovement class' do
        result = factory.build
        expect(result).to be_an_instance_of(EnPassantMovement)
      end
    end
  end
end

# frozen_string_literal: true

require 'observer'

# contains logic for chess board
class Board
  include Observable
  attr_reader :black_king, :white_king, :mode
  attr_accessor :data, :active_piece, :previous_piece

  def initialize(data = Array.new(8) { Array.new(8) }, params = {})
    @data = data
    @active_piece = params[:active_piece]
    @previous_piece = params[:previous_piece]
    @black_king = params[:black_king]
    @white_king = params[:white_king]
  end
end

# frozen_string_literal: true

class NotationTranslator
  def initialize
    @row = nil
    @column = nil
  end

  def translate_position(pos)
    translate_rank(pos[0])
    translate_file(pos[-1])
    [@row, @column]
  end

  private

  def translate_rank(rank)
    @row = rank.ord - 97
  end

  def translate_file(file)
    @column = 8 - file.to_i
  end
end

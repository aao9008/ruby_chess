# frozen_string_literal: true

class NotationTranslator
  def initialize
    @row = nil
    @column = nil
  end

  def translate_position(pos)
    translate_file(pos[0])
    translate_rank(pos[-1])
    p [@row, @column]
  end

  private

  def translate_rank(rank)
    @row = 8 - rank.to_i
  end

  def translate_file(file)
    @column = file.downcase.ord - 97
  end
end

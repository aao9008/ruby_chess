# frozen_string_literal: true

# Logic for creating movement classes that update the board
class MovementFactory
  def initialize(movement_type)
    @movement_class = self.class.const_get("#{movement_type}Movement")
  end

  def build
    @movement_class.new
  end
end
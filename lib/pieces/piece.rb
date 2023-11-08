class Piece
  attr_reader :color, :location, :symbol, :moves, :captures, :moved, :board

  def initialize(board, args)
    @board = board
    @color = args[:color]
    @location = args[:location]
    @symbol = nil
    @move_list = nil
    @capture_list = nil
    @moved = false
  end

  def update_location(rank, file)
    @location = [rank, file]
    @moved = true
  end

  # Returns array of valid move locations for pieces that can move multiple squares.
  def current_moves(board)
    # Create a list of possible moves
    @move_list = find_possible_moves(board)
  end

  private

  # Creates and returns list of all possible moves
  def find_possible_moves(board, start = @location)
    # Iterate over list of move transformations
    transformations.each_with_object([]) do |transformation, list|
      # Preform intial transformation
      pos = update_pos(transformation, start)

      # Repeate transformation until edge of board is reached or occupied pos is reached
      while valid_move?(pos) && board[pos.first][pos.last].nil?
        # Store move to list
        list << pos

        # Preform transformation
        pos = update_pos(transformation, pos)
      end
    end
  end

  # Preform transformation
  def update_pos(transformation, pos)
    [transformation.first + pos.first, transformation.last + pos.last]
  end

  # Check if move is valid
  def valid_move?(pos)
    # Move is valid if rank is between 0-7
    # Move is valid if file is between 0-7
    pos.first.between?(0, board.size - 1) && pos.last.between?(0, board.size - 1)
  end
end


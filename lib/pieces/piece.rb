require_relative '../board'
require_relative '../move_validator'

# Superclass that contains movment logic for all chess peices
class Piece
  attr_reader :color, :location, :symbol, :moves, :captures, :moved, :board

  def initialize(board, args)
    # These variables are initialized via passed parameters and subclass initilization method.
    board.add_observer(self)
    @color = args[:color]
    @location = args[:location]
    @symbol = nil

    # These variables are set by movment functions
    @moves = nil
    @captures = nil
    @moved = false
  end

  # Update the current location of the game piece.
  def update_location(rank, file)
    @location = [rank, file]
    @moved = true
  end

  # Returns array of valid move locations for pieces that can move multiple squares.
  def current_moves(board)
    # Create a list of possible moves
    possible_moves = find_possible_moves(board)

    # Remove illegal moves from possible moves list
    @moves = remove_illegal_moves(board, possible_moves)
  end

  # Creates and returns list of all possible moves
  def find_possible_moves(board)
    # Iterate over move set and create list of moves
    moves = move_set.inject([]) do |list, move|
      list << create_moves(board.data, move)
    end

    # Return list of moves
    moves.compact.flatten(1)
  end

  # Returns array of valid capture locations for pieces that can move multiple squares
  def current_captures(board)
    # Create list of possible moves/captures
    possible_captures = find_possible_captures(board)

    # Remove illegal moves/captures
    @captures = remove_illegal_moves(board, possible_captures)
  end

  # Returns list of possible captures
  def find_possible_captures(board)
    # Iterate over move set and create list of moves
    captures = move_set.inject([]) do |list, move|
      list << create_captures(board.data, move)
    end

    # Return list of moves
    captures.compact
  end

  # method used when notified of a change in Board (as an observer)
  def update(board)
    current_captures(board)
    current_moves(board)
  end

  # Remove moves that leave king in check
  def remove_illegal_moves(board, moves)
    return moves unless moves.size.positive?

    temp_board = Marshal.load(Marshal.dump(board))
    validator = MoveValidator.new(location, temp_board, moves)
    validator.verify_possible_moves
  end

  private

  # Returns list of transformations from sublcass
  def move_set
    raise 'Called abstract method: move_set'
  end

  def create_moves(data, transformation)
    # Preform intial transformation
    pos = move_piece(transformation, location)

    # List of moves
    list = []

    # Repeate transformation until edge of board is reached or occupied pos is reached
    while valid_move?(pos, data) && data[pos.first][pos.last].nil?
      # Store move to list
      list << pos

      # Preform transformation
      pos = move_piece(transformation, pos)
    end

    # Return list
    list
  end

  # add capture to list when opposing piece is reached, based on each piece's move_set
  def create_captures(data, transformation)
    # Preform intial transformation
    pos = move_piece(transformation, location)

    # Move through the board
    while valid_move?(pos, data)
      # Stop if space is occupied
      break if data[pos.first][pos.last]

      # Move onto next location on the board
      pos = move_piece(transformation, pos)
    end

    # Return location if it is occupied by enemy piece.
    pos if opposing_piece?(pos, data)
  end

  # Checks if space is occupied enemy piece
  def opposing_piece?(pos, data)
    return unless valid_move?(pos, data)

    piece = data[pos.first][pos.last]
    piece && piece.color != color
  end

  # Preform transformation
  def move_piece(transformation, pos)
    [transformation.first + pos.first, transformation.last + pos.last]
  end

  # Check if move is valid
  def valid_move?(pos, data)
    # Move is valid if rank is between 0-7
    # Move is valid if file is between 0-7
    pos.first.between?(0, data.size - 1) && pos.last.between?(0, data.size - 1)
  end

  #### Following functions are for peices that can only apply their move transformations once ####
  def single_move_set(board)
    moves = move_set.inject([]) do |list, move|
      list << create_single_moves(board.data, move)
    end

    moves.compact
  end

  def single_capture_set(board)
    captures = move_set.inject([]) do |list, move|
      list << create_single_captures(board.data, move)
    end

    captures.compact
  end

  def create_single_moves(data, transformation)
    pos = move_piece(transformation, location)

    pos if valid_move?(pos, data) && data[pos.first][pos.last].nil?
  end

  def create_single_captures(data, transformation)
    pos = move_piece(transformation, location)

    pos if valid_move?(pos, data) && opposing_piece?(pos, data)
  end
end

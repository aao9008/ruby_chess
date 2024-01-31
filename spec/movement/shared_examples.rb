RSpec.shared_examples 'movement behavior' do |update_method|
  let(:board) { instance_double(Board) }
  let(:pic) { instance_double(Piece, location: [0, 0]) }
  let(:data) do
    [
      [pic, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]
    ]
  end

  before do
    allow(board).to receive(:delete_observer)
    allow(board).to receive(:data).and_return(data)
    allow(pic).to receive(:update_location).with([0, 1])
    allow(board).to receive(:active_piece).and_return(pic)
    new_position = [0, 1]
    movement.update_pieces(board, new_position)
  end

  it 'updates the board' do
    expect(movement.board).to eq(board)
  end

  it 'updates the position' do
    expect(movement.pos).to eq([0, 1])
  end
  
  it 'calls #update_moves' do
    expect(movement).to receive(:update_moves)
    pos = [0, 1]
    movement.update_pieces(board, pos)
  end

  it "calls ##{update_method}" do
    expect(movement).to receive(update_method)
    pos = [0, 1]
    movement.update_pieces(board, pos)
  end
end

RSpec.shared_examples 'observer management' do
  it 'removes captured piece from the observer list' do
    expect(board).to receive(:delete_observer)
    movement.remove_capture_piece_observer
  end
end

RSpec.shared_examples 'piece placement behavior' do |new_location|
  it 'it updates the value of the given board position to active piece' do
    movement.update_new_position
    new_position = movement.board.data[new_location.first][new_location.last]
    expect(new_position).to eq(board.active_piece)
  end
end

RSpec.shared_examples 'piece removal behavior' do |old_location|
  it 'updates the previous location of active_piece to nil' do
    movement.remove_original_piece
    old_location = movement.board.data[old_location.first][old_location.last]
    expect(old_location).to be nil
  end
end

RSpec.shared_examples 'update location behavior' do |new_location|
  it 'sends #update_location to active piece' do
    expect(board.active_piece).to receive(:update_location).with(new_location)
    movement.update_active_piece_location
  end
end

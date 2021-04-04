RSpec.describe Door do
  it 'synchronizes open statuses' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2'
    door = plot.connect room1, room2, 'east', type: Door
    door.open = true
    expect(door.reverse).to be_open
    door.open = false
    expect(door.reverse).to be_closed
  end
end

require 'gamefic-standard/pathfinder'

RSpec.describe Pathfinder do
  it 'returns an empty path for same origin and destination' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    pathfinder = Pathfinder.new(room, room)
    expect(pathfinder.path).to be_empty
  end

  it 'finds the shortest valid path' do
    plot = Gamefic::Plot.new
    pathfinder = plot.instance_exec do
      start = make Room, name: 'start'
      middle = make Room, name: 'middle'
      connect start, middle
      side1 = make Room, name: 'side1'
      connect middle, side1
      side2 = make Room, name: 'side2'
      connect side1, side2
      ending = make Room, name: 'end'
      connect middle, ending
      connect side2, ending

      Pathfinder.new(start, ending)
    end
    expect(pathfinder).to be_valid
    expect(pathfinder.path.length).to eq(2)
  end

  it 'reports invalid paths' do
    plot = Gamefic::Plot.new
    pathfinder = plot.instance_exec do
      start = make Room, name: 'start'
      ending = make Room, name: 'end'

      Pathfinder.new(start, ending)
    end
    expect(pathfinder).not_to be_valid
    expect(pathfinder.path).to be_empty
  end
end

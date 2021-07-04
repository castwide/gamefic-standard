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
    pathfinder = plot.stage do
      @start = make Room, name: 'start'
      @middle = make Room, name: 'middle'
      connect @start, @middle
      @side1 = make Room, name: 'side1'
      connect @middle, @side1
      @side2 = make Room, name: 'side2'
      connect @side1, @side2
      @end = make Room, name: 'end'
      connect @middle, @end
      connect @side2, @end

      Pathfinder.new(@start, @end)
    end
    expect(pathfinder).to be_valid
    expect(pathfinder.path.length).to eq(2)
  end

  it 'reports invalid paths' do
    plot = Gamefic::Plot.new
    pathfinder = plot.stage do
      @start = make Room, name: 'start'
      @end = make Room, name: 'end'

      Pathfinder.new(@start, @end)
    end
    expect(pathfinder).not_to be_valid
    expect(pathfinder.path).to be_empty
  end
end

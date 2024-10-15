require 'gamefic-standard/pathfinder'

RSpec.describe Gamefic::Standard::Pathfinder do
  let(:plot) { @klass.new }

  it 'returns an empty path for same origin and destination' do
    room = plot.make Room, name: 'room'
    pathfinder = Gamefic::Standard::Pathfinder.new(room, room)
    expect(pathfinder.path).to be_empty
  end

  it 'finds the shortest valid path' do
    pathfinder = plot.instance_exec do
      start = make Room, name: 'start'
      middle = make Room, name: 'middle'
      start.connect middle
      side1 = make Room, name: 'side1'
      middle.connect side1
      side2 = make Room, name: 'side2'
      side1.connect side2
      ending = make Room, name: 'end'
      middle.connect ending
      side2.connect ending

      Gamefic::Standard::Pathfinder.new(start, ending)
    end
    expect(pathfinder).to be_valid
    expect(pathfinder.path.length).to eq(2)
  end

  it 'reports invalid paths' do
    pathfinder = plot.instance_exec do
      start = make Room, name: 'start'
      ending = make Room, name: 'end'

      Gamefic::Standard::Pathfinder.new(start, ending)
    end
    expect(pathfinder).not_to be_valid
    expect(pathfinder.path).to be_empty
  end
end

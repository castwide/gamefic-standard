RSpec.describe Room do
  it 'connects by direction' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room
    room2 = plot.make Room
    plot.stage(room1, room2) do |room1, room2|
      connect room1, room2, 'east'
    end
    expect(room1.children.first.destination).to be(room2)
    expect(room1.children.first.direction.name).to eq('east')
    expect(room2.children.first.destination).to be(room1)
    expect(room2.children.first.direction.name).to eq('west')
  end

  it 'connects one way' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room
    room2 = plot.make Room
    plot.stage(room1, room2) do |room1, room2|
      connect room1, room2, 'east', two_way: false
    end
    expect(room1.children.first.destination).to be(room2)
    expect(room1.children.first.direction.name).to eq('east')
    expect(room2.children).to be_empty
  end

  it 'finds portals by direction' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room
    room2 = plot.make Room
    plot.stage(room1, room2) do |room1, room2|
      connect room1, room2, 'east'
    end
    portal = room1.find_portal('east')
    expect(portal.destination).to be(room2)
  end
end

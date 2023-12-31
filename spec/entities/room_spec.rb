RSpec.describe Room do
  let(:plot) { TestPlot.new }

  it 'connects by direction' do
    room1 = plot.make Room
    room2 = plot.make Room
    plot.instance_exec do
      connect room1, room2, 'east'
    end
    expect(room1.children.first.destination).to eq(room2)
    expect(room1.children.first.direction.name).to eq('east')
    expect(room2.children.first.destination).to eq(room1)
    expect(room2.children.first.direction.name).to eq('west')
  end

  it 'connects one way' do
    room1 = plot.make Room
    room2 = plot.make Room
    plot.instance_exec do
      connect room1, room2, 'east', two_way: false
    end
    expect(room1.children.first.destination).to eq(room2)
    expect(room1.children.first.direction.name).to eq('east')
    expect(room2.children).to be_empty
  end

  it 'finds portals by direction' do
    room1 = plot.make Room
    room2 = plot.make Room
    plot.instance_exec do
      connect room1, room2, 'east'
    end
    portal = room1.find_portal('east')
    expect(portal.destination).to eq(room2)
  end

  it 'sends messages to children' do
    room = plot.make Room
    char1 = plot.make Character, parent: room
    char2 = plot.make Character, parent: room
    room.tell 'Hello'
    expect(char1.messages).to include('Hello')
    expect(char2.messages).to include('Hello')
  end
end

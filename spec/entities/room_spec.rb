RSpec.describe Room do
  let(:plot) { @klass.new }

  it 'connects by direction' do
    room1 = plot.make Room
    room2 = plot.make Room
    plot.instance_exec do
      room1.connect room2, direction: 'east'
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
      room1.connect room2, direction: 'east', two_way: false
    end
    expect(room1.children.first.destination).to eq(room2)
    expect(room1.children.first.direction.name).to eq('east')
    expect(room2.children).to be_empty
  end

  it 'sends messages to children' do
    room = plot.make Room
    char1 = plot.make Character, parent: room
    char2 = plot.make Character, parent: room
    room.tell 'Hello'
    expect(char1.messages).to include('Hello')
    expect(char2.messages).to include('Hello')
  end

  it 'makes portals from direction attributes' do
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2', north: room1
    expect(room1.children.first.destination).to be(room2)
    expect(room2.children.first.destination).to be(room1)
  end

  it 'makes portals from the connect attribute' do
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2', connect: [room1, 'north']
    expect(room1.children.first.destination).to be(room2)
    expect(room2.children.first.destination).to be(room1)
  end

  it 'sets shared attributes' do
    room1 = Room.new(name: 'room 1')
    room2 = Room.new(name: 'room 2')
    portal1, portal2 = room1.connect room2, name: 'cubbyhole'
    expect(portal1.name).to eq('cubbyhole')
    expect(portal2.name).to eq('cubbyhole')
  end
end

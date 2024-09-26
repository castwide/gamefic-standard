RSpec.describe Portal do
  it 'finds its opposing portal' do
    room1 = Room.new(name: 'room 1')
    room2 = Room.new(name: 'room 2')
    room1.connect room2
    portal1 = room1.children.that_are(Portal).first
    portal2 = portal1.find_reverse
    expect(portal2.destination).to eq(room1)
  end
end

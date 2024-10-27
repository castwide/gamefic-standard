RSpec.describe Gamefic::Standard::Thing do
  it 'tracks its room' do
    room = Gamefic::Standard::Room.new
    container = Gamefic::Standard::Thing.new parent: room
    entity = Gamefic::Standard::Thing.new parent: container
    expect(entity.room).to be(room)
  end

  it 'attaches to parents' do
    container = Gamefic::Standard::Thing.new
    entity = Gamefic::Standard::Thing.new parent: container
    entity.attached = true
    expect(entity).to be_attached
  end

  it 'detaches from parents' do
    parent = Gamefic::Standard::Thing.new
    entity = Gamefic::Standard::Thing.new parent: parent
    entity.attached = true
    entity.parent = nil
    expect(entity).not_to be_attached
  end

  it 'does not attach to nil parents' do
    thing = Gamefic::Standard::Thing.new
    thing.attached = true
    expect(thing).not_to be_attached
  end
end
